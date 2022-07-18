#include <ros/ros.h>
#include <tf/transform_broadcaster.h>

/*void poseCallback(const turtlesim::PoseConstPtr& msg){
  static tf::TransformBroadcaster br;
  tf::Transform transform;
  transform.setOrigin( tf::Vector3(0.058, 0.0, 0.0) );
  br.sendTransform(tf::StampedTransform(transform, ros::Time::now(), "hanoi_base", "hanoi_p1"));
}*/

int main(int argc, char** argv){
  ros::init(argc, argv, "hanoi_tf");

  ros::NodeHandle node;
  //ros::Subscriber sub = node.subscribe(turtle_name+"/pose", 10, &poseCallback);

  while (ros::ok()) {

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
        double pino1 = 0.0, pino2 = 0.088, pino3 = 0.176, pino4 = 0.264;
        double baixo = 0.0, medio = 0.013, alto = 0.026;
        double pino_v1 = pino1;
        double altura_v1 = baixo;
        double pino_v2 = pino2;
        double altura_v2 = medio;
        double pino_v3 = pino4;
        double altura_v3 = alto;
        double pino_v4 = pino3;
        double altura_v4 = baixo;
        double pino_v5 = pino3;
        double altura_v5 = medio;
        double pino_v6 = pino3;
        double altura_v6 = alto;
        transform_v1.setOrigin( tf::Vector3(pino_v1, 0.0, altura_v1) );
        transform_v2.setOrigin( tf::Vector3(pino_v2, 0.0, altura_v2) );
        transform_v3.setOrigin( tf::Vector3(pino_v3, 0.0, altura_v3) );
        transform_v4.setOrigin( tf::Vector3(pino_v4, 0.0, altura_v4) );
        transform_v5.setOrigin( tf::Vector3(pino_v5, 0.0, altura_v5) );
        transform_v6.setOrigin( tf::Vector3(pino_v4, 0.0, altura_v6) );
        tf::Quaternion q;
        q.setRPY(0, 0, 0);
        transform_v1.setRotation(q);
        transform_v2.setRotation(q);
        transform_v3.setRotation(q);
        transform_v4.setRotation(q);
        transform_v5.setRotation(q);
        transform_v6.setRotation(q);
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