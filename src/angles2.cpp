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
		cout << "10: Draw square trajectory.\n"; // Draw square trajectory
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
			case 10: 
					msg.GoHome = 0;
					msg.emergency_stop = false;
					// Continuous square trajectory
					{
						// Wait for publisher to connect
						int cycles = 1;
						// Ask user how many cycles to draw the square
						cout << "Drawing square trajectory.\n";	
						cout << "How many cycles to draw the square? (0 = infinite): "; // 
						cin >> cycles;

						// Define the 4 square corners
						movemaster_msg::setpoint pts[4];
						pts[0] = msg;
						pts[0].set_1 =  00.0; pts[0].set_2 = 60.0;  pts[0].set_3 = -91.5; pts[0].set_4 = 0; pts[0].set_5 = 90; 
						pts[1] = msg;
						pts[1].set_1 = -50.0; pts[1].set_2 = 120.0; pts[1].set_3 = -91.5; pts[1].set_4 = 0; pts[1].set_5 = 0;  
						pts[2] = msg;
						pts[2].set_1 =  00.0; pts[2].set_2 = 120.0; pts[2].set_3 = -51.5; pts[2].set_4 = 0; pts[2].set_5 = 90; 
						pts[3] = msg;
						pts[3].set_1 =  50.0; pts[3].set_2 = 60.0;  pts[3].set_3 = -51.5; pts[3].set_4 = 0; pts[3].set_5 = 0;  
						
						// Draw the square trajectory
						cout << "Drawing square trajectory. Press Ctrl+C to stop.\n";
						int current_cycle = 0;
						while(ros::ok() && (cycles == 0 || current_cycle < cycles)) {
							for(int i=0; i<4; ++i){
								// Set set_GRIP: false if even cycle, true if odd cycle
        						// pts[i].set_GRIP = (current_cycle % 2 == 1);
								// Set set_GRIP: false if point is even, true if point is odd
        						pts[i].set_GRIP = (i % 2 == 1);
								    if (pts[i].set_GRIP) {
										cout << "Closing grip.\n";
									} else {
										cout << "Opening grip.\n";
									}
								// Publish the point
								ros::Duration(1.0).sleep(); // 1 seconds between points
								pub.publish(pts[i]);
								ros::spinOnce();
								// cout << "Published square point " << i+1 << " (cycle " << current_cycle+1 << ")" << endl;
								// cout << "Published square point " << i+1 << " (cycle " << current_cycle+1 << "), set_GRIP: " << pts[i].set_GRIP << endl;

								// cout << "Published square point " << i+1 << " (cycle " << current_cycle+1 << "), set_GRIP: " << pts[i].set_GRIP << endl;
								ros::Duration(2.0).sleep(); // 2 seconds between points
								cout << "Published square point " << i+1 << " (cycle " << current_cycle+1 << "), set_GRIP: " << pts[i].set_GRIP << " (" << (pts[i].set_GRIP ? "Closed grip" : "Opened grip") << ")\n" << endl;
								ros::Duration(2.0).sleep(); // 2 seconds between points
							}
							current_cycle++;
						}
					}
					break;
			// case 10:
            //     msg.GoHome = 0;
            //     msg.emergency_stop = false;

            //     // Define the 4 square corners
            //     // {
            //     //     movemaster_msg::setpoint pts[4];
            //     //     pts[0] = msg;
            //     //     pts[0].set_1 = 40.0;  pts[0].set_2 = 104.0; pts[0].set_3 = -91.5; pts[0].set_4 = 0; pts[0].set_5 = 5;
            //     //     pts[1] = msg;
            //     //     pts[1].set_1 = -40.0; pts[1].set_2 = 104.0; pts[1].set_3 = -91.5; pts[1].set_4 = 0; pts[1].set_5 = 5;
            //     //     pts[2] = msg;
            //     //     pts[2].set_1 = -40.0; pts[2].set_2 = 104.0; pts[2].set_3 = -81.5; pts[2].set_4 = 0; pts[2].set_5 = 5;
            //     //     pts[3] = msg;
            //     //     pts[3].set_1 = 40.0;  pts[3].set_2 = 104.0; pts[3].set_3 = -81.5; pts[3].set_4 = 0; pts[3].set_5 = 5;
			// 	// 	// Wait for publisher to connect
            //     //     for(int i=0; i<4; ++i){
            //     //         pub.publish(pts[i]);
            //     //         ros::spinOnce();
            //     //         cout << "Published square point " << i+1 << endl;
            //     //         ros::Duration(2.0).sleep(); // 2 seconds between points
            //     //     }
            //     // }

            //     // Continuous square trajectory
			// 	{ 
			// 		// Define the 4 square corners
            //         movemaster_msg::setpoint pts[4];
            //         pts[0] = msg;
            //         pts[0].set_1 =  00.0; pts[0].set_2 = 60.0; pts[0].set_3 = -91.5; pts[0].set_4 = 0; pts[0].set_5 = 90;
            //         pts[1] = msg;
            //         pts[1].set_1 = -50.0; pts[1].set_2 = 120.0; pts[1].set_3 = -91.5; pts[1].set_4 = 0; pts[1].set_5 = 0;
            //         pts[2] = msg;
            //         pts[2].set_1 =  00.0; pts[2].set_2 = 120.0; pts[2].set_3 = -51.5; pts[2].set_4 = 0; pts[2].set_5 = 90;
            //         pts[3] = msg;
            //         pts[3].set_1 =  50.0; pts[3].set_2 = 60.0; pts[3].set_3 = -51.5; pts[3].set_4 = 0; pts[3].set_5 = 0;
			// 		// Wait for publisher to connect
            //         cout << "Drawing square trajectory continuously. Press Ctrl+C to stop.\n";
            //         while(ros::ok()) {
            //             for(int i=0; i<4; ++i){
            //                 pub.publish(pts[i]);
            //                 ros::spin();
            //                 cout << "Published square point " << i+1 << endl;
            //                 ros::Duration(100.0).sleep(); // 10 seconds between points
            //             }
            //         }
            //     }
			// 	break;

			default:
					exit;\
		}
		cout << "\n\n";
	}
	return 0;
}