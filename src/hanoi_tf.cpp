#include <ros/ros.h>
#include <tf/transform_broadcaster.h>
#include <std_msgs/Int32MultiArray.h>

double pino1 = 0.0, pino2 = 0.088, pino3 = 0.176, pino4 = 0.264;
double baixo = 0.0, medio = 0.013, alto = 0.026;
double pino_v1, pino_v2, pino_v3, pino_v4, pino_v5, pino_v6;
double altura_v1, altura_v2, altura_v3, altura_v4, altura_v5, altura_v6;

double define_pino(double d)
{
    double p;
    if (d == 1 || d == 2 || d == 3){p = pino1;}
    else if (d == 4 || d == 5 || d == 6){p = pino2;}
    else if (d == 7 || d == 8 || d == 9){p = pino3;}
    else if (d == 10 || d == 11 || d == 12){p = pino4;}
    else {p = 0.0;}
    return p;
}

double define_altura(double d)
{
    double a;
    if (d == 1 || d == 4 || d == 7 || d == 10){a = baixo;}
    else if (d == 2 || d == 5 || d == 8 || d == 11){a = medio;}
    else if (d == 3 || d == 6 || d == 9 || d == 12){a = alto;}
    else {a = 0.0;}
    return a;
}

void Callback(const std_msgs::Int32MultiArray::ConstPtr &msg)
{
    pino_v1 = define_pino(msg->data[0]);
    altura_v1 = define_altura(msg->data[0]);
    pino_v2 = define_pino(msg->data[1]);
    altura_v2 = define_altura(msg->data[1]);
    pino_v3 = define_pino(msg->data[2]);
    altura_v3 = define_altura(msg->data[2]);
    pino_v4 = define_pino(msg->data[3]);
    altura_v4 = define_altura(msg->data[3]);
    pino_v5 = define_pino(msg->data[4]);
    altura_v5 = define_altura(msg->data[4]);
    pino_v6 = define_pino(msg->data[5]);
    altura_v6 = define_altura(msg->data[5]);

}

int main(int argc, char **argv)
{

    ros::init(argc, argv, "hanoi_tf");
    ros::NodeHandle node;
    ros::Subscriber sub = node.subscribe("/hanoi_status", 1000, Callback);

    static tf::TransformBroadcaster br_v1; // peca vermelha 1 - maior
    static tf::TransformBroadcaster br_v2;
    static tf::TransformBroadcaster br_v3;
    static tf::TransformBroadcaster br_v4; // peca verde 1 - maior
    static tf::TransformBroadcaster br_v5;
    static tf::TransformBroadcaster br_v6;
    tf::Transform transform_v1;
    tf::Transform transform_v2;
    tf::Transform transform_v3;
    tf::Transform transform_v4;
    tf::Transform transform_v5;
    tf::Transform transform_v6;
    tf::Quaternion q;
    q.setRPY(0, 0, 0);
    transform_v1.setRotation(q);
    transform_v2.setRotation(q);
    transform_v3.setRotation(q);
    transform_v4.setRotation(q);
    transform_v5.setRotation(q);
    transform_v6.setRotation(q);

    while (ros::ok())
    {

        transform_v1.setOrigin(tf::Vector3(pino_v1, 0.0, altura_v1));
        transform_v2.setOrigin(tf::Vector3(pino_v2, 0.0, altura_v2));
        transform_v3.setOrigin(tf::Vector3(pino_v3, 0.0, altura_v3));
        transform_v4.setOrigin(tf::Vector3(pino_v4, 0.0, altura_v4));
        transform_v5.setOrigin(tf::Vector3(pino_v5, 0.0, altura_v5));
        transform_v6.setOrigin(tf::Vector3(pino_v6, 0.0, altura_v6));
        br_v1.sendTransform(tf::StampedTransform(transform_v1, ros::Time::now(), "hanoi_base", "hanoi_p1"));
        br_v2.sendTransform(tf::StampedTransform(transform_v2, ros::Time::now(), "hanoi_base", "hanoi_p2"));
        br_v3.sendTransform(tf::StampedTransform(transform_v3, ros::Time::now(), "hanoi_base", "hanoi_p3"));
        br_v4.sendTransform(tf::StampedTransform(transform_v4, ros::Time::now(), "hanoi_base", "hanoi_p4"));
        br_v5.sendTransform(tf::StampedTransform(transform_v5, ros::Time::now(), "hanoi_base", "hanoi_p5"));
        br_v6.sendTransform(tf::StampedTransform(transform_v6, ros::Time::now(), "hanoi_base", "hanoi_p6"));

        ros::Rate loop_rate(30);

        loop_rate.sleep();
        ros::spinOnce();
    }

    return 0;
};