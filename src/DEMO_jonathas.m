%% Clean

clear all;
close all;
clc;
    
%% ROS Configuration

rosshutdown;
rosinit;

sub(1) = rossubscriber('/status_1');
sub(2) = rossubscriber('/status_2');
sub(3) = rossubscriber('/status_3');
sub(4) = rossubscriber('/status_4');
sub(5) = rossubscriber('/status_5');
sub_joints = rossubscriber('/joint_states');
    
[pub,msg] = rospublisher('/setpoints','movemaster_msg/setpoint');

%% Resets the manipulator.

msg.GoHome = 1;
send(pub,msg);

% Waits for stable position.
pause(1)
ok = false;
while ~ok
    [ok, received, config] = statusMovemaster(sub);
end

pause(1)
ok = false;
while ~ok
    [ok, received, config] = statusMovemaster(sub);
end

fprintf('Manipulator reseted.\n');



%% IK

% Home configuration.
home = [deg2rad(   0);
        deg2rad( 106);
        deg2rad(-123);
        deg2rad(   0);
        deg2rad(   0)];

% Defines the destination pose.
goal_pos = [450;-200;230]; % ponto1 450;-200;230
ori_angle = deg2rad(90); % Calculations in radians, to the Movemaster in degrees.

% Computes the inverse kinematics.
ori_axis = [0;1;0];
goal_ori = [cos(ori_angle/2); sin(ori_angle/2)*ori_axis];
[theta, ~, valid] = MovemasterIK_PosAndOri(home, goal_pos, ori_angle);
theta_deg = wrapTo180(rad2deg(theta))

if goal_pos(1) < 10
    valid= false;
end

if goal_pos(3) < 10
    valid= false;
end
valid

%% Plot

% generates plot using forward kinematics.
[effector_pos, effector_quat, joint_pos, z_axis] = FK_Movemaster_SSDQ(theta);

J1(:,1)  =  joint_pos(:,1);
J2(:,1)  =  joint_pos(:,2);
J3(:,1)  =  joint_pos(:,3);
J4(:,1)  =  joint_pos(:,4);
J5(:,1)  =  joint_pos(:,5);
EFF(:,1) =  effector_pos;

figure;
x = [J1(1), J2(1), J3(1), J4(1), J5(1), EFF(1)];
y = [J1(2), J2(2), J3(2), J4(2), J5(2), EFF(2)];
z = [J1(3), J2(3), J3(3), J4(3), J5(3), EFF(3)];

plot3(x,y,z,'-o','Linewidth',3,'Color','k');hold on
plot3(goal_pos(1),goal_pos(2),goal_pos(3),'Color','r','Linewidth',2);hold on

hold off;

axis ([0 700 -350 350 0 800]);
box
view(60,45)

%% Movemaster

if valid
    msg.GoHome = 0;
    msg.Set1 = theta_deg(1);
    msg.Set2 = theta_deg(2);
    msg.Set3 = theta_deg(3);
    msg.Set4 = theta_deg(4);
    msg.Set5 = theta_deg(5) - theta_deg(4);

    send(pub,msg);
end




%% Centro do objeto


%Leitura dos sensores
%clc;
%clearvars;
%close all;

scandata = rosmessage('std_msgs/Float32');
sensor1 = rossubscriber('/sensor1');
sensor2 = rossubscriber('/sensor2');
sensor3 = rossubscriber('/sensor3');
sensor4 = rossubscriber('/sensor4');
sensor5 = rossubscriber('/sensor5');
sensor6 = rossubscriber('/sensor6');
sensor7 = rossubscriber('/sensor7');
sensor8 = rossubscriber('/sensor8');
sensor9 = rossubscriber('/sensor9');


    s(1) = receive(sensor1, 5);
    s(2) = receive(sensor2, 5);
    s(3) = receive(sensor3, 5);
    s(4) = receive(sensor4, 5);
    s(5) = receive(sensor5, 5);
    s(6) = receive(sensor6, 5);
    s(7) = receive(sensor7, 5);
    s(8) = receive(sensor8, 5);
    s(9) = receive(sensor9, 5);
    ab = s(3).Data
    ac = s(7).Data
%for i=1:1:9
while ab<=50 && ac<=50

    s(3) = receive(sensor3, 5);
    s(7) = receive(sensor7, 5);
    ab = s(3).Data
    ac = s(7).Data
    
    msg.Set1 = msg.Set1 +2
    send(pub,msg)
end    

while (ab>50 && ac>50) && (ab<130 || ac<130)

    s(3) = receive(sensor3, 5);
    s(7) = receive(sensor7, 5);
    ab = s(3).Data
    ac = s(7).Data
    
    msg.Set1 = msg.Set1 -2
    send(pub,msg)


end

    msg.Set1 = 0;
    send(pub,msg)

disp("*******Simulação Encerrada*******");



