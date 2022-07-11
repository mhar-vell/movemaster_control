%clear all;
close all;
clc;

%% Definitions

% Inflation size.
dist_warn = 110;
dist_crit = 80;

% Sets the Clifford Algebra to Cl(0,3,1).
%  1    e1    e2    e3   e  e1e2  e1e3  e1e  e2e3  e2e  e3e  e1e2e3  e1e2e  e1e3e  e2e3e e1e2e3e
clifford_signature(0,3,1);

dof = 5;
ori_axis = [0;1;0];

% Trajectory points.
shape = 'circle';

switch shape
    case 'elipse'
        center = [520; 0; 230];
        radius = [60; 280; 140];
    case 'line'
        center = [550; 0; 230];
        radius = [0; 250; 50];
    case 'circle'
        center = [480; 100; 200];
        radius = [220;220;0];
    otherwise
        return;
end
        
t_max = 30;
laps = 1;
interval = 0.01;
t = 0.001:interval:t_max;
loop_time = laps/t_max;

pd = [center(1) + radius(1)*cos(    2*pi*t*loop_time   +pi);
      center(2) + radius(2)*sin( -  2*pi*t*loop_time   +pi);
      center(3) + radius(3)*sin( -  2*pi*t*loop_time   +pi);
                                            0*t+deg2rad(30); %yaw
                                            0*t+deg2rad(70); %pitch
                                                       0*t]; %roll

pd_dot_full = [(pi*sin(pi*t))/4;
          (pi*cos(pi*t))/4;
                       0*t;
                       0*t;
                       0*t;
                      0*t];

% Joint Limits.
theta_min_UNWRAPED = deg2rad([-100; -30; -120; -100; -180]);
% theta_max_UNWRAPED = deg2rad([ 100; 100;    0;  100;  180]);
theta_max_UNWRAPED = deg2rad([ 100; 100;    0;  0;  180]);
theta_min = wrapToPi(theta_min_UNWRAPED);
theta_max = wrapToPi(theta_max_UNWRAPED);

% Home configuration.
home = [deg2rad(   0);
        deg2rad( 106);
        deg2rad(-123);
        deg2rad(   0);
        deg2rad(   0)];
    
%% ROS Configuration

rosshutdown;
rosinit;

sub_ptcloud = rossubscriber('/d400/depth/color/points');

sub(1) = rossubscriber('/status_1');
sub(2) = rossubscriber('/status_2');
sub(3) = rossubscriber('/status_3');
sub(4) = rossubscriber('/status_4');
sub(5) = rossubscriber('/status_5');
sub_joints = rossubscriber('/joint_states');
    
[pub,msg] = rospublisher('/setpoints','movemaster_msg/setpoint');
[pub_ceiling, msg_ceiling] = rospublisher('/ceiling', 'std_msgs/Float32');
[pub_right, msg_right] = rospublisher('/right', 'std_msgs/Float32');
[pub_left, msg_left] = rospublisher('/left', 'std_msgs/Float32');

[pub_ceilingORI, msg_ceilingORI] = rospublisher('/ceilingORI', 'geometry_msgs/Quaternion');
[pub_rightORI, msg_rightORI] = rospublisher('/rightORI', 'geometry_msgs/Quaternion');
[pub_leftORI, msg_leftORI] = rospublisher('/leftORI', 'geometry_msgs/Quaternion');

[pub_effectorPosition, msg_effectorPosition] = rospublisher('/effectorPosition', 'geometry_msgs/Point');
[pub_effectorOrientation, msg_effectorOrientation] = rospublisher('/effectorOrientation', 'geometry_msgs/Quaternion');

%% Goes to +z reading position.
reading = [   0;
            -30;
             -5;
             95;
            -90];
       
fprintf('Entering +z capture position...\n');
msg.Set1 = reading(1);
msg.Set2 = reading(2);
msg.Set3 = reading(3);
msg.Set4 = reading(4);
msg.Set5 = reading(5) - reading(4);
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

fprintf('Ready to capture +z point cloud.\n');

%% Computes +z plane (ceiling).

% Reads and processes the pointcloud.
tftree = rostf;
tftree.AvailableFrames;
ptcloud = transform(tftree, 'odom', receive(sub_ptcloud, 15));

ptCloud = pointCloud(readXYZ(ptcloud),'Color',uint8(255*readRGB(ptcloud)));

fprintf('Point cloud received.\n');

maxDistance = 0.005;
referenceVector = [0,0,-1];
maxAngularDistance = 1;

[model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,maxDistance,referenceVector,maxAngularDistance);

plane_z = select(ptCloud,inlierIndices);
% pcshow(plane_z);hold on;

z_min = double(plane_z.ZLimits(1))*1000;
z_max = double(plane_z.ZLimits(2))*1000;
z_med = mean([z_min, z_max]);

z_med_A = mean([z_min, z_med]);
z_med_B = mean([z_max, z_med]);

fprintf('Computed Clifford +z plane at distance: %i mm.\n', round(z_med));

Length = plane_z.Count;
p1_ = double(plane_z.Location(randi([1 Length]),:)*1000)
p2_ = double(plane_z.Location(randi([1 Length]),:)*1000)
p3_ = double(plane_z.Location(randi([1 Length]),:)*1000)

p1z = p1_;
p2z = p2_;
p3z = p3_;

% plot3(p1_(1)/1000, p1_(2)/1000, p1_(3)/1000,'Marker','o','Color','r','Linewidth',3);hold on;
% plot3(p2_(1)/1000, p2_(2)/1000, p2_(3)/1000,'Marker','o','Color','r','Linewidth',3);hold on;
% plot3(p3_(1)/1000, p3_(2)/1000, p3_(3)/1000,'Marker','o','Color','r','Linewidth',3);hold on;

p1  = clifford(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, p1_(3), -p1_(2), p1_(1), 0)*1;
p2  = clifford(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, p2_(3), -p2_(2), p2_(1), 0)*1;
p3  = clifford(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, p3_(3), -p3_(2), p3_(1), 0)*1;

p1h = hodge(p1);
p2h = hodge(p2);
p3h = hodge(p3);

sigma = p1h*p2h*p3h - p2h*p1h*p3h + p2h*p3h*p1h - p3h*p2h*p1h + p3h*p1h*p2h - p1h*p3h*p2h;

