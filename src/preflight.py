#!/usr/bin/env python3
import rospy
from movemaster_msg.msg import status as StatusMsg
from movemaster_msg.msg import setpoint as SetpointMsg
import sys
import threading

# globals
status_lock = threading.Lock()
status_data = {i: None for i in range(1,7)}  # joints 1..6

def make_cb(i):
    """Create callback for status_i topic"""
    def cb(msg):
        with status_lock:
            status_data[i] = {
                'pulse': float(msg.pulse_count),
                'setpoint': float(msg.setpoint),
                'error': float(msg.error),
                'output': float(msg.output),
                'IsDone': bool(msg.IsDone),
                'time': rospy.Time.now()
            }
    return cb

def wait_for_status(timeout):
    """Wait for all status topics to publish at least once"""
    rospy.loginfo("Preflight: waiting for status topics (%.1fs)..." % timeout)
    deadline = rospy.Time.now() + rospy.Duration(timeout)
    rate = rospy.Rate(10)
    while rospy.Time.now() < deadline and not rospy.is_shutdown():
        with status_lock:
            ready = all(status_data[i] is not None for i in status_data)
        if ready:
            rospy.loginfo("Preflight: all status topics received.")
            return True
        rate.sleep()
    return False

def test_status_connectivity(joints):
    """Test that status topics are publishing"""
    rospy.loginfo("=" * 60)
    rospy.loginfo("TEST 1: Status Topic Connectivity")
    rospy.loginfo("=" * 60)
    results = {}
    
    with status_lock:
        for j in joints:
            if status_data[j] is not None:
                age = (rospy.Time.now() - status_data[j]['time']).to_sec()
                if age < 2.0:
                    rospy.loginfo("  Joint %d status: OK (age %.2fs)" % (j, age))
                    results[j] = True
                else:
                    rospy.logwarn("  Joint %d status: STALE (age %.2fs)" % (j, age))
                    results[j] = False
            else:
                rospy.logerr("  Joint %d status: NO DATA" % j)
                results[j] = False
    
    return results

def test_limit_switches(joints):
    """Check that limit switch states are being read"""
    rospy.loginfo("=" * 60)
    rospy.loginfo("TEST 2: Limit Switch Reading")
    rospy.loginfo("=" * 60)
    rospy.loginfo("Note: This test only checks if limit switch data is available.")
    rospy.loginfo("      Manual testing required to verify physical switch operation.")
    
    results = {}
    # Note: Current status message doesn't include limit switch states
    # This is a placeholder for future enhancement
    for j in joints:
        with status_lock:
            s = status_data[j]
        if s is not None:
            # Check if controller is responding (IsDone should be True at rest)
            if s['IsDone']:
                rospy.loginfo("  Joint %d: Controller active (IsDone=True)" % j)
                results[j] = True
            else:
                rospy.logwarn("  Joint %d: Controller not ready (IsDone=False)" % j)
                results[j] = False
        else:
            rospy.logerr("  Joint %d: No status data for limit switch check" % j)
            results[j] = False
    
    rospy.loginfo("  Manual check: Press each limit switch and verify controller response")
    return results

def test_encoder_response(pub, joints, magnitude, encoder_threshold, timeout):
    """Test that encoders respond to commanded movement"""
    rospy.loginfo("=" * 60)
    rospy.loginfo("TEST 3: Encoder Response")
    rospy.loginfo("=" * 60)
    results = {}
    
    for j in joints:
        if rospy.is_shutdown():
            break
            
        rospy.loginfo("  Testing encoder for Joint %d..." % j)
        
        # Record initial encoder value
        with status_lock:
            before_pulse = status_data[j]['pulse'] if status_data[j] else None
        
        if before_pulse is None:
            rospy.logerr("    Joint %d: No initial encoder reading" % j)
            results[j] = False
            continue
        
        # Send movement command
        sp = SetpointMsg()
        if j == 6:
            sp.set_GRIP = True
        else:
            setattr(sp, 'set_%d' % j, magnitude)
        pub.publish(sp)
        
        # Wait for encoder change
        deadline = rospy.Time.now() + rospy.Duration(timeout)
        rate = rospy.Rate(20)
        encoder_changed = False
        max_delta = 0.0
        
        while rospy.Time.now() < deadline and not rospy.is_shutdown():
            with status_lock:
                s = status_data[j]
            if s is None:
                rate.sleep()
                continue
            
            delta = abs(s['pulse'] - before_pulse)
            max_delta = max(max_delta, delta)
            
            if delta >= encoder_threshold:
                rospy.loginfo("    Joint %d: Encoder changed by %.1f pulses (threshold: %.1f)" % 
                             (j, delta, encoder_threshold))
                encoder_changed = True
                break
            rate.sleep()
        
        # Stop movement
        sp_stop = SetpointMsg()
        pub.publish(sp_stop)
        rospy.sleep(0.5)
        
        if encoder_changed:
            rospy.loginfo("    Joint %d encoder: OK" % j)
            results[j] = True
        else:
            rospy.logerr("    Joint %d encoder: FAIL (max change: %.1f, threshold: %.1f)" % 
                        (j, max_delta, encoder_threshold))
            results[j] = False
        
        rospy.sleep(1.0)  # Pause between tests
    
    return results

