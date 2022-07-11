#include "std_msgs/String.h"
#include <ros/ros.h>
#include <sensor_msgs/JointState.h>
#include <tf/transform_broadcaster.h>
#include "movemaster_msg/status.h"
#include <nav_msgs/Odometry.h>
#include <geometry_msgs/Pose.h>
#include <cstdlib>

double J1, J2, J3, J4, J5, J6;
geometry_msgs::PoseStamped odometry_frame;

void subCallback_1(const movemaster_msg::status::ConstPtr& msg1){J1 = msg1->pulse_count*M_PI/180;}
void subCallback_2(const movemaster_msg::status::ConstPtr& msg2){J2 = msg2->pulse_count*M_PI/180;}
void subCallback_3(const movemaster_msg::status::ConstPtr& msg3){J3 = msg3->pulse_count*M_PI/180;}
void subCallback_4(const movemaster_msg::status::ConstPtr& msg4){J4 = msg4->pulse_count*M_PI/180;}
void subCallback_5(const movemaster_msg::status::ConstPtr& msg5){J5 = msg5->pulse_count*M_PI/180;}
void subCallback_6(const movemaster_msg::status::ConstPtr& msg6){J6 = msg6->pulse_count*M_PI/180;}

void subCallback_7(const nav_msgs::Odometry::ConstPtr& msg7){
    odometry_frame.pose.position.x = msg7->pose.pose.position.x + 0.375;
    odometry_frame.pose.position.y = msg7->pose.pose.position.y + 0.000;
    odometry_frame.pose.position.z = msg7->pose.pose.position.z + 0.625;
    odometry_frame.pose.orientation.x = msg7->pose.pose.orientation.x;
    odometry_frame.pose.orientation.y = msg7->pose.pose.orientation.y;
    odometry_frame.pose.orientation.z = msg7->pose.pose.orientation.z;
    odometry_frame.pose.orientation.w = msg7->pose.pose.orientation.w;
}

int main(int argc, char** argv) {
    ros::init(argc, argv, "state_publisher");
    ros::NodeHandle n;

    ros::Publisher joint_pub = n.advertise<sensor_msgs::JointState>("joint_states", 1);
    ros::Subscriber sub1 = n.subscribe("status_1", 1000, subCallback_1);
    ros::Subscriber sub2 = n.subscribe("status_2", 1000, subCallback_2);
    ros::Subscriber sub3 = n.subscribe("status_3", 1000, subCallback_3);
    ros::Subscriber sub4 = n.subscribe("status_4", 1000, subCallback_4);
    ros::Subscriber sub5 = n.subscribe("status_5", 1000, subCallback_5);
    ros::Subscriber sub6 = n.subscribe("status_6", 1000, subCallback_6);
    tf::TransformBroadcaster broadcaster;
    ros::Rate loop_rate(30);

    ros::Subscriber sub7 = n.subscribe("/t265/odom/sample", 1000, subCallback_7);

    const double angle = 0;

    geometry_msgs::TransformStamped odom_trans;
    sensor_msgs::JointState joint_state;

    odom_trans.header.frame_id = "odom";
    odom_trans.child_frame_id = "Base";

    geometry_msgs::TransformStamped odometry_trans;

    joint_state.name.resize(5);
    joint_state.position.resize(5);
    joint_state.name[0] ="J1";
    joint_state.name[1] ="J2";
    joint_state.name[2] ="J3";
    joint_state.name[3] ="J4";
    joint_state.name[4] ="J5";

    while (ros::ok()) {

        joint_state.header.stamp = ros::Time::now();
        joint_state.position[0] = J1;
        joint_state.position[1] = J2;
        joint_state.position[2] = J3;
        joint_state.position[3] = J4;
        joint_state.position[4] = J5+J4;

        odom_trans.header.stamp = ros::Time::now();
        odom_trans.transform.translation.x = 0;
        odom_trans.transform.translation.y = 0;
        odom_trans.transform.translation.z = 0;
        odom_trans.transform.rotation = tf::createQuaternionMsgFromYaw(angle);

        odometry_trans.header.stamp = ros::Time::now();
        odometry_trans.header.frame_id = "odom";
        odometry_trans.child_frame_id = "t265_odom_frame";
        
        odometry_trans.transform.translation.x = odometry_frame.pose.position.x;
        odometry_trans.transform.translation.y = odometry_frame.pose.position.y;
        odometry_trans.transform.translation.z = odometry_frame.pose.position.z;

        odometry_trans.transform.rotation = odometry_frame.pose.orientation;
        if (odometry_trans.transform.rotation.x == 0 && odometry_trans.transform.rotation.y == 0 && odometry_trans.transform.rotation.z == 0){
            odometry_trans.transform.rotation.w = 1;
        }
        
        broadcaster.sendTransform(odom_trans);
        broadcaster.sendTransform(odometry_trans);
        joint_pub.publish(joint_state);

        loop_rate.sleep();
        ros::spinOnce();
    }

    return 0;
}