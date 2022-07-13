#include "std_msgs/String.h"
#include <ros/ros.h>
#include <sensor_msgs/JointState.h>
#include <tf/transform_broadcaster.h>
#include "movemaster_msg/status.h"
#include "movemaster_msg/setpoint.h"
#include <nav_msgs/Odometry.h>
#include <geometry_msgs/Pose.h>
#include <cstdlib>

double setpoint_1, setpoint_2, setpoint_3, setpoint_4, setpoint_5;

void subCallback(const movemaster_msg::setpoint::ConstPtr& rec_msg)
{
    setpoint_1 = rec_msg->set_1 * 185;
    setpoint_2 = rec_msg->set_2 * 228;
    setpoint_3 = rec_msg->set_3 * 186;
    setpoint_4 = rec_msg->set_4 * 154.56;
    setpoint_5 = rec_msg->set_5 * 116;
    //EMERGENCY_STOP = rec_msg.emergency_stop;
    //GOHOME = rec_msg.GoHome;

    /*
    if(EMERGENCY_STOP){
    motorGo(MOTOR_1, STOP, 0);
    motorGo(MOTOR_2, STOP, 0);
    brake_lock();
    }
  
    if(GOHOME) GoHome();
    */
}

int main(int argc, char** argv) {
    ros::init(argc, argv, "simulate_status");
    ros::NodeHandle n;

    ros::Publisher pub_1 = n.advertise<movemaster_msg::status>("/status_1", 1);
    ros::Publisher pub_2 = n.advertise<movemaster_msg::status>("/status_2", 1);
    ros::Publisher pub_3 = n.advertise<movemaster_msg::status>("/status_3", 1);
    ros::Publisher pub_4 = n.advertise<movemaster_msg::status>("/status_4", 1);
    ros::Publisher pub_5 = n.advertise<movemaster_msg::status>("/status_5", 1);
    ros::Subscriber sub = n.subscribe("/setpoints", 1000, subCallback);
    tf::TransformBroadcaster broadcaster;
    ros::Rate loop_rate(30);

    movemaster_msg::status pub_msg_1;
    movemaster_msg::status pub_msg_2;
    movemaster_msg::status pub_msg_3;
    movemaster_msg::status pub_msg_4;
    movemaster_msg::status pub_msg_5;

    while (ros::ok()) {

        pub_msg_1.joint         =   "Joint 1";
        pub_msg_1.setpoint      =   setpoint_1;
        pub_msg_1.pulse_count   =   setpoint_1/185;
        //pub_msg_1.pulse_count   =   encoder_count_1/185;
        //pub_msg_1.error         =   error_1;
        //pub_msg_1.output        =   output_1;
        //pub_msg_1.control_loop  =   control_loop_1;
        pub_msg_2.joint         =   "Joint 2";
        pub_msg_2.setpoint      =   setpoint_2;
        pub_msg_2.pulse_count   =   setpoint_2/228;
        pub_msg_3.joint         =   "Joint 3";
        pub_msg_3.setpoint      =   setpoint_3;
        pub_msg_3.pulse_count   =   setpoint_3/186;
        pub_msg_4.joint         =   "Joint 4";
        pub_msg_4.setpoint      =   setpoint_4;
        pub_msg_4.pulse_count   =   setpoint_4/154.56;
        pub_msg_5.joint         =   "Joint 5";
        pub_msg_5.setpoint      =   setpoint_5;
        pub_msg_5.pulse_count   =   setpoint_5/116;

        pub_1.publish(pub_msg_1);
        pub_2.publish(pub_msg_2);
        pub_3.publish(pub_msg_3);
        pub_4.publish(pub_msg_4);
        pub_5.publish(pub_msg_5);

        loop_rate.sleep();
        ros::spinOnce();
    }

    return 0;
}
