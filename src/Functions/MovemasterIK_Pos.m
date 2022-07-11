function [theta, joint_pos, valid] = MovemasterIK_Pos(theta_seed, goal_pos)
     
dof = 5;
k_max = 200;
try_max = 50;

k_kin = 1;
k_joints = 1;

% Joint Limits.
theta_min_UNWRAPED = deg2rad([-100; -30; -120; -100; -180]);
theta_max_UNWRAPED = deg2rad([ 100; 100;    0;  100;  180]);
theta_min = wrapToPi(theta_min_UNWRAPED);
theta_max = wrapToPi(theta_max_UNWRAPED);

% Gain Weights for IK priorization.
%               px  py  pz
gains = k_kin*[  1;  1;  1];
K = diag(gains);

% Jacobian singularity dampening.
%           px    py    pz
damp0 = [  0.1;  0.1;  0.1];
damp = diag(damp0);

k_zeros1 = k_joints*[  1;  1;  1;  1;  1];
k_zero1 = diag(k_zeros1);

valid = false;
tries = 0;

while valid==false && tries < try_max

    tries = tries + 1;

    theta = theta_seed;
    [effector_pos_start, effector_quat_start, joint_pos_start, z_axis_start] = FK_Movemaster_SSDQ(theta);

    erro_pos = goal_pos - effector_pos_start;

    k=1;

    while norm(erro_pos) > 0.1 && k < k_max

        [effector_pos, effector_quat, joint_pos, z_axis] = FK_Movemaster_SSDQ(theta);

        erro_pos = goal_pos - effector_pos;

        erro = erro_pos;

        J = [-10*sin(theta(1))*(25*cos(theta(2) + theta(3) + theta(4)) + 20*cos(theta(2) + theta(3)) + 25*cos(theta(2)) + 12), -50*cos(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3)) + 5*sin(theta(2))), -50*cos(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3))), -250*sin(theta(2) + theta(3) + theta(4))*cos(theta(1)), 0;
              10*cos(theta(1))*(25*cos(theta(2) + theta(3) + theta(4)) + 20*cos(theta(2) + theta(3)) + 25*cos(theta(2)) + 12), -50*sin(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3)) + 5*sin(theta(2))), -50*sin(theta(1))*(5*sin(theta(2) + theta(3) + theta(4)) + 4*sin(theta(2) + theta(3))), -250*sin(theta(2) + theta(3) + theta(4))*sin(theta(1)), 0;
              0,               250*cos(theta(2) + theta(3) + theta(4)) + 200*cos(theta(2) + theta(3)) + 250*cos(theta(2)),                 250*cos(theta(2) + theta(3) + theta(4)) + 200*cos(theta(2) + theta(3)),                250*cos(theta(2) + theta(3) + theta(4)), 0];

        % Computes the derivative of the distance from joint limits.
        for i=1:dof
            w_dot(i,1) = -(2*theta(i) + theta_min(i) - theta_max(i))/(10*(theta_min(i) - theta_max(i))^2);
        end

        pseudoinverse = J'*(inv(J*J' + damp^2));
        q_dot = pseudoinverse*K*erro + (eye(dof) - pseudoinverse*J)*k_zero1*w_dot;
  
        for j=1:dof
            theta(j) = theta(j) + q_dot(j);
        end

        k=k+1;
    end

    % Adjusts the joint limit gains.
    theta_aux = wrapToPi(theta);
    valid=true;
    for j=1:dof
        if (theta_aux(j) > theta_max(j)) || (theta_aux(j) < theta_min(j))
           valid = false;
           k_zeros1(j) = k_zeros1(j)*1.01;
        end
        k_zero1 = diag(k_zeros1);
    end
end
k;
tries;
% theta = wrapToPi(theta);

end

