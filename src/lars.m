% IK

cima = 200;
alto = 178;
medio = 165;
baixo = 152;
pino1 = -133;
pino2 = -43;
pino3 = 47;
pino4 = 137;

vetor_posicoes = [pino1 cima;
                  pino2 baixo;
                  pino3 cima;
                  pino4 baixo];

for i = 1:length(vetor_posicoes)

    % Home configuration.
    home = [deg2rad(   0);
            deg2rad( 106);
            deg2rad(-123);
            deg2rad(   0);
            deg2rad(   0)];
    
    altura = baixo;
    pino = pino4;
    
    % Defines the destination pose.
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
    end
end
