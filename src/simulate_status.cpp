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
double setpoint_12, setpoint_22, setpoint_32, setpoint_42, setpoint_52;
double setpoint_13, setpoint_23, setpoint_33, setpoint_43, setpoint_53;
double setpoint_14, setpoint_24, setpoint_34, setpoint_44, setpoint_54;

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

void subCallback2(const movemaster_msg::setpoint::ConstPtr& rec_msg2)
{
    setpoint_12 = rec_msg2->set_1 * 185;
    setpoint_22 = rec_msg2->set_2 * 228;
    setpoint_32 = rec_msg2->set_3 * 186;
    setpoint_42 = rec_msg2->set_4 * 154.56;
    setpoint_52 = rec_msg2->set_5 * 116;

}

void subCallback3(const movemaster_msg::setpoint::ConstPtr& rec_msg3)
{
    setpoint_13 = rec_msg3->set_1 * 185;
    setpoint_23 = rec_msg3->set_2 * 228;
    setpoint_33 = rec_msg3->set_3 * 186;
    setpoint_43 = rec_msg3->set_4 * 154.56;
    setpoint_53 = rec_msg3->set_5 * 116;

}

void subCallback4(const movemaster_msg::setpoint::ConstPtr& rec_msg4)
{
    setpoint_14 = rec_msg4->set_1 * 185;
    setpoint_24 = rec_msg4->set_2 * 228;
    setpoint_34 = rec_msg4->set_3 * 186;
    setpoint_44 = rec_msg4->set_4 * 154.56;
    setpoint_54 = rec_msg4->set_5 * 116;

}