sigmah = hodge(sigma);

normsigmah = sqrt(part(sigmah*conj(sigmah), 1));

pi_cliff_z = sigmah/normsigmah;

norm_z = [part(pi_cliff_z, 2); part(pi_cliff_z, 3); part(pi_cliff_z, 4)];
if norm_z(3) > 0
    norm_z = -norm_z;
end

norm_z


%% Goes to -y reading position.
reading = [ -15;
            -30;
             -5;
             95;
             0];
       
fprintf('Entering -y capture position...\n');
msg.Set1 = reading(1);
msg.Set2 = reading(2);
msg.Set3 = reading(3);
msg.Set4 = reading(4);
msg.Set5 = reading(5) - reading(4);
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

fprintf('Ready to capture -y point cloud.\n');

%% Computes -y plane (wallright).

% Reads and processes the pointcloud.
tftree = rostf;
tftree.AvailableFrames;
ptcloud = transform(tftree, 'odom', receive(sub_ptcloud, 10));

ptCloud = pointCloud(readXYZ(ptcloud),'Color',uint8(255*readRGB(ptcloud)));

fprintf('Point cloud received.\n');

% maxDistance = 0.05;
% referenceVector = [0,1,0];
% maxAngularDistance = 4;

maxDistance = 0.01;
referenceVector = [0,-1,0];
maxAngularDistance = 3;

[model2,inlierIndices,outlierIndices] = pcfitplane(ptCloud,maxDistance,referenceVector,maxAngularDistance);

plane_y1 = select(ptCloud,inlierIndices);
% pcshow(plane_y1);hold on;

y1_min = double(plane_y1.YLimits(1))*1000;
y1_max = double(plane_y1.YLimits(2))*1000;
y1_med = mean([y1_min, y1_max]);

y1_med_A = mean([y1_min, y1_med]);
y1_med_B = mean([y1_max, y1_med]);

fprintf('Computed Clifford -y plane at distance: %i mm.\n', round(y1_med));

Length = plane_y1.Count;
p1_ = double(plane_y1.Location(randi([1 Length]),:)*1000)
p2_ = double(plane_y1.Location(randi([1 Length]),:)*1000)
p3_ = double(plane_y1.Location(randi([1 Length]),:)*1000)

p1y1 = p1_;
p2y1 = p2_;
p3y1 = p3_;

p1  = clifford(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, p1_(3), -p1_(2), p1_(1), 0)*1;
p2  = clifford(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, p2_(3), -p2_(2), p2_(1), 0)*1;
p3  = clifford(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, p3_(3), -p3_(2), p3_(1), 0)*1;

p1h = hodge(p1);
p2h = hodge(p2);
p3h = hodge(p3);

sigma = p1h*p2h*p3h - p2h*p1h*p3h + p2h*p3h*p1h - p3h*p2h*p1h + p3h*p1h*p2h - p1h*p3h*p2h;

sigmah = hodge(sigma);

normsigmah = sqrt(part(sigmah*conj(sigmah), 1));

pi_cliff_y1 = sigmah/normsigmah;

norm_y1 = [part(pi_cliff_y1, 2); part(pi_cliff_y1, 3); part(pi_cliff_y1, 4)];
if norm_y1(2) < 0
    norm_y1 = -norm_y1;
end
norm_y1

%% Goes to +y reading position.
reading = [  15;
            -30;
             -5;
             95;
             0];

fprintf('Entering +y capture position...\n');
msg.Set1 = reading(1);
msg.Set2 = reading(2);
msg.Set3 = reading(3);
msg.Set4 = reading(4);
msg.Set5 = reading(5) - reading(4);
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

fprintf('Ready to capture +y point cloud.\n');

%% Computes +y plane (wallleft).

% Reads and processes the pointcloud.
tftree = rostf;
tftree.AvailableFrames;
ptcloud = transform(tftree, 'odom', receive(sub_ptcloud, 10));

ptCloud = pointCloud(readXYZ(ptcloud),'Color',uint8(255*readRGB(ptcloud)));

fprintf('Point cloud received.\n');

maxDistance = 0.01;
referenceVector = [0,-1,0];
maxAngularDistance = 3;

[model3,inlierIndices,outlierIndices] = pcfitplane(ptCloud,maxDistance,referenceVector,maxAngularDistance);

plane_y2 = select(ptCloud,inlierIndices);
% pcshow(plane_y2);hold on;

y2_min = double(plane_y2.YLimits(1))*1000;
y2_max = double(plane_y2.YLimits(2))*1000;
y2_med = mean([y2_min, y2_max]);

y2_med_A = mean([y2_min, y2_med]);
y2_med_B = mean([y2_max, y2_med]);

fprintf('Computed Clifford +y plane at distance: %i mm.\n', round(y2_med));

Length = plane_y2.Count;
p1_ = double(plane_y2.Location(randi([1 Length]),:)*1000)
p2_ = double(plane_y2.Location(randi([1 Length]),:)*1000)
p3_ = double(plane_y2.Location(randi([1 Length]),:)*1000)

p1y2 = p1_;
p2y2 = p2_;
p3y2 = p3_;

p1  = clifford(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, p1_(3), -p1_(2), p1_(1), 0)*1;
p2  = clifford(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, p2_(3), -p2_(2), p2_(1), 0)*1;
p3  = clifford(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, p3_(3), -p3_(2), p3_(1), 0)*1;

p1h = hodge(p1);
p2h = hodge(p2);
p3h = hodge(p3);

sigma = p1h*p2h*p3h - p2h*p1h*p3h + p2h*p3h*p1h - p3h*p2h*p1h + p3h*p1h*p2h - p1h*p3h*p2h;

sigmah = hodge(sigma);

normsigmah = sqrt(part(sigmah*conj(sigmah), 1));

pi_cliff_y2 = sigmah/normsigmah;

norm_y2 = [part(pi_cliff_y2, 2); part(pi_cliff_y2, 3); part(pi_cliff_y2, 4)];
if norm_y2(2) > 0
    norm_y2 = -norm_y2;
end
norm_y2

%% Publishes manipulator workspace

% Publishes +z.
msg_ceiling.Data = single(z_med/1000);
send(pub_ceiling, msg_ceiling);

