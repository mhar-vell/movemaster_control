% ROS Configuration

rosshutdown;
rosinit;

sub(1) = rossubscriber('/status_1');
sub(2) = rossubscriber('/status_2');
sub(3) = rossubscriber('/status_3');
sub(4) = rossubscriber('/status_4');
sub(5) = rossubscriber('/status_5');
sub_joints = rossubscriber('/joint_states');
    
[pub,msg] = rospublisher('/setpoints','movemaster_msg/setpoint');
[pub_hanoi,msg_hanoi] = rospublisher('/hanoi_status','std_msgs/Int32MultiArray');

vetor_desenho = [1 2 3 7 8 9];
msg_hanoi.Data = vetor_desenho;
send(pub_hanoi,msg_hanoi);

% IK

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


for i = 1:length(vetor_posicoes)

    % Home configuration.
    home = [deg2rad(   0);
            deg2rad( 106);
            deg2rad(-123);
            deg2rad(   0);
            deg2rad(   0)];
    
    %altura = baixo;
    %pino = pino4;
    
    % Defines the destination pose.
    goal_pos = [465;vetor_posicoes(i,1);vetor_posicoes(i,2)];
    ori_angle = deg2rad(90); % Calculations in radians, to the Movemaster in degrees.
    
    % Computes the inverse kinematics.
    ori_axis = [0;1;0];
    goal_ori = [cos(ori_angle/2); sin(ori_angle/2)*ori_axis];
    [theta, ~, valid] = MovemasterIK_PosAndOri(home, goal_pos, ori_angle);
    theta_deg = wrapTo180(rad2deg(theta));
    
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
    
        send(pub,msg);
        msg_hanoi.Data = vetor_desenho(ceil((i+2)/6),:);
        send(pub_hanoi,msg_hanoi);
    end
    pause(0.8);
end