int main(int argc, char** argv) {
    ros::init(argc, argv, "simulate_status");
    ros::NodeHandle n;

    ros::Publisher pub_1 = n.advertise<movemaster_msg::status>("/status_1", 1);
    ros::Publisher pub_2 = n.advertise<movemaster_msg::status>("/status_2", 1);
    ros::Publisher pub_3 = n.advertise<movemaster_msg::status>("/status_3", 1);
    ros::Publisher pub_4 = n.advertise<movemaster_msg::status>("/status_4", 1);
    ros::Publisher pub_5 = n.advertise<movemaster_msg::status>("/status_5", 1);
    ros::Publisher pub_12 = n.advertise<movemaster_msg::status>("/status_12", 1);
    ros::Publisher pub_22 = n.advertise<movemaster_msg::status>("/status_22", 1);
    ros::Publisher pub_32 = n.advertise<movemaster_msg::status>("/status_32", 1);
    ros::Publisher pub_42 = n.advertise<movemaster_msg::status>("/status_42", 1);
    ros::Publisher pub_52 = n.advertise<movemaster_msg::status>("/status_52", 1);
    ros::Publisher pub_13 = n.advertise<movemaster_msg::status>("/status_13", 1);
    ros::Publisher pub_23 = n.advertise<movemaster_msg::status>("/status_23", 1);
    ros::Publisher pub_33 = n.advertise<movemaster_msg::status>("/status_33", 1);
    ros::Publisher pub_43 = n.advertise<movemaster_msg::status>("/status_43", 1);
    ros::Publisher pub_53 = n.advertise<movemaster_msg::status>("/status_53", 1);
    ros::Publisher pub_14 = n.advertise<movemaster_msg::status>("/status_14", 1);
    ros::Publisher pub_24 = n.advertise<movemaster_msg::status>("/status_24", 1);
    ros::Publisher pub_34 = n.advertise<movemaster_msg::status>("/status_34", 1);
    ros::Publisher pub_44 = n.advertise<movemaster_msg::status>("/status_44", 1);
    ros::Publisher pub_54 = n.advertise<movemaster_msg::status>("/status_54", 1);
    ros::Subscriber sub = n.subscribe("/setpoints", 1000, subCallback);
    ros::Subscriber sub2 = n.subscribe("/setpoints2", 1000, subCallback2);
    ros::Subscriber sub3 = n.subscribe("/setpoints3", 1000, subCallback3);
    ros::Subscriber sub4 = n.subscribe("/setpoints4", 1000, subCallback4);
    tf::TransformBroadcaster broadcaster;
    ros::Rate loop_rate(30);

    movemaster_msg::status pub_msg_1;
    movemaster_msg::status pub_msg_2;
    movemaster_msg::status pub_msg_3;
    movemaster_msg::status pub_msg_4;
    movemaster_msg::status pub_msg_5;
    movemaster_msg::status pub_msg_12;
    movemaster_msg::status pub_msg_22;
    movemaster_msg::status pub_msg_32;
    movemaster_msg::status pub_msg_42;
    movemaster_msg::status pub_msg_52;
    movemaster_msg::status pub_msg_13;
    movemaster_msg::status pub_msg_23;
    movemaster_msg::status pub_msg_33;
    movemaster_msg::status pub_msg_43;
    movemaster_msg::status pub_msg_53;
    movemaster_msg::status pub_msg_14;
    movemaster_msg::status pub_msg_24;
    movemaster_msg::status pub_msg_34;
    movemaster_msg::status pub_msg_44;
    movemaster_msg::status pub_msg_54;

    while (ros::ok()) {

        pub_msg_1.joint         =   "Joint 1";
        pub_msg_1.setpoint      =   setpoint_1;
        pub_msg_1.pulse_count   =   setpoint_1/185;
        pub_msg_1.IsDone = true;
        //pub_msg_1.pulse_count   =   encoder_count_1/185;
        //pub_msg_1.error         =   error_1;
        //pub_msg_1.output        =   output_1;
        //pub_msg_1.control_loop  =   control_loop_1;
        pub_msg_2.joint         =   "Joint 2";
        pub_msg_2.setpoint      =   setpoint_2;
        pub_msg_2.pulse_count   =   setpoint_2/228;
        pub_msg_2.IsDone = true;
        pub_msg_3.joint         =   "Joint 3";
        pub_msg_3.setpoint      =   setpoint_3;
        pub_msg_3.pulse_count   =   setpoint_3/186;
        pub_msg_3.IsDone = true;
        pub_msg_4.joint         =   "Joint 4";
        pub_msg_4.setpoint      =   setpoint_4;
        pub_msg_4.pulse_count   =   setpoint_4/154.56;
        pub_msg_4.IsDone = true;
        pub_msg_5.joint         =   "Joint 5";
        pub_msg_5.setpoint      =   setpoint_5;
        pub_msg_5.pulse_count   =   setpoint_5/116;
        pub_msg_5.IsDone = true;

        pub_msg_12.joint         =   "Joint 12";
        pub_msg_12.setpoint      =   setpoint_12;
        pub_msg_12.pulse_count   =   setpoint_12/185;
        pub_msg_12.IsDone = true;
        pub_msg_22.joint         =   "Joint 22";
        pub_msg_22.setpoint      =   setpoint_22;
        pub_msg_22.pulse_count   =   setpoint_22/228;
        pub_msg_22.IsDone = true;
        pub_msg_32.joint         =   "Joint 32";
        pub_msg_32.setpoint      =   setpoint_32;
        pub_msg_32.pulse_count   =   setpoint_32/186;
        pub_msg_32.IsDone = true;
        pub_msg_42.joint         =   "Joint 42";
        pub_msg_42.setpoint      =   setpoint_42;
        pub_msg_42.pulse_count   =   setpoint_42/154.56;
        pub_msg_42.IsDone = true;
        pub_msg_52.joint         =   "Joint 52";
        pub_msg_52.setpoint      =   setpoint_52;
        pub_msg_52.pulse_count   =   setpoint_52/116;
        pub_msg_52.IsDone = true;

        pub_msg_13.joint         =   "Joint 13";
        pub_msg_13.setpoint      =   setpoint_13;
        pub_msg_13.pulse_count   =   setpoint_13/185;
        pub_msg_13.IsDone = true;
        pub_msg_23.joint         =   "Joint 23";
        pub_msg_23.setpoint      =   setpoint_23;
        pub_msg_23.pulse_count   =   setpoint_23/228;
        pub_msg_23.IsDone = true;
        pub_msg_33.joint         =   "Joint 33";
        pub_msg_33.setpoint      =   setpoint_33;
        pub_msg_33.pulse_count   =   setpoint_33/186;
        pub_msg_33.IsDone = true;
        pub_msg_43.joint         =   "Joint 43";
        pub_msg_43.setpoint      =   setpoint_43;
        pub_msg_43.pulse_count   =   setpoint_43/154.56;
        pub_msg_43.IsDone = true;
        pub_msg_53.joint         =   "Joint 53";
        pub_msg_53.setpoint      =   setpoint_53;
        pub_msg_53.pulse_count   =   setpoint_53/116;
        pub_msg_53.IsDone = true;

        pub_msg_14.joint         =   "Joint 14";
        pub_msg_14.setpoint      =   setpoint_14;
        pub_msg_14.pulse_count   =   setpoint_14/185;
        pub_msg_14.IsDone = true;
        pub_msg_24.joint         =   "Joint 24";
        pub_msg_24.setpoint      =   setpoint_24;
        pub_msg_24.pulse_count   =   setpoint_24/228;
        pub_msg_24.IsDone = true;
        pub_msg_34.joint         =   "Joint 34";
        pub_msg_34.setpoint      =   setpoint_34;
        pub_msg_34.pulse_count   =   setpoint_34/186;
        pub_msg_34.IsDone = true;
        pub_msg_44.joint         =   "Joint 44";
        pub_msg_44.setpoint      =   setpoint_44;
        pub_msg_44.pulse_count   =   setpoint_44/154.56;
        pub_msg_44.IsDone = true;
        pub_msg_54.joint         =   "Joint 53";
        pub_msg_54.setpoint      =   setpoint_54;
        pub_msg_54.pulse_count   =   setpoint_54/116;
        pub_msg_54.IsDone = true;

        pub_1.publish(pub_msg_1);
        pub_2.publish(pub_msg_2);
        pub_3.publish(pub_msg_3);
        pub_4.publish(pub_msg_4);
        pub_5.publish(pub_msg_5);

        pub_12.publish(pub_msg_12);
        pub_22.publish(pub_msg_22);
        pub_32.publish(pub_msg_32);
        pub_42.publish(pub_msg_42);
        pub_52.publish(pub_msg_52);

        pub_13.publish(pub_msg_13);
        pub_23.publish(pub_msg_23);
        pub_33.publish(pub_msg_33);
        pub_43.publish(pub_msg_43);
        pub_53.publish(pub_msg_53);

        pub_14.publish(pub_msg_14);
        pub_24.publish(pub_msg_24);
        pub_34.publish(pub_msg_34);
        pub_44.publish(pub_msg_44);
        pub_54.publish(pub_msg_54);

        loop_rate.sleep();
        ros::spinOnce();
    }

    return 0;
}
