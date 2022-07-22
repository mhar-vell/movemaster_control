% ROS Configuration

rosshutdown;
rosinit;

sub(1) = rossubscriber('/status_1');
sub(2) = rossubscriber('/status_2');
sub(3) = rossubscriber('/status_3');
sub(4) = rossubscriber('/status_4');
sub(5) = rossubscriber('/status_5');
sub(6) = rossubscriber('/status_12');
sub(7) = rossubscriber('/status_22');
sub(8) = rossubscriber('/status_32');
sub(9) = rossubscriber('/status_42');
sub(10) = rossubscriber('/status_52');
sub(11) = rossubscriber('/status_13');
sub(12) = rossubscriber('/status_23');
sub(13) = rossubscriber('/status_33');
sub(14) = rossubscriber('/status_43');
sub(15) = rossubscriber('/status_53');
sub_joints = rossubscriber('/joint_states');
    
[pub,msg] = rospublisher('/setpoints','movemaster_msg/setpoint');
[pub2,msg2] = rospublisher('/setpoints2','movemaster_msg/setpoint');
[pub3,msg3] = rospublisher('/setpoints3','movemaster_msg/setpoint');
[pub_hanoi,msg_hanoi] = rospublisher('/hanoi_status','std_msgs/Int32MultiArray');
[pub_hanoi2,msg_hanoi2] = rospublisher('/hanoi_status2','std_msgs/Int32MultiArray');
[pub_hanoi3,msg_hanoi3] = rospublisher('/hanoi_status3','std_msgs/Int32MultiArray');

vetor_desenho = [1 2 3 7 8 9];
vetor_desenho2 = [1 2 3 7 8 9];
vetor_desenho3 = [1 2 3 7 8 9];
msg_hanoi.Data = vetor_desenho;
msg_hanoi2.Data = vetor_desenho2;
msg_hanoi3.Data = vetor_desenho3;
send(pub_hanoi,msg_hanoi);
send(pub_hanoi2,msg_hanoi2);
send(pub_hanoi3,msg_hanoi3);

%% pontos

%robo1

[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(6,9,10,vetor_desenho)];
vetor_posicoes = vetor_posicoes_novo;
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(3,3,9,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(2,2,4,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(3,9,5,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(5,8,2,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(6,10,3,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(4,7,10,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(6,3,7,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(5,2,11,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(6,7,12,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(1,1,7,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(6,12,1,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(5,11,8,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(6,1,9,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(4,10,1,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(6,9,10,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(5,8,2,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(3,5,3,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(2,4,8,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(3,3,9,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];
[vetor_posicoes_novo, vetor_desenho_novo] = [criapontos(6,10,3,vetor_desenho(end,:))];
vetor_posicoes = [vetor_posicoes;vetor_posicoes_novo];
vetor_desenho = [vetor_desenho;vetor_desenho_novo];

% robo2

[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(3,3,10,vetor_desenho2)];
vetor_posicoes2 = vetor_posicoes_novo2;
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(2,2,4,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(3,10,5,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(1,1,10,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(3,5,1,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(2,4,11,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(3,1,12,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(6,9,1,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(5,8,4,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(6,1,5,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(4,7,1,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(6,5,7,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(5,4,2,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(6,7,3,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(3,12,7,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(2,11,4,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(3,7,5,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(1,10,7,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(3,5,10,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(2,4,8,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];
[vetor_posicoes_novo2, vetor_desenho_novo2] = [criapontos(3,10,9,vetor_desenho2(end,:))];
vetor_posicoes2 = [vetor_posicoes2;vetor_posicoes_novo2];
vetor_desenho2 = [vetor_desenho2;vetor_desenho_novo2];

%% IK

for i = 1:length(vetor_posicoes)

    % Home configuration.
    home = [deg2rad(   0);
            deg2rad( 106);
            deg2rad(-123);
            deg2rad(   0);
            deg2rad(   0)];
    
    % Defines the destination pose.
    goal_pos = [465;vetor_posicoes(i,1);vetor_posicoes(i,2)];
    goal_pos2 = [465;vetor_posicoes2(i,1);vetor_posicoes2(i,2)];
    %goal_pos3 = [465;vetor_posicoes3(i,1);vetor_posicoes3(i,2)];
    ori_angle = deg2rad(90); % Calculations in radians, to the Movemaster in degrees.
    
    % Computes the inverse kinematics.
    ori_axis = [0;1;0];
    goal_ori = [cos(ori_angle/2); sin(ori_angle/2)*ori_axis];
    [theta, ~, valid] = MovemasterIK_PosAndOri(home, goal_pos, ori_angle);
    [theta2, ~, valid] = MovemasterIK_PosAndOri(home, goal_pos2, ori_angle);
    %[theta3, ~, valid] = MovemasterIK_PosAndOri(home, goal_pos3, ori_angle);
    theta_deg = wrapTo180(rad2deg(theta));
    theta_deg2 = wrapTo180(rad2deg(theta2));
    %theta_deg3 = wrapTo180(rad2deg(theta3));
    
    if goal_pos(1) < 10
        valid= false;
    end
    
    if goal_pos(3) < 10
        valid= false;
    end
    valid;
    
    % Movemaster
    
    if valid
        msg.GoHome = 0;
        msg.Set1 = theta_deg(1);
        msg.Set2 = theta_deg(2);
        msg.Set3 = theta_deg(3);
        msg.Set4 = theta_deg(4);
        msg.Set5 = theta_deg(5) - theta_deg(4);

        msg2.GoHome = 0;
        msg2.Set1 = theta_deg2(1);
        msg2.Set2 = theta_deg2(2);
        msg2.Set3 = theta_deg2(3);
        msg2.Set4 = theta_deg2(4);
        msg2.Set5 = theta_deg2(5) - theta_deg2(4);

        %msg3.GoHome = 0;
        %msg3.Set1 = theta_deg3(1);
        %msg3.Set2 = theta_deg3(2);
        %msg3.Set3 = theta_deg3(3);
        %msg3.Set4 = theta_deg3(4);
        %msg3.Set5 = theta_deg3(5) - theta_deg3(4);
    
        %send(pub,msg);
        %send(pub2,msg2);
        %send(pub3,msg3);
        
        i
        theta_save(i,:) = theta_deg;
        theta_save2(i,:) = theta_deg2;
        %theta_save3(i,:) = theta_deg3;

        %msg_hanoi.Data = vetor_desenho(ceil((i+2)/6),:);
        %send(pub_hanoi,msg_hanoi);
        %msg_hanoi2.Data = vetor_desenho2(ceil((i+2)/6),:);
        %send(pub_hanoi2,msg_hanoi2);
        %msg_hanoi3.Data = vetor_desenho3(ceil((i+2)/6),:);
        %send(pub_hanoi3,msg_hanoi3);
    end
    %pause(0.8);
end

save('trajetorias.mat','theta_save','theta_save2','vetor_desenho','vetor_desenho2');
