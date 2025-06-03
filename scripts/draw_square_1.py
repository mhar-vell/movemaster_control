#!/usr/bin/env python

import rospy
from movemaster_msg.msg import setpoint
import time

def main():
    pub = rospy.Publisher('/setpoints', setpoint, queue_size=10)
    rospy.init_node('draw_square', anonymous=True)
    rate = rospy.Rate(0.5)  # 0.5 Hz = 2 seconds per point

    points = [
        setpoint(set_1=40.0, set_2=104.0, set_3=-91.5, set_4=0, set_5=5, set_GRIP=False, emergency_stop=False, GoHome=0),
        setpoint(set_1=-40.0, set_2=104.0, set_3=-91.5, set_4=0, set_5=5, set_GRIP=False, emergency_stop=False, GoHome=0),
        setpoint(set_1=-40.0, set_2=104.0, set_3=-81.5, set_4=0, set_5=5, set_GRIP=False, emergency_stop=False, GoHome=0),
        setpoint(set_1=40.0, set_2=104.0, set_3=-81.5, set_4=0, set_5=5, set_GRIP=False, emergency_stop=False, GoHome=0),
    ]

    for pt in points:
        pub.publish(pt)
        rate.sleep()

if __name__ == '__main__':
    main()