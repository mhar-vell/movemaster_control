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

msg_hanoi.Data = vetor_desenho(1,:);
msg_hanoi2.Data = vetor_desenho2(1,:);
msg_hanoi3.Data = vetor_desenho3(1,:);
msg_hanoi4.Data = vetor_desenho4(1,:);
send(pub_hanoi,msg_hanoi);
send(pub_hanoi2,msg_hanoi2);
send(pub_hanoi3,msg_hanoi3);
send(pub_hanoi4,msg_hanoi4);

%% IK

for i = 1:length(theta_save)

    theta_deg = theta_save(i,:);
    theta_deg2 = theta_save2(i,:);
    theta_deg3 = theta_save3(i,:);
    theta_deg4 = theta_save4(i,:);
    
    % Movemaster
    
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

    msg3.GoHome = 0;
    msg3.Set1 = theta_deg3(1);
    msg3.Set2 = theta_deg3(2);
    msg3.Set3 = theta_deg3(3);
    msg3.Set4 = theta_deg3(4);
    msg3.Set5 = theta_deg3(5) - theta_deg3(4);

    msg4.GoHome = 0;
    msg4.Set1 = theta_deg4(1);
    msg4.Set2 = theta_deg4(2);
    msg4.Set3 = theta_deg4(3);
    msg4.Set4 = theta_deg4(4);
    msg4.Set5 = theta_deg4(5) - theta_deg4(4);
    
    send(pub,msg);
    send(pub2,msg2);
    send(pub3,msg3);
    send(pub4,msg4);

    msg_hanoi.Data = vetor_desenho(ceil((i+2)/6),:);
    send(pub_hanoi,msg_hanoi);
    msg_hanoi2.Data = vetor_desenho2(ceil((i+2)/6),:);
    send(pub_hanoi2,msg_hanoi2);
    msg_hanoi3.Data = vetor_desenho3(ceil((i+2)/6),:);
    send(pub_hanoi3,msg_hanoi3);
    msg_hanoi4.Data = vetor_desenho4(ceil((i+2)/6),:);
    send(pub_hanoi4,msg_hanoi4);
    
    pause(0.5);

end