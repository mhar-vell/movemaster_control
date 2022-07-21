#include <ros/ros.h>
#include <tf/transform_broadcaster.h>
#include <std_msgs/Int32MultiArray.h>

double pino1 = 0.0, pino2 = 0.088, pino3 = 0.176, pino4 = 0.264;
double baixo = 0.0, medio = 0.013, alto = 0.026;
double pino_v1, pino_v2, pino_v3, pino_v4, pino_v5, pino_v6;
double altura_v1, altura_v2, altura_v3, altura_v4, altura_v5, altura_v6;
double pino_v12, pino_v22, pino_v32, pino_v42, pino_v52, pino_v62;
double altura_v12, altura_v22, altura_v32, altura_v42, altura_v52, altura_v62;
double pino_v13, pino_v23, pino_v33, pino_v43, pino_v53, pino_v63;
double altura_v13, altura_v23, altura_v33, altura_v43, altura_v53, altura_v63;

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

void Callback2(const std_msgs::Int32MultiArray::ConstPtr &msg2)
{
    pino_v12 = define_pino(msg2->data[0]);
    altura_v12 = define_altura(msg2->data[0]);
    pino_v22 = define_pino(msg2->data[1]);
    altura_v22 = define_altura(msg2->data[1]);
    pino_v32 = define_pino(msg2->data[2]);
    altura_v32 = define_altura(msg2->data[2]);
    pino_v42 = define_pino(msg2->data[3]);
    altura_v42 = define_altura(msg2->data[3]);
    pino_v52 = define_pino(msg2->data[4]);
    altura_v52 = define_altura(msg2->data[4]);
    pino_v62 = define_pino(msg2->data[5]);
    altura_v62 = define_altura(msg2->data[5]);

}

void Callback3(const std_msgs::Int32MultiArray::ConstPtr &msg3)
{
    pino_v13 = define_pino(msg3->data[0]);
    altura_v13 = define_altura(msg3->data[0]);
    pino_v23 = define_pino(msg3->data[1]);
    altura_v23 = define_altura(msg3->data[1]);
    pino_v33 = define_pino(msg3->data[2]);
    altura_v33 = define_altura(msg3->data[2]);
    pino_v43 = define_pino(msg3->data[3]);
    altura_v43 = define_altura(msg3->data[3]);
    pino_v53 = define_pino(msg3->data[4]);
    altura_v53 = define_altura(msg3->data[4]);
    pino_v63 = define_pino(msg3->data[5]);
    altura_v63 = define_altura(msg3->data[5]);

}