msg_ceilingORI.W = 1;
msg_ceilingORI.X = norm_z(1);
msg_ceilingORI.Y = norm_z(2);
msg_ceilingORI.Z = norm_z(3);
send(pub_ceilingORI, msg_ceilingORI);

% Publishes +y.
msg_right.Data = single(y1_med/1000);
send(pub_right, msg_right);

msg_rightORI.W = 1;
msg_rightORI.X = norm_y1(1);
msg_rightORI.Y = norm_y1(2);
msg_rightORI.Z = norm_y1(3);
send(pub_rightORI, msg_rightORI);

% Publishes -y.
msg_left.Data = single(y2_med/1000);
send(pub_left, msg_left);

msg_leftORI.W = 1;
msg_leftORI.X = norm_y2(1);
msg_leftORI.Y = norm_y2(2);
msg_leftORI.Z = norm_y2(3);
send(pub_leftORI, msg_leftORI);

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

%% Trims trajectory on +/-y and +/-z critical zone.

pd_trim = pd;

for i=1:length(t)
    
    % -y (right wall)
    if pd(2,i) < (y1_med + dist_warn)
        pd_trim(2,i) = (y1_med + dist_warn);
    end
    
    % +y (left wall)
    if pd(2,i) > (y2_med - dist_warn)
        pd_trim(2,i) = (y2_med - dist_warn);
    end
    
    % +z (ceiling)
    if pd(3,i) > z_med - dist_warn
        pd_trim(3,i) = (z_med - dist_warn);
    end
    
    % -z (floor)
    if pd(3,i) < 0 + dist_warn
        pd_trim(3,i) = dist_warn;
    end
    
end

plot3(pd_trim(1,:),pd_trim(2,:),pd_trim(3,:),'Color','r','Linewidth',2);hold on
grid

%% Prepares planes for plot.

% n = [part(pi_cliff_z, 2), part(pi_cliff_z, 3), part(pi_cliff_z, 4)];
n = norm_z;
d = abs(part(pi_cliff_z, 5));

[xp, yp] = meshgrid(-500:1000:500);
zp = -(n(1)*xp+n(2)*yp + d)/n(3);

[xp2, yp2] = meshgrid(-500:1000:500);
zp2 = -(n(1)*xp2+n(2)*yp2 + d-dist_warn)/n(3);

[xp3, yp3] = meshgrid(-500:1000:500);
zp3 = -(n(1)*xp3+n(2)*yp3 + d-dist_crit)/n(3);

figure
surf(xp,yp,zp,'FaceAlpha',0.5,'FaceColor','r'); hold on;
surf(xp2,yp2,zp2,'FaceAlpha',0.5,'FaceColor','g'); hold on;
surf(xp3,yp3,zp3,'FaceAlpha',0.5,'FaceColor','y'); hold on;
alpha(.5)

%% IK loop to generate trajectory. Trims the +z depending on critical joint.

% Choose routine:

 % A = 
 % POSITION CONTROL: ON
 % ORIENTATION CONTROL: ON
 % JOINT LIMIT CONTROL: OFF
 % OFF-TRACKS TO KEEP ORIENTATION.
 % CAN BREAK JOINT LIMITS.
 
 % B = 
 % POSITION CONTROL: ON
 % ORIENTATION CONTROL: OFF
 % JOINT LIMIT CONTROL: ON, BUT FORCED
 % OFF-TRACKS TO KEEP JOINT LIMITS.
 % FREE ORIENTATION.
 
 % C = 
 % POSITION CONTROL: ON
 % ORIENTATION CONTROL: OFF
 % JOINT LIMIT CONTROL: ON, WITH PROPOSED ALGORITHM.
 % OFF-TRACKS TO KEEP JOINT LIMITS.
 % FREE ORIENTATION.

routine = 'C'

% Computes the initial joints in the trajectory.

goal_pos = pd_trim(1:3,1);
ori_angle = pd_trim(5,1);
goal_ori = [cos(ori_angle/2); sin(ori_angle/2)*ori_axis];
goal_pos_ant = goal_pos;

[theta, joint_pos, valid] = MovemasterIK_PosAndOri(home, goal_pos, ori_angle);

%IK gains
switch routine
    case 'A'
        K_gains = 15*[1;1;1;1;1;1];
        damp0 = [  0.1;  0.1;  0.1;  0.1;  0.1;  0.1];
        gains = [  1;  1;  1;  1;  1;  0];
        [theta, joint_pos, valid] = MovemasterIK_PosAndOri(home, goal_pos, ori_angle);
        k_joints = 0;
        k_zeros = k_joints*[  1;  1;  1;  1;  1];
        k_zero = diag(k_zeros);
        pd_dot = pd_dot_full;
        error = zeros(6,1);
        dist = 0;
    case 'B'
%         K_gains = [1800;1800;1800];
        K_gains = 20*[1;1;1];
        damp0 = [  0.1;  0.1;  0.1];
        gains = [  1;  1;  1;  1;  1;  0];
        [theta, joint_pos, valid] = MovemasterIK_PosAndOri(home, goal_pos, ori_angle);
        k_joints = 1;
        k_zeros = k_joints*[  1;  1;  1;  1;  1];
        k_zero = diag(k_zeros);
        pd_dot = pd_dot_full(1:3,:);
        error = zeros(3,1);
        dist = 0;
    case 'C'
%         K_gains = [1800;1800;1800];
        K_gains = 20*[1;1;1];
        damp0 = [  0.1;  0.1;  0.1];
        gains = [  1;  1;  1;  1;  1;  0];
        [theta, joint_pos, valid] = MovemasterIK_PosAndOri(home, goal_pos, ori_angle);
        k_joints = 1;
        k_zeros = k_joints*[  1;  1;  1;  1;  1];
        k_zero = diag(k_zeros);
        pd_dot = pd_dot_full(1:3,:);
        error = zeros(3,1);
        dist = 0;
    otherwise
        return;
end
K = diag(K_gains);
damp = diag(damp0);

% Starting Forward Kinematics.
[effector_pos, effector_quat, joint_pos, z_axis] = FK_Movemaster_SSDQ(theta);

