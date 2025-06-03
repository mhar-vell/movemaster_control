#include <ros/ros.h>
#include "movemaster_msg/setpoint.h"
#include <vector>
using namespace std;

int main(int argc, char** argv)
{
    ros::init(argc, argv, "draw_square_cpp");
    ros::NodeHandle nh;
    ros::Publisher pub = nh.advertise<movemaster_msg::setpoint>("/setpoints", 1000);
    ros::Rate rate(0.5); // 0.5 Hz = 2 seconds per point

    // Define the 4 square corners
    std::vector<movemaster_msg::setpoint> points(4);
    points[0].set_1 = 40.0;  points[0].set_2 = 104.0; points[0].set_3 = -91.5; points[0].set_4 = 0; points[0].set_5 = 5;
    points[1].set_1 = -40.0; points[1].set_2 = 104.0; points[1].set_3 = -91.5; points[1].set_4 = 0; points[1].set_5 = 5;
    points[2].set_1 = -40.0; points[2].set_2 = 104.0; points[2].set_3 = -81.5; points[2].set_4 = 0; points[2].set_5 = 5;
    points[3].set_1 = 40.0;  points[3].set_2 = 104.0; points[3].set_3 = -81.5; points[3].set_4 = 0; points[3].set_5 = 5;

    for (auto& pt : points) {
        pt.set_GRIP = false;
        pt.emergency_stop = false;
        pt.GoHome = 0;
    }

    // Wait for publisher to connect
    ros::Duration(1.0).sleep();

    for (size_t i = 0; i < points.size() && ros::ok(); ++i) {
        pub.publish(points[i]);
        ROS_INFO_STREAM("Published setpoint " << i+1);
        rate.sleep();
    }

    return 0;
}