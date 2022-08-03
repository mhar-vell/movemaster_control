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
vetor_posicoes = [-133 200; -43 178; 137 165; -133 200; -43 178; 137 165];

for i = 1:length(vetor_posicoes)

    % Home configuration.
    home = [deg2rad(   0);
            deg2rad( 106);
            deg2rad(-123);
            deg2rad(   0);
            deg2rad(   0)];
    
    % Defines the destination pose.
    %goal_pos = [465;-133;200]; % pino 1
    %goal_pos = [465;-43;178]; % pino 2
    %goal_pos = [450;-250;100]; % pino 3
    %goal_pos = [465;137;165]; % pino 4
    goal_pos = [465;vetor_posicoes(i,1);vetor_posicoes(i,2)];
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

    pause(4);
end