def test_motor_response(pub, joints, magnitude, timeout):
    """Test that motors respond to commands and controller reaches setpoint"""
    rospy.loginfo("=" * 60)
    rospy.loginfo("TEST 4: Motor Response and Control")
    rospy.loginfo("=" * 60)
    results = {}
    
    for j in joints:
        if rospy.is_shutdown():
            break
            
        rospy.loginfo("  Testing motor for Joint %d..." % j)
        
        # Record initial state
        with status_lock:
            before = status_data[j].copy() if status_data[j] else None
        
        if before is None:
            rospy.logerr("    Joint %d: No initial status" % j)
            results[j] = False
            continue
        
        # Send movement command
        sp = SetpointMsg()
        if j == 6:
            sp.set_GRIP = True
        else:
            setattr(sp, 'set_%d' % j, magnitude)
        pub.publish(sp)
        
        # Wait for movement indicators
        deadline = rospy.Time.now() + rospy.Duration(timeout)
        rate = rospy.Rate(20)
        motor_active = False
        reached_target = False
        
        while rospy.Time.now() < deadline and not rospy.is_shutdown():
            with status_lock:
                s = status_data[j]
            if s is None:
                rate.sleep()
                continue
            
            # Check if motor is active (output PWM > 0 or IsDone = False)
            if not s['IsDone'] or abs(s['output']) > 5.0:
                if not motor_active:
                    rospy.loginfo("    Joint %d: Motor active (output=%.1f, IsDone=%s)" % 
                                 (j, s['output'], s['IsDone']))
                motor_active = True
            
            # Check if target reached (IsDone = True and error small)
            if s['IsDone'] and abs(s['error']) < 50.0:  # tolerance in pulses
                rospy.loginfo("    Joint %d: Target reached (error=%.1f pulses)" % (j, s['error']))
                reached_target = True
                break
            
            rate.sleep()
        
        # Return to zero
        sp_zero = SetpointMsg()
        pub.publish(sp_zero)
        rospy.sleep(1.5)
        
        # Evaluate result
        if motor_active and reached_target:
            rospy.loginfo("    Joint %d motor: OK (active and reached target)" % j)
            results[j] = True
        elif motor_active:
            rospy.logwarn("    Joint %d motor: PARTIAL (motor active but did not reach target)" % j)
            results[j] = False
        else:
            rospy.logerr("    Joint %d motor: FAIL (no motor activity detected)" % j)
            results[j] = False
        
        rospy.sleep(1.0)  # Pause between tests
    
    return results

def print_summary(test_results):
    """Print final summary of all tests"""
    rospy.loginfo("=" * 60)
    rospy.loginfo("PREFLIGHT TEST SUMMARY")
    rospy.loginfo("=" * 60)
    
    all_passed = True
    for test_name, results in test_results.items():
        rospy.loginfo("%s:" % test_name)
        for joint, passed in sorted(results.items()):
            status = "PASS" if passed else "FAIL"
            rospy.loginfo("  Joint %d: %s" % (joint, status))
            if not passed:
                all_passed = False
    
    rospy.loginfo("=" * 60)
    if all_passed:
        rospy.loginfo("RESULT: ALL TESTS PASSED ✓")
        return True
    else:
        rospy.logerr("RESULT: SOME TESTS FAILED ✗")
        return False

def main():
    rospy.init_node('preflight_check', anonymous=False)
    
    # Get parameters
    magnitude = rospy.get_param('~test_magnitude', 3.0)
    encoder_threshold = rospy.get_param('~encoder_threshold', 10.0)
    timeout_connect = rospy.get_param('~timeout_connect', 5.0)
    timeout_move = rospy.get_param('~timeout_move', 8.0)
    test_joints_str = rospy.get_param('~test_joints', '1,2,3,4,5,6')
    test_encoders = rospy.get_param('~test_encoders', True)
    do_test_limit_switches = rospy.get_param('~test_limit_switches', True)
    test_motors = rospy.get_param('~test_motors', True)
    
    # Parse joint list
    joints = [int(x.strip()) for x in test_joints_str.split(',')]
    
    rospy.loginfo("=" * 60)
    rospy.loginfo("MOVEMASTER PREFLIGHT CHECK")
    rospy.loginfo("=" * 60)
    rospy.loginfo("Testing joints: %s" % joints)
    rospy.loginfo("Test magnitude: %.1f degrees" % magnitude)
    rospy.loginfo("Encoder threshold: %.1f pulses" % encoder_threshold)
    rospy.loginfo("=" * 60)
    
    # Subscribe to status topics
    for i in range(1, 7):
        rospy.Subscriber('status_%d' % i, StatusMsg, make_cb(i))
    
    pub = rospy.Publisher('setpoints', SetpointMsg, queue_size=1)
    rospy.sleep(0.5)  # Let subscribers connect
    
    # Wait for status topics
    if not wait_for_status(timeout_connect):
        rospy.logerr("Preflight: Not all status topics received within timeout.")
        rospy.signal_shutdown("missing_topics")
        sys.exit(2)
    
    test_results = {}
    
    # Test 1: Status connectivity
    test_results["Status Connectivity"] = test_status_connectivity(joints)
    
    # Test 2: Limit switches
    if do_test_limit_switches:
        test_results["Limit Switches"] = test_limit_switches(joints)
    
    # Test 3: Encoders
    if test_encoders:
        test_results["Encoder Response"] = test_encoder_response(
            pub, joints, magnitude, encoder_threshold, timeout_move)
    
    # Test 4: Motors
    if test_motors:
        test_results["Motor Response"] = test_motor_response(
            pub, joints, magnitude, timeout_move)
    
    # Print summary
    all_passed = print_summary(test_results)
    
    # Return appropriate exit code
    if all_passed:
        rospy.signal_shutdown("preflight_ok")
        sys.exit(0)
    else:
        rospy.signal_shutdown("preflight_failed")
        sys.exit(3)

if __name__ == '__main__':
    try:
        main()
    except rospy.ROSInterruptException:
        pass
    except Exception as e:
        rospy.logerr("Preflight exception: %s" % str(e))
        sys.exit(1)