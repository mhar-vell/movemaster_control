#include <ros/ros.h>
#include "movemaster_msg/status.h"
#include <cstdlib>
#include <iostream>
#include <ros/console.h>

bool J[5], checksum;

void subCallback_1(const movemaster_msg::status::ConstPtr& msg1){
    J[1] = msg1->IsDone;
}

void subCallback_2(const movemaster_msg::status::ConstPtr& msg2){
    J[2] = msg2->IsDone;
}

void subCallback_3(const movemaster_msg::status::ConstPtr& msg3){
    J[3] = msg3->IsDone;
}

void subCallback_4(const movemaster_msg::status::ConstPtr& msg4){
    J[4] = msg4->IsDone;
}

void subCallback_5(const movemaster_msg::status::ConstPtr& msg5){
    J[5] = msg5->IsDone;
}

int main(int argc, char** argv) {
    ros::init(argc, argv, "camera_launcher");
    ros::NodeHandle n;

    ros::Subscriber sub1 = n.subscribe("status_1", 1000, subCallback_1);
    ros::Subscriber sub2 = n.subscribe("status_2", 1000, subCallback_2);
    ros::Subscriber sub3 = n.subscribe("status_3", 1000, subCallback_3);
    ros::Subscriber sub4 = n.subscribe("status_4", 1000, subCallback_4);
    ros::Subscriber sub5 = n.subscribe("status_5", 1000, subCallback_5);
    ros::Rate loop_rate(30);

    J[1] = false;
    J[2] = false;
    J[3] = false;
    J[4] = false;
    J[5] = false;
    checksum = false;

    while (!checksum) {
        if(J[0] && J[1] && J[2] && J[3] && J[4] && J[5]){
            checksum = true;
        }
        ros::spinOnce();
    }

    std::system("roslaunch movemaster_control camera.launch");

    return 0;
}