for k=1:length(t)
    
    % Sets the main goals for this iteraction. goal_ori is ignored if orientation control is off.
    goal_pos = pd_trim(1:3,k);
    ori_angle = pd_trim(5,k);
    goal_ori = [cos(ori_angle/2); sin(ori_angle/2)*ori_axis];
    err_control = 999;
    tries = 0;
    
    check_dist = false;
    
    k

    %while err_control > 10 && tries < 200 && check_dist == false
    while err_control > 10 || check_dist == false

        tries = tries + 1;
        
        % Computes the Jacobian.
        switch routine
        case 'A'
            J = [-10*sin(theta(1))*(25*cos(theta(2) + theta(3) + theta(4)) + 20*cos(theta(2) + theta(3)) + 25*cos(theta(2)) + 12), -50*cos(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3)) + 5*sin(theta(2))), -50*cos(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3))), -250*sin(theta(2) + theta(3) + theta(4))*cos(theta(1)), 0;
              10*cos(theta(1))*(25*cos(theta(2) + theta(3) + theta(4)) + 20*cos(theta(2) + theta(3)) + 25*cos(theta(2)) + 12), -50*sin(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3)) + 5*sin(theta(2))), -50*sin(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3))), -250*sin(theta(2) + theta(3) + theta(4))*sin(theta(1)), 0;
              0,               250*cos(theta(2) + theta(3) + theta(4)) + 200*cos(theta(2) + theta(3)) + 250*cos(theta(2)),                 250*cos(theta(2) + theta(3) + theta(4)) + 200*cos(theta(2) + theta(3)),                250*cos(theta(2) + theta(3) + theta(4)), 0;
              z_axis];
              
            for i=1:dof
                w_dot(i,1) = 0;
            end
            
        case 'B'
            J = [-10*sin(theta(1))*(25*cos(theta(2) + theta(3) + theta(4)) + 20*cos(theta(2) + theta(3)) + 25*cos(theta(2)) + 12), -50*cos(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3)) + 5*sin(theta(2))), -50*cos(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3))), -250*sin(theta(2) + theta(3) + theta(4))*cos(theta(1)), 0;
                 10*cos(theta(1))*(25*cos(theta(2) + theta(3) + theta(4)) + 20*cos(theta(2) + theta(3)) + 25*cos(theta(2)) + 12), -50*sin(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3)) + 5*sin(theta(2))), -50*sin(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3))), -250*sin(theta(2) + theta(3) + theta(4))*sin(theta(1)), 0;
                 0,               250*cos(theta(2) + theta(3) + theta(4)) + 200*cos(theta(2) + theta(3)) + 250*cos(theta(2)),                 250*cos(theta(2) + theta(3) + theta(4)) + 200*cos(theta(2) + theta(3)),                250*cos(theta(2) + theta(3) + theta(4)), 0];
             
            for i=1:dof
                w_dot(i,1) = -(2*theta(i) + theta_min(i) - theta_max(i))/(10*(theta_min(i) - theta_max(i))^2);
            end
            
        case 'C'
            J = [-10*sin(theta(1))*(25*cos(theta(2) + theta(3) + theta(4)) + 20*cos(theta(2) + theta(3)) + 25*cos(theta(2)) + 12), -50*cos(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3)) + 5*sin(theta(2))), -50*cos(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3))), -250*sin(theta(2) + theta(3) + theta(4))*cos(theta(1)), 0;
                 10*cos(theta(1))*(25*cos(theta(2) + theta(3) + theta(4)) + 20*cos(theta(2) + theta(3)) + 25*cos(theta(2)) + 12), -50*sin(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3)) + 5*sin(theta(2))), -50*sin(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3))), -250*sin(theta(2) + theta(3) + theta(4))*sin(theta(1)), 0;
                 0,               250*cos(theta(2) + theta(3) + theta(4)) + 200*cos(theta(2) + theta(3)) + 250*cos(theta(2)),                 250*cos(theta(2) + theta(3) + theta(4)) + 200*cos(theta(2) + theta(3)),                250*cos(theta(2) + theta(3) + theta(4)), 0];
             
            for i=1:dof
                w_dot(i,1) = -(2*theta(i) + theta_min(i) - theta_max(i))/(10*(theta_min(i) - theta_max(i))^2);
            end
            
        otherwise
            return;
        end

        % Compute the errors. erro_ori is ignored if orientation control is off.
        erro_pos(k) = norm(goal_pos - effector_pos);
        erro_ori_aux = MultQuat(effector_quat,InvQuat(goal_ori));
        erro_ori(k) = norm((bsxfun(@times,erro_ori_aux(2:4),gains(4:6))));
        
        switch routine
            case 'A'
                error = [goal_pos - effector_pos;
                (bsxfun(@times,erro_ori_aux(2:4),gains(4:6)))];
            case 'B'
                error = goal_pos - effector_pos;
            case 'C'
                error = goal_pos - effector_pos;
            otherwise
                return;
        end
        
        % Computes the Pseudoinverse of the Jacobian via DLS.
        pseudoinverse = J'*(inv(J*J' + damp^2));
        
        % Computes the instant joint velocities.
        q_dot = pseudoinverse*(pd_dot(:,k) + K*error) + (eye(5) - pseudoinverse*J)*k_zero*w_dot(:,1);
        
        % Computes the joint values via integralization.
        theta_parc = [theta(1) + q_dot(1)*interval;
                      theta(2) + q_dot(2)*interval;
                      theta(3) + q_dot(3)*interval;
                      theta(4) + q_dot(4)*interval;
                      theta(5) + q_dot(5)*interval];
        
        % Computes PARTIAL the forward kinematics via Succesive Screws and Dual Quaternions.
        [effector_pos, effector_quat, joint_pos, z_axis] = FK_Movemaster_SSDQ(theta_parc);
        
        % Compute the errors. erro_ori is ignored if orientation control is off.
        erro_pos(k) = norm(goal_pos - effector_pos);
        erro_ori_aux = MultQuat(effector_quat,InvQuat(goal_ori));
        erro_ori(k) = norm((bsxfun(@times,erro_ori_aux(2:4),gains(4:6))));
        
    %%% Begin distance adaptation.
        
        if erro_pos(k) < 10
            
            % Computes the minimum distance from robot to +z plane.
            crit_joint = find(joint_pos(3,:)==(max(joint_pos(3,:))));
            crit_pos = joint_pos(:,crit_joint);

            crit_cliff  = clifford(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, crit_pos(3), -crit_pos(2), crit_pos(1), 0)*1;
            dist(k,1) = abs(part((pi_cliff_z*crit_cliff)-(crit_cliff*pi_cliff_z), 16)/2);

            critical = false;
            warning = false;
            overshoot = false;
            if dist(k,1) < dist_crit
                critical = true;
            else
                if dist(k,1) < dist_warn
                    warning = true;
                end
            end

            if crit_pos(3) >= z_med
                critical = true;
                overshoot = true;
            end

            % Changes q_dot depending on case.
            if critical
                % Forces effector to go down, so the critical joint probably goes down.
    %             goal_pos(3) = goal_pos(3) - (dist_crit - dist(k,1)*1.1);
                if overshoot
                    goal_pos(3) = goal_pos(3) - (dist(k,1) + dist_crit + dist_warn*0.1);
