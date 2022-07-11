#include <ros/ros.h>
#include "movemaster_msg/setpoint.h"
using namespace std;

int main(int argc, char **argv)
{	
	ros::init(argc, argv, "angles");

	ros::NodeHandle n;
	ros::Publisher pub = n.advertise<movemaster_msg::setpoint>("/setpoints", 1000);
	ros::Rate looprate(10);
	movemaster_msg::setpoint msg;

	msg.set_1 = 0;
	msg.set_2 = 104.5;
	msg.set_3 = -121.5;
	msg.set_4 = 0;
	msg.set_5 = 0;

	int mode;

	while(ros::ok()){

		cout << "Operation mode:\n";
		cout << "0: Emergency stop.\n";
		cout << "1: Joint 1.\n";
		cout << "2: Joint 2.\n";
		cout << "3: Joint 3.\n";
		cout << "4: Joint 4.\n";
		cout << "5: Joint 5.\n";
		cout << "6: Toggle Grip.\n";
		cout << "7: All joints. \n";
		cout << "8: Reset.\n";
		cout << "9: Retry.\n";
		cout << "Ctrl+C: Exit.\n";
		cin >> mode;

		system("clear");

		switch(mode){
			case 0:
					msg.GoHome = 0;
					msg.emergency_stop = true;

					cout << "EMERGENCY STOP!!!\n";

					msg.set_1 = 0;
					msg.set_2 = 100;
					msg.set_3 = -110;
					msg.set_4 = 0;
					msg.set_5 = 0;

					pub.publish(msg);
					ros::spinOnce();
					break;
			case 1:
					msg.GoHome = 0;
					msg.emergency_stop = false;

					cout << "Joint 1 angle (deg):\n";
					cin >> msg.set_1;
					pub.publish(msg);
					ros::spinOnce();
					break;
			case 2:
					msg.GoHome = 0;
					msg.emergency_stop = false;

					cout << "Joint 2 angle (deg):\n";
					cin >> msg.set_2;
					pub.publish(msg);
					ros::spinOnce();
					break;
			case 3:
					msg.GoHome = 0;
					msg.emergency_stop = false;

					cout << "Joint 3 angle (deg):\n";
					cin >> msg.set_3;
					pub.publish(msg);
					ros::spinOnce();
					break;
			case 4:
					msg.GoHome = 0;
					msg.emergency_stop = false;

					cout << "Joint 4 angle (deg):\n";
					cin >> msg.set_4;
					pub.publish(msg);
					ros::spinOnce();
					break;
			case 5:
					msg.GoHome = 0;
					msg.emergency_stop = false;

					cout << "Joint 5 angle (deg):\n";
					cin >> msg.set_5;
					pub.publish(msg);
					ros::spinOnce();
					break;
			case 6:
					msg.GoHome = 0;
					msg.emergency_stop = false;

					if(msg.set_GRIP){
						msg.set_GRIP = false;
						cout << "Closing grip.\n";
					}else{
						msg.set_GRIP = true;
						cout << "Opening grip.\n";
					}
					pub.publish(msg);
					ros::spinOnce();
					break;
			case 7:
					msg.GoHome = 0;
					msg.emergency_stop = false;

					cout << "Joint 1 angle (deg):\n";
					cin >> msg.set_1;
					cout << "Joint 2 angle (deg):\n";
					cin >> msg.set_2;
					cout << "Joint 3 angle (deg):\n";
					cin >> msg.set_3;
					cout << "Joint 4 angle (deg):\n";
					cin >> msg.set_4;
					cout << "Joint 5 angle (deg):\n";
					cin >> msg.set_5;
					pub.publish(msg);
					ros::spinOnce();
					break;
			case 8:
					msg.GoHome = 1;
					msg.emergency_stop = false;

					pub.publish(msg);
					ros::spinOnce();
					break;
			case 9:
					msg.GoHome = 2;
					msg.emergency_stop = false;

					pub.publish(msg);
					ros::spinOnce();
					break;
			default:
					exit;\
		}
		cout << "\n\n";
	}
	return 0;
}