#include <ros/ros.h>
#include <visualization_msgs/Marker.h>
#include <geometry_msgs/Pose.h>
#include <std_msgs/Float32.h>
#include <geometry_msgs/Quaternion.h>


#include <cmath>

bool received_position = false;
bool received_orientation = false;
bool received_ceiling = false;
bool received_right = false;
bool received_left = false;
bool received_ceilingORI = false;
bool received_rightORI = false;
bool received_leftORI = false;

visualization_msgs::Marker points, orient, cageL, cageR, cageC, cageF;

geometry_msgs::Quaternion cageLORI, cageRORI, cageCORI;

float ceiling, left, right;

void subCallbackPOSITION(const geometry_msgs::Point::ConstPtr& msg1){

    geometry_msgs::Point p;
    p.x = msg1->x;
    p.y = msg1->y;
    p.z = msg1->z;

    points.points.push_back(p);
    orient.pose.position = p;
    received_position = true;
}

void subCallbackORIENTATION(const geometry_msgs::Quaternion::ConstPtr& msg2){

    geometry_msgs::Quaternion q;
    q.w = msg2->w;
    q.x = msg2->x;
    q.y = msg2->y;
    q.z = msg2->z;

    orient.pose.orientation = q;
    received_orientation = true;
}

void subCallbackCEILING(const std_msgs::Float32::ConstPtr& msg3){
    ceiling = msg3->data;
    received_ceiling = true;
}

void subCallbackLEFT(const std_msgs::Float32::ConstPtr& msg4){
    left = msg4->data;
    received_left = true;
}

void subCallbackRIGHT(const std_msgs::Float32::ConstPtr& msg5){
    right = msg5->data;
    received_right = true;
}

void subCallbackLEFTORI(const geometry_msgs::Quaternion::ConstPtr& msg6){
    cageLORI.w = msg6->w;
    cageLORI.x = msg6->x;
    cageLORI.y = msg6->y;
    cageLORI.z = msg6->z;
    received_leftORI = true;
}

void subCallbackRIGHTORI(const geometry_msgs::Quaternion::ConstPtr& msg7){
    cageRORI.w = msg7->w;
    cageRORI.x = msg7->x;
    cageRORI.y = msg7->y;
    cageRORI.z = msg7->z;
    received_rightORI = true;
}

void subCallbackCEILINGORI(const geometry_msgs::Quaternion::ConstPtr& msg8){
    cageCORI.w = msg8->w;
    cageCORI.x = msg8->x;
    cageCORI.y = msg8->y;
    cageCORI.z = msg8->z;
    received_ceilingORI = true;
}

int main( int argc, char** argv )
{
  ros::init(argc, argv, "marker_publisherNOVO");
  ros::NodeHandle n;
  ros::Publisher marker_pub = n.advertise<visualization_msgs::Marker>("visualization_marker", 10);

  ros::Subscriber sub1 = n.subscribe("/effectorPosition", 1000, subCallbackPOSITION);
  ros::Subscriber sub2 = n.subscribe("/effectorOrientation", 1000, subCallbackORIENTATION);
  ros::Subscriber sub3 = n.subscribe("/ceiling", 1000, subCallbackCEILING);
  ros::Subscriber sub4 = n.subscribe("/left", 1000, subCallbackLEFT);
  ros::Subscriber sub5 = n.subscribe("/right", 1000, subCallbackRIGHT);
  ros::Subscriber sub6 = n.subscribe("/ceilingORI", 1000, subCallbackCEILINGORI);
  ros::Subscriber sub7 = n.subscribe("/leftORI", 1000, subCallbackLEFTORI);
  ros::Subscriber sub8 = n.subscribe("/rightORI", 1000, subCallbackRIGHTORI);

  ros::Rate loop_rate(30);

  float f = 0.0;
  while (ros::ok())
  {

    points.header.frame_id = orient.header.frame_id = cageL.header.frame_id = cageR.header.frame_id = cageC.header.frame_id = cageF.header.frame_id = "/odom";
    points.header.stamp = orient.header.stamp = cageL.header.stamp = cageR.header.stamp = cageC.header.stamp = cageF.header.stamp = ros::Time::now();
    points.ns = orient.ns = cageL.ns = cageR.ns = cageC.ns = cageF.ns = "marker_publisher";
    points.action = orient.action = cageL.action = cageR.action = cageC.action = cageF.action = visualization_msgs::Marker::ADD;
    points.pose.orientation.w = orient.pose.orientation.w = cageL.pose.orientation.w = cageR.pose.orientation.w = cageC.pose.orientation.w = cageF.pose.orientation.w = 1.0;

    points.id = 0;
    orient.id = 1;
    cageL.id = 2;
    cageR.id = 3;
    cageC.id = 4;
    cageF.id = 5;

    points.type = visualization_msgs::Marker::POINTS;
    orient.type = visualization_msgs::Marker::ARROW;
    cageL.type = visualization_msgs::Marker::CUBE;
    cageR.type = visualization_msgs::Marker::CUBE;
    cageC.type = visualization_msgs::Marker::CUBE;
    cageF.type = visualization_msgs::Marker::CUBE;


    points.scale.x = 0.005;
    points.scale.y = 0.005;

    orient.scale.x = 0.05;
    orient.scale.y = 0.008;
    orient.scale.z = 0.008;

    // Points are green
    points.color.g = 1.0;
    points.color.a = 1.0;

    // Arrow is blue
    orient.color.b = 1.0;
    orient.color.a = 1.0;

    //Cube is gray and transparent
    cageL.color.r = cageR.color.r = cageC.color.r = cageF.color.r = 0.40;
    cageL.color.g = cageR.color.g = cageC.color.g = cageF.color.g = 0.40;
    cageL.color.b = cageR.color.b = cageC.color.b = cageF.color.b = 0.40;
    cageL.color.a = cageR.color.a = cageC.color.a = cageF.color.a = 0.5;

    if (received_position){
      marker_pub.publish(points);}

    //if (received_orientation){
      //marker_pub.publish(orient);}

    if (received_ceiling && received_left && received_right && received_ceilingORI && received_leftORI && received_rightORI){

      cageL.scale.x = ceiling;
      cageL.scale.y = 0.02;
      cageL.scale.z = 0.6;
      cageL.pose.position.x = 0.7;
      cageL.pose.position.y = left;
      cageL.pose.position.z = ceiling/2;
      cageL.pose.orientation = cageLORI;
      marker_pub.publish(cageL);

      cageR.scale.x = ceiling;
      cageR.scale.y = 0.02;
      cageR.scale.z = 0.6;
      cageR.pose.position.x = 0.7;
      cageR.pose.position.y = right;
      cageR.pose.position.z = ceiling/2;
      cageR.pose.orientation = cageRORI;
      marker_pub.publish(cageR);

      cageC.scale.x = abs(right-left);
      cageC.scale.y = 0.6;
      cageC.scale.z = 0.02;
      cageC.pose.position.x = 0.7;
      cageC.pose.position.y = (right+left)/2;
      cageC.pose.position.z = ceiling;
      cageC.pose.orientation = cageCORI;
      marker_pub.publish(cageC);

      cageF.scale.x = 0.02;
      cageF.scale.y = abs(right-left);
      cageF.scale.z = ceiling;
      cageF.pose.position.x = 0.9;
      cageF.pose.position.y = 0;
      cageF.pose.position.z = ceiling/2;
      marker_pub.publish(cageF);

      }

    loop_rate.sleep();
    ros::spinOnce();
  }
}