%                     goal_pos = goal_pos - (dist(k,1) + dist_crit + dist_warn*0.2);
                    fprintf('overshoot')
                else
                    goal_pos = goal_pos + ((dist_crit - dist(k,1))*1.1)*norm_z;
                end

                % Update the errors. erro_ori is ignored if orientation control is off.
                erro_pos(k) = norm(goal_pos - effector_pos);
                erro_ori_aux = MultQuat(effector_quat,InvQuat(goal_ori));
                erro_ori(k) = norm((bsxfun(@times,erro_ori_aux(2:4),gains(4:6))));

                switch routine
                    case 'A'
                        error = [goal_pos - effector_pos;
                        (bsxfun(@times,erro_ori_aux(2:4),gains(4:6)))];
                    case 'B'
                        error = goal_pos - effector_pos;
                    case 'C'
                        error = goal_pos - effector_pos;
                    otherwise
                        return;
                end

                % Updates q_dot.
                q_dot = pseudoinverse*(pd_dot(:,k) + K*error) + (eye(5) - pseudoinverse*J)*k_zero*w_dot(:,1);
                goal_pos_ant = goal_pos;
            else
                if warning
                    % If in warning zone, dampens changes in z axis on the effector.
                    % this does not prevent, however, the critical point from continuing to go up, since we control only the effector.
                    % Minimum between z and z_ant.
                    goal_pos(3) = min(goal_pos(3),goal_pos_ant(3));
    %                 goal_pos(3) = (goal_pos(3)*0.1 + goal_pos_ant(3)*0.9);

                    % Update the errors. erro_ori is ignored if orientation control is off.
                    erro_pos(k) = norm(goal_pos - effector_pos);
                    erro_ori_aux = MultQuat(effector_quat,InvQuat(goal_ori));
                    erro_ori(k) = norm((bsxfun(@times,erro_ori_aux(2:4),gains(4:6))));

                    switch routine
                        case 'A'
                            error = [goal_pos - effector_pos;
                            (bsxfun(@times,erro_ori_aux(2:4),gains(4:6)))];
                        case 'B'
                            error = goal_pos - effector_pos;
                        case 'C'
                            error = goal_pos - effector_pos;
                        otherwise
                            return;
                    end

                    % Updates q_dot.
                    q_dot = pseudoinverse*(pd_dot(:,k) + K*error) + (eye(5) - pseudoinverse*J)*k_zero*w_dot(:,1);
                end
            end

        %%% End distance adaptation.
            check_dist = true;
        end
        
        theta = [theta(1) + q_dot(1)*interval;
                 theta(2) + q_dot(2)*interval;
                 theta(3) + q_dot(3)*interval;
                 theta(4) + q_dot(4)*interval;
                 theta(5) + q_dot(5)*interval]; 
        
        [effector_pos, effector_quat, joint_pos, z_axis] = FK_Movemaster_SSDQ(theta_parc);
        
        % Update the errors. erro_ori is ignored if orientation control is off.
        erro_pos(k) = norm(goal_pos - effector_pos);
        erro_ori_aux = MultQuat(effector_quat,InvQuat(goal_ori));
        erro_ori(k) = norm((bsxfun(@times,erro_ori_aux(2:4),gains(4:6))));
        
        if erro_pos(k) > 10 || critical || overshoot
            check_dist = false;
        end
        
        switch routine
            case 'A'
                error = [goal_pos - effector_pos;
                (bsxfun(@times,erro_ori_aux(2:4),gains(4:6)))];
            case 'B'
                error = goal_pos - effector_pos;
            case 'C'
                error = goal_pos - effector_pos;
            otherwise
                return;
        end
                    
        err_control = erro_pos(k);
    end
    
    % Fixes the joint limits.
    switch routine
        case 'A'
            % Do nothing.
        case 'B'
            % Clamps to the limit.
            theta_aux = wrapToPi(theta);
            for j=1:dof
                if (theta_aux(j) > theta_max(j))
                    theta(j) = theta_max(j);
                end
                if (theta_aux(j) < theta_min(j))
                    theta(j) = theta_min(j);
                end
            end
        case 'C'
            % Proposed Algorithm.
            theta_aux = wrapToPi(theta);
            for j=1:dof
                if (theta_aux(j) > theta_max(j))
                    theta(j) = theta_max(j);
                    k_zeros(j) = k_zeros(j)*1.01;
                end
                if (theta_aux(j) < theta_min(j))pd = [center(1) + radius(1)*cos(    2*pi*t*loop_time   +pi);
      center(2) + radius(2)*sin( -  2*pi*t*loop_time   +pi);
      center(3) + radius(3)*sin( -  2*pi*t*loop_time   +pi);
                                            0*t+deg2rad(0);
                                            0*t+deg2rad(60);
                                                       0*t];

                    theta(j) = theta_min(j);
                    k_zeros(j) = k_zeros(j)*1.01;
                end
                k_zero = diag(k_zeros);
            end
        otherwise
            return;
    end

    goal_pos_ant = goal_pos;
    GOALPOSPLOT(:,k) = goal_pos;

    % Saves plot variables.
    q_dot_plot(:,k) = q_dot;
    q_plot(:,k) = theta;
    J1(:,k)  =  joint_pos(:,1);
    J2(:,k)  =  joint_pos(:,2);
    J3(:,k)  =  joint_pos(:,3);
    J4(:,k)  =  joint_pos(:,4);
    J5(:,k)  =  joint_pos(:,5);
    EFF(:,k) =  effector_pos;