int main(int argc, char **argv)
{

    ros::init(argc, argv, "hanoi_tf");
    ros::NodeHandle node;
    ros::Subscriber sub = node.subscribe("/hanoi_status", 1000, Callback);
    ros::Subscriber sub2 = node.subscribe("/hanoi_status2", 1000, Callback2);
    ros::Subscriber sub3 = node.subscribe("/hanoi_status3", 1000, Callback3);

    static tf::TransformBroadcaster br_v1; // peca vermelha 1 - maior
    static tf::TransformBroadcaster br_v2;
    static tf::TransformBroadcaster br_v3;
    static tf::TransformBroadcaster br_v4; // peca verde 1 - maior
    static tf::TransformBroadcaster br_v5;
    static tf::TransformBroadcaster br_v6;
    static tf::TransformBroadcaster br_v12; // peca vermelha 1 - maior
    static tf::TransformBroadcaster br_v22;
    static tf::TransformBroadcaster br_v32;
    static tf::TransformBroadcaster br_v42; // peca verde 1 - maior
    static tf::TransformBroadcaster br_v52;
    static tf::TransformBroadcaster br_v62;
    static tf::TransformBroadcaster br_v13; // peca vermelha 1 - maior
    static tf::TransformBroadcaster br_v23;
    static tf::TransformBroadcaster br_v33;
    static tf::TransformBroadcaster br_v43; // peca verde 1 - maior
    static tf::TransformBroadcaster br_v53;
    static tf::TransformBroadcaster br_v63;
    tf::Transform transform_v1;
    tf::Transform transform_v2;
    tf::Transform transform_v3;
    tf::Transform transform_v4;
    tf::Transform transform_v5;
    tf::Transform transform_v6;
    tf::Transform transform_v12;
    tf::Transform transform_v22;
    tf::Transform transform_v32;
    tf::Transform transform_v42;
    tf::Transform transform_v52;
    tf::Transform transform_v62;
    tf::Transform transform_v13;
    tf::Transform transform_v23;
    tf::Transform transform_v33;
    tf::Transform transform_v43;
    tf::Transform transform_v53;
    tf::Transform transform_v63;
    tf::Quaternion q;
    q.setRPY(0, 0, 0);
    transform_v1.setRotation(q);
    transform_v2.setRotation(q);
    transform_v3.setRotation(q);
    transform_v4.setRotation(q);
    transform_v5.setRotation(q);
    transform_v6.setRotation(q);
    transform_v12.setRotation(q);
    transform_v22.setRotation(q);
    transform_v32.setRotation(q);
    transform_v42.setRotation(q);
    transform_v52.setRotation(q);
    transform_v62.setRotation(q);
    transform_v13.setRotation(q);
    transform_v23.setRotation(q);
    transform_v33.setRotation(q);
    transform_v43.setRotation(q);
    transform_v53.setRotation(q);
    transform_v63.setRotation(q);

    while (ros::ok())
    {

        transform_v1.setOrigin(tf::Vector3(pino_v1, 0.0, altura_v1));
        transform_v2.setOrigin(tf::Vector3(pino_v2, 0.0, altura_v2));
        transform_v3.setOrigin(tf::Vector3(pino_v3, 0.0, altura_v3));
        transform_v4.setOrigin(tf::Vector3(pino_v4, 0.0, altura_v4));
        transform_v5.setOrigin(tf::Vector3(pino_v5, 0.0, altura_v5));
        transform_v6.setOrigin(tf::Vector3(pino_v6, 0.0, altura_v6));
        transform_v12.setOrigin(tf::Vector3(pino_v12, 0.0, altura_v12));
        transform_v22.setOrigin(tf::Vector3(pino_v22, 0.0, altura_v22));
        transform_v32.setOrigin(tf::Vector3(pino_v32, 0.0, altura_v32));
        transform_v42.setOrigin(tf::Vector3(pino_v42, 0.0, altura_v42));
        transform_v52.setOrigin(tf::Vector3(pino_v52, 0.0, altura_v52));
        transform_v62.setOrigin(tf::Vector3(pino_v62, 0.0, altura_v62));
        transform_v13.setOrigin(tf::Vector3(pino_v13, 0.0, altura_v13));
        transform_v23.setOrigin(tf::Vector3(pino_v23, 0.0, altura_v23));
        transform_v33.setOrigin(tf::Vector3(pino_v33, 0.0, altura_v33));
        transform_v43.setOrigin(tf::Vector3(pino_v43, 0.0, altura_v43));
        transform_v53.setOrigin(tf::Vector3(pino_v53, 0.0, altura_v53));
        transform_v63.setOrigin(tf::Vector3(pino_v63, 0.0, altura_v63));
        br_v1.sendTransform(tf::StampedTransform(transform_v1, ros::Time::now(), "hanoi_base", "hanoi_p1"));
        br_v2.sendTransform(tf::StampedTransform(transform_v2, ros::Time::now(), "hanoi_base", "hanoi_p2"));
        br_v3.sendTransform(tf::StampedTransform(transform_v3, ros::Time::now(), "hanoi_base", "hanoi_p3"));
        br_v4.sendTransform(tf::StampedTransform(transform_v4, ros::Time::now(), "hanoi_base", "hanoi_p4"));
        br_v5.sendTransform(tf::StampedTransform(transform_v5, ros::Time::now(), "hanoi_base", "hanoi_p5"));
        br_v6.sendTransform(tf::StampedTransform(transform_v6, ros::Time::now(), "hanoi_base", "hanoi_p6"));
        br_v12.sendTransform(tf::StampedTransform(transform_v12, ros::Time::now(), "hanoi_base2", "hanoi_p12"));
        br_v22.sendTransform(tf::StampedTransform(transform_v22, ros::Time::now(), "hanoi_base2", "hanoi_p22"));
        br_v32.sendTransform(tf::StampedTransform(transform_v32, ros::Time::now(), "hanoi_base2", "hanoi_p32"));
        br_v42.sendTransform(tf::StampedTransform(transform_v42, ros::Time::now(), "hanoi_base2", "hanoi_p42"));
        br_v52.sendTransform(tf::StampedTransform(transform_v52, ros::Time::now(), "hanoi_base2", "hanoi_p52"));
        br_v62.sendTransform(tf::StampedTransform(transform_v62, ros::Time::now(), "hanoi_base2", "hanoi_p62"));
        br_v13.sendTransform(tf::StampedTransform(transform_v13, ros::Time::now(), "hanoi_base3", "hanoi_p13"));
        br_v23.sendTransform(tf::StampedTransform(transform_v23, ros::Time::now(), "hanoi_base3", "hanoi_p23"));
        br_v33.sendTransform(tf::StampedTransform(transform_v33, ros::Time::now(), "hanoi_base3", "hanoi_p33"));
        br_v43.sendTransform(tf::StampedTransform(transform_v43, ros::Time::now(), "hanoi_base3", "hanoi_p43"));
        br_v53.sendTransform(tf::StampedTransform(transform_v53, ros::Time::now(), "hanoi_base3", "hanoi_p53"));
        br_v63.sendTransform(tf::StampedTransform(transform_v63, ros::Time::now(), "hanoi_base3", "hanoi_p63"));

        ros::Rate loop_rate(30);

        loop_rate.sleep();
        ros::spinOnce();
    }

    return 0;
};