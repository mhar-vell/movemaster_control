% ROS Configuration

rosshutdown;
rosinit;
    
[pub,msg] = rospublisher('/setpoints','movemaster_msg/setpoint');
[pub2,msg2] = rospublisher('/setpoints2','movemaster_msg/setpoint');
[pub3,msg3] = rospublisher('/setpoints3','movemaster_msg/setpoint');
[pub4,msg4] = rospublisher('/setpoints4','movemaster_msg/setpoint');
[pub_hanoi,msg_hanoi] = rospublisher('/hanoi_status','std_msgs/Int32MultiArray');
[pub_hanoi2,msg_hanoi2] = rospublisher('/hanoi_status2','std_msgs/Int32MultiArray');
[pub_hanoi3,msg_hanoi3] = rospublisher('/hanoi_status3','std_msgs/Int32MultiArray');
[pub_hanoi4,msg_hanoi4] = rospublisher('/hanoi_status4','std_msgs/Int32MultiArray');

load('trajetorias.mat')

msg_hanoi.Data = vetor_desenho3(1,:);
msg_hanoi2.Data = vetor_desenho2(1,:);
msg_hanoi3.Data = vetor_desenho3(1,:);
msg_hanoi4.Data = vetor_desenho4(1,:);
send(pub_hanoi,msg_hanoi);
send(pub_hanoi2,msg_hanoi2);
send(pub_hanoi3,msg_hanoi3);
send(pub_hanoi4,msg_hanoi4);

%% IK

for i = 1:length(theta_save)

    theta_deg = theta_save3(i,:);

    % Movemaster
    
    msg.GoHome = 0;
    msg.Set1 = theta_deg(1);
    msg.Set2 = theta_deg(2);
    msg.Set3 = theta_deg(3);
    msg.Set4 = theta_deg(4);
    msg.Set5 = theta_deg(5) - theta_deg(4);
    
    send(pub,msg);

    msg_hanoi.Data = vetor_desenho3(ceil((i+2)/6),:);
    send(pub_hanoi,msg_hanoi);
    
    pause(3.5);
    
end