end

switch routine
    case 'A'
        q_plot_A = q_plot;
        erro_pos_A = erro_pos;
        EFF_A = EFF;
        dist_A = dist;
    case 'B'
        q_plot_B = q_plot;
        erro_pos_B = erro_pos;
        EFF_B = EFF;
        dist_B = dist;
    case 'C'
        q_plot_C = q_plot;
        erro_pos_C = erro_pos;
        EFF_C = EFF;
        dist_C = dist;
    otherwise
        return;
end

%% Plot the results.

q_plot = wrapToPi(q_plot);
q_dot_plot = wrapToPi(q_dot_plot);

colour = 'k';
fixer = 20;

figure
for i=1:dof
    subplot(3,3,i);
    plot(q_plot(i,:),colour);hold on
    plot(ones(1,length(t))*theta_min(i),'--k');hold on
    plot(ones(1,length(t))*theta_max(i),'--k');hold on
    axis ([fixer length(t) theta_min(i)-pi/6 theta_max(i)+pi/6]);
    title("Junta " + i)
end

subplot(3,3,i+1);
plot(erro_pos,colour);hold on
xlim ([fixer length(t)]);
ylim([0 20])
title('Erro de posição')

subplot(3,3,i+2);
plot(erro_ori,colour);hold on
xlim([fixer, length(t)]);
ylim([min(erro_ori(fixer:end))*0.9 max(erro_ori(fixer:end))*1.1])
title('Erro de Orientação')

subplot(3,3,i+3);
plot(q_dot_plot(1,:),'r'); hold on
plot(q_dot_plot(2,:),'g')
plot(q_dot_plot(3,:),'b')
plot(q_dot_plot(4,:),'c')
plot(q_dot_plot(5,:),'m')
xlim ([fixer length(t)]);
ylim([-0.08 0.08])
title('Joint Velocities')

subplot(3,3,i+4);
plot(dist,colour);hold on
xlim ([fixer length(t)]);
ylim([0 max(dist(fixer:end))*1.1])
title('Dist from obj')

%%
fig = figure;
hold off

