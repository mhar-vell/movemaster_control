rosshutdown;
rosinit;
    
[pub,msg] = rospublisher('/setpoints','movemaster_msg/setpoint');

load('pontos.mat')

%% IK
for j = 1:30
    j
for i = 1:length(theta_points)-1

    theta_deg = theta_points(i,:);

    % Movemaster
    
    msg.GoHome = 0;
    msg.Set1 = theta_deg(1);
    msg.Set2 = theta_deg(2);
    msg.Set3 = theta_deg(3);
    msg.Set4 = theta_deg(4);
    msg.Set5 = theta_deg(5) - theta_deg(4);
    
    send(pub,msg);
    
    pause(5);
    
end
end