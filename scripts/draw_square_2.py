#!/usr/bin/env python

import rospy
from movemaster_msg.msg import setpoint

def main():
    rospy.init_node('draw_square')
    pub = rospy.Publisher('/setpoints', setpoint, queue_size=10)
    rospy.sleep(1)  # Wait for publisher to connect

    points = [
        dict(set_1=40.0,  set_2=104.0, set_3=-91.5, set_4=0, set_5=5),
        dict(set_1=-40.0, set_2=104.0, set_3=-91.5, set_4=0, set_5=5),
        dict(set_1=-40.0, set_2=104.0, set_3=-81.5, set_4=0, set_5=5),
        dict(set_1=40.0,  set_2=104.0, set_3=-81.5, set_4=0, set_5=5),
    ]

    for pt in points:
        msg = setpoint(
            set_1=pt['set_1'],
            set_2=pt['set_2'],
            set_3=pt['set_3'],
            set_4=pt['set_4'],
            set_5=pt['set_5'],
            set_GRIP=False,
            emergency_stop=False,
            GoHome=0
        )
        pub.publish(msg)
        rospy.loginfo("Published setpoint: %s", pt)
        rospy.sleep(2)  # Wait 2 seconds before next point

if __name__ == '__main__':
    main()