for k = 1:20:length(EFF')
    tic
    
    x = [J1(1,k), J2(1,k), J3(1,k), J4(1,k), J5(1,k), EFF(1,k)];
    y = [J1(2,k), J2(2,k), J3(2,k), J4(2,k), J5(2,k), EFF(2,k)];
    z = [J1(3,k), J2(3,k), J3(3,k), J4(3,k), J5(3,k), EFF(3,k)];
    
    figure(fig);   
    
    plot3(x,y,z,'-o','Linewidth',3,'Color','k');hold on
    plot3(pd(1,:),pd(2,:),pd(3,:),'Color','r','Linewidth',2);hold on
    plot3(pd_trim(1,:),pd_trim(2,:),pd_trim(3,:),'Color','b','Linewidth',2);hold on
    plot3(GOALPOSPLOT(1,fixer:end),GOALPOSPLOT(2,fixer:end),GOALPOSPLOT(3,fixer:end),'Color','g','Linewidth',2);hold on
    
    surf(xp,yp,zp,'FaceAlpha',0.5,'FaceColor','r'); hold on;
    surf(xp2,yp2,zp2,'FaceAlpha',0.5,'FaceColor','g'); hold on;
    surf(xp3,yp3,zp3,'FaceAlpha',0.5,'FaceColor','y'); hold on;
    alpha(.5)

    text(J3(1,k),J3(2,k),J3(3,k),['\leftarrow' num2str(dist(k))])
    
    hold off;

    axis ([0 700 -350 350 0 800]);
    box
    view(60,45)
    
    if dist(k) < dist_crit
        set(gca,'Color','r')
    else
        if dist(k) < dist_warn
            set(gca,'Color','y')
        else
%             set(gca,'Color','b')
        end
    end
    
    while(toc < interval)
        %do nothing.
    end
    
end
set(gca,'Color','w')
%% Plot for the dissertation.

close all;

colour = 'b';

q_plot_B = wrapToPi(q_plot_B);
q_plot_C = wrapToPi(q_plot_C);

% Juntas.
for i=1:dof
    figure
    plot(q_plot_B(i,:),'r','Linewidth',2);hold on
    plot(q_plot_C(i,:),colour,'Linewidth',2);hold on
    plot(ones(1,length(t))*theta_min(i),'k','Linewidth',1);hold on
    plot(ones(1,length(t))*theta_max(i),'k','Linewidth',1);hold on
    
    rectangle('Position',[0,-2*pi,3000,theta_min(i)+2*pi],'FaceColor',[0.5 0 0 0.5])
    rectangle('Position',[0,theta_max(i),3000,2*pi-theta_max(i)],'FaceColor',[0.5 0 0 0.5])
    
%     axis ([fixer length(t) theta_min(i)-pi/6 theta_max(i)+pi/6]);
    axis ([fixer length(t) theta_min(i)-pi/4 theta_max(i)+pi/4]);
    xlabel('t')
    ylabel('rad')
    
    legend('Scalar gain','Proposed vector gain')
    
    saveas(gcf,strcat('Figures/Joint_',sprintf('%d',i),'_',sprintf('%s',shape),'.png'))
end

% Erro de posição.
figure
plot(erro_pos_B,'r','Linewidth',2);hold on
plot(erro_pos_C,colour,'Linewidth',2);hold on
xlim ([fixer length(t)]);
ylim([0 15])
xlabel('t')
ylabel('mm')
legend('Scalar gain','Proposed vector gain')
saveas(gcf,strcat('Figures/Erro_pos_',sprintf('%s',shape),'.png'))

% Distância até +z... junta crítica.
dist_zmax_B = dist_B;
dist_zmax_C = dist_C;
figure
plot(dist_zmax_B,'r','Linewidth',2);hold on
plot(dist_zmax_C,colour,'Linewidth',2);hold on
rectangle('Position',[0,dist_crit,3000,dist_warn],'FaceColor',[240/255 230/255 140/255 0.4])
rectangle('Position',[0,0,3000,dist_crit],'FaceColor',[0.5 0 0 0.5])
xlim ([fixer length(t)]);
xlabel('t')
ylabel('mm')
legend('Scalar gain','Proposed vector gain')
saveas(gcf,strcat('Figures/dist_zmax_',sprintf('%s',shape),'.png'))

% Distância até -z... só precisa o efetuador.
dist_zmin_B = EFF_B(3,:) - 0;
dist_zmin_C = EFF_C(3,:) - 0;
figure
plot(dist_zmin_B,'r','Linewidth',2);hold on
plot(dist_zmin_C,colour,'Linewidth',2);hold on
rectangle('Position',[0,dist_crit,3000,dist_warn],'FaceColor',[240/255 230/255 140/255 0.4])
rectangle('Position',[0,0,3000,dist_crit],'FaceColor',[0.5 0 0 0.5])
xlim ([fixer length(t)]);
xlabel('t')
ylabel('mm')
legend('Scalar gain','Proposed vector gain')
saveas(gcf,strcat('Figures/dist_zmin_',sprintf('%s',shape),'.png'))

% Distância até +y... só precisa o efetuador.
dist_ymax_B = abs(EFF_B(2,:) - y2_med);
dist_ymax_C = abs(EFF_C(2,:) - y2_med);
figure
plot(dist_ymax_B,'r','Linewidth',2);hold on
plot(dist_ymax_C,colour,'Linewidth',2);hold on
rectangle('Position',[0,dist_crit,3000,dist_warn],'FaceColor',[240/255 230/255 140/255 0.4])
rectangle('Position',[0,0,3000,dist_crit],'FaceColor',[0.5 0 0 0.5])
xlim ([fixer length(t)]);
xlabel('t')
ylabel('mm')
legend('Scalar gain','Proposed vector gain','Location','northwest')
saveas(gcf,strcat('Figures/dist_ymax_',sprintf('%s',shape),'.png'))

% Distância até -y... só precisa o efetuador.
dist_ymin_B = abs(EFF_B(2,:) - y1_med);
dist_ymin_C = abs(EFF_C(2,:) - y1_med);
figure
plot(dist_ymin_B,'r','Linewidth',2);hold on
plot(dist_ymin_C,colour,'Linewidth',2);hold on
rectangle('Position',[0,dist_crit,3000,dist_warn],'FaceColor',[240/255 230/255 140/255 0.4])
rectangle('Position',[0,0,3000,dist_crit],'FaceColor',[0.5 0 0 0.5])
xlim ([fixer length(t)]);
xlabel('t')
ylabel('mm')
legend('Scalar gain','Proposed vector gain')
saveas(gcf,strcat('Figures/dist_ymin_',sprintf('%s',shape),'.png'))

% Trajetórias geradas.
figure
plot3(pd(1,:),pd(2,:),pd(3,:),'Color','r','Linewidth',3);hold on
plot3(pd_trim(1,:),pd_trim(2,:),pd_trim(3,:),'Color','b','Linewidth',3);hold on
plot3(GOALPOSPLOT(1,fixer:end),GOALPOSPLOT(2,fixer:end),GOALPOSPLOT(3,fixer:end),'Color','g','Linewidth',3);hold on
box
view(50,52)
% zlim([150 250]) 
xlabel('x')
ylabel('y')
zlabel('z')

saveas(gcf,strcat('Figures/Trajectories_',sprintf('%s',shape),'_',routine,'.png'))

% close all;
%% Trajectory execution.

ros = true;

if ~ros
    return
end

pause(5)

trajectory = wrapTo180(rad2deg(q_plot));
effector_pos_encoder = zeros(3,1);
effector_pos_odometry = zeros(3,1);

% Sends first position on the trajectory.
msg.GoHome = 0;
msg.SetGRIP = false;
msg.Set1 = trajectory(1,fixer);
msg.Set2 = trajectory(2,fixer);
msg.Set3 = trajectory(3,fixer);
msg.Set4 = trajectory(4,fixer);
msg.Set5 = trajectory(5,fixer) - trajectory(4,fixer);
send(pub,msg);

pause(10)

% Sends the trajectory.
tftree = rostf;

j=0;
for k = fixer:5:length(trajectory')
    j=j+1;

    msg.Set1 = trajectory(1,k);
    msg.Set2 = trajectory(2,k);
    msg.Set3 = trajectory(3,k);
    msg.Set4 = trajectory(4,k);
    msg.Set5 = trajectory(5,k) - trajectory(4,k);

    send(pub,msg);

    % Configuration acording to the encoders.
    for i = 1:5
        received(i) = receive(sub(i),10);
        config_encoders(i,1) = deg2rad(double(received(i).PulseCount));
    end
    [effector_pos_encoder(:,j), effector_quat_encoder(:,j), joint_pos_encoder(:,:,j), z_axis_encoder(:,:,j)] = FK_Movemaster_SSDQ(config_encoders);

    % Configuration acording to odometry camera.
    waitForTransform(tftree, 'odom', 'virtual_effector', 10);
    odometry = getTransform(tftree,'odom','virtual_effector');
    effector_pos_odometry(1,j) = odometry.Transform.Translation.X*1000;
    effector_pos_odometry(2,j) = odometry.Transform.Translation.Y*1000;
    effector_pos_odometry(3,j) = odometry.Transform.Translation.Z*1000;
    effector_quat_odometry(1,j) = odometry.Transform.Rotation.W;
    effector_quat_odometry(2,j) = odometry.Transform.Rotation.X;
    effector_quat_odometry(3,j) = odometry.Transform.Rotation.Y;
    effector_quat_odometry(4,j) = odometry.Transform.Rotation.Z;

    % Publishes estimated effector pose.
    msg_effectorPosition.X = effector_pos_encoder(1,j)/1000;
    msg_effectorPosition.Y = effector_pos_encoder(2,j)/1000;
    msg_effectorPosition.Z = effector_pos_encoder(3,j)/1000;
    send(pub_effectorPosition, msg_effectorPosition);

    msg_effectorOrientation.W = effector_quat_encoder(1,j);
    msg_effectorOrientation.X = effector_quat_encoder(2,j);
    msg_effectorOrientation.Y = effector_quat_encoder(3,j);
    msg_effectorOrientation.Z = effector_quat_encoder(4,j);
    send(pub_effectorOrientation, msg_effectorOrientation);

%     error = 100;
%     while(error > 10)
%         getTheta = receive(sub_joints);
%         [effector_pos, ~, ~, ~] = FK_Movemaster_SSDQ(getTheta.Position);
%         error = norm(EFF(:,k) - effector_pos);
%     end
%     pause(10*interval);
end

% Plot measures.
figure;
plot3(effector_pos_odometry(1,:),effector_pos_odometry(2,:),effector_pos_odometry(3,:),'Color','c','Linewidth',2);hold on
plot3(effector_pos_encoder(1,:),effector_pos_encoder(2,:),effector_pos_encoder(3,:),'Color','m','Linewidth',2);hold on
plot3(GOALPOSPLOT(1,fixer:end),GOALPOSPLOT(2,fixer:end),GOALPOSPLOT(3,fixer:end),'Color','g','Linewidth',2);hold on
box
view(60,15)
xlabel('x')
ylabel('y')
zlabel('z')
saveas(gcf,strcat('Figures/Measurement_',sprintf('%s',shape),'.png'))

%%
% PLOTS ESPECIAIS
figure;
plot3(pd(1,:),pd(2,:),pd(3,:),'Color','r','Linewidth',2);hold on
box
xlabel('x')
ylabel('y')
zlabel('z')
saveas(gcf,strcat('Figures/Trajetoy_Generated_',sprintf('%s',shape),'.png'))

figure
plot(erro_ori,'k','Linewidth',2);hold on
xlim([fixer, length(t)]);
ylim([min(erro_ori(fixer:end))*0.9 max(erro_ori(fixer:end))*1.1])
xlabel('t')
ylabel('rad')
saveas(gcf,strcat('Figures/Ori_error_',sprintf('%s',shape),'.png'))
%%
% leitura da rosbag pra odometria


rosshutdown;
rosinit;


sub(1) = rossubscriber('/status_1');
sub(2) = rossubscriber('/status_2');
sub(3) = rossubscriber('/status_3');
sub(4) = rossubscriber('/status_4');
sub(5) = rossubscriber('/status_5');

[pub,msg] = rospublisher('/setpoints','movemaster_msg/setpoint');
[pub_ceiling, msg_ceiling] = rospublisher('/ceiling', 'std_msgs/Float32');
[pub_right, msg_right] = rospublisher('/right', 'std_msgs/Float32');
[pub_left, msg_left] = rospublisher('/left', 'std_msgs/Float32');

[pub_ceilingORI, msg_ceilingORI] = rospublisher('/ceilingORI', 'geometry_msgs/Quaternion');
[pub_rightORI, msg_rightORI] = rospublisher('/rightORI', 'geometry_msgs/Quaternion');
[pub_leftORI, msg_leftORI] = rospublisher('/leftORI', 'geometry_msgs/Quaternion');

[pub_effectorPosition, msg_effectorPosition] = rospublisher('/effectorPosition', 'geometry_msgs/Point');
[pub_effectorOrientation, msg_effectorOrientation] = rospublisher('/effectorOrientation', 'geometry_msgs/Quaternion');


% Sends the trajectory.
tftree = rostf;

j=0;
% for k = fixer:5:length(trajectory')
while 1
    j=j+1;

    % Configuration acording to the encoders.
    for i = 1:5
        received(i) = receive(sub(i),20);
        config_encoders(i,1) = deg2rad(double(received(i).PulseCount));
    end
    [effector_pos_encoder(:,j), effector_quat_encoder(:,j), joint_pos_encoder(:,:,j), z_axis_encoder(:,:,j)] = FK_Movemaster_SSDQ(config_encoders);

    % Configuration acording to odometry camera.
    waitForTransform(tftree, 'odom', 'virtual_effector', 10);
    odometry = getTransform(tftree,'odom','virtual_effector');
    effector_pos_odometry(1,j) = odometry.Transform.Translation.X*1000;
    effector_pos_odometry(2,j) = odometry.Transform.Translation.Y*1000;
    effector_pos_odometry(3,j) = odometry.Transform.Translation.Z*1000;
    effector_quat_odometry(1,j) = odometry.Transform.Rotation.W;
    effector_quat_odometry(2,j) = odometry.Transform.Rotation.X;
    effector_quat_odometry(3,j) = odometry.Transform.Rotation.Y;
    effector_quat_odometry(4,j) = odometry.Transform.Rotation.Z;
end


fixer_encoder = 400;
fixer_encoder2 = 400;
fixer_odom = 300;
% Plot measures.
close all;
figure;
plot3(effector_pos_odometry(1,fixer_odom:end),effector_pos_odometry(2,fixer_odom:end),effector_pos_odometry(3,fixer_odom:end),'Color','b','Linewidth',2);hold on
plot3(effector_pos_encoder(1,fixer_encoder:end-fixer_encoder2),effector_pos_encoder(2,fixer_encoder:end-fixer_encoder2),effector_pos_encoder(3,fixer_encoder:end-fixer_encoder2),'Color','r','Linewidth',2);hold on
plot3(GOALPOSPLOT(1,fixer:end),GOALPOSPLOT(2,fixer:end),GOALPOSPLOT(3,fixer:end),'Color','g','Linewidth',2);hold on
box
% axis equal
view(50,50)
xlabel('x')
ylabel('y')
zlabel('z')
saveas(gcf,strcat('Figures/Measurement_',sprintf('%s',shape),'.png'))

figure;
% plot3(effector_pos_odometry(1,fixer_odom:end),effector_pos_odometry(2,fixer_odom:end),effector_pos_odometry(3,fixer_odom:end),'Color','b','Linewidth',2);hold on
plot3(effector_pos_encoder(1,fixer_encoder:end-fixer_encoder2),effector_pos_encoder(2,fixer_encoder:end-fixer_encoder2),effector_pos_encoder(3,fixer_encoder:end-fixer_encoder2),'Color','r','Linewidth',2);hold on
plot3(GOALPOSPLOT(1,fixer:end),GOALPOSPLOT(2,fixer:end),GOALPOSPLOT(3,fixer:end),'Color','g','Linewidth',2);hold on
box
% axis equal
view(50,50)
xlabel('x')
ylabel('y')
zlabel('z')
saveas(gcf,strcat('Figures/Measurement_NO_ODOM_',sprintf('%s',shape),'.png'))


