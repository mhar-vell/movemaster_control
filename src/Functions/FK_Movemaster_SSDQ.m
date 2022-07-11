function [effector_pos, effector_quat, junta_pos, z_axis] = FK_Movemaster_SSDQ(theta)

dof = 5;

% eff0 = [1;0;0;0;0;640+190;0;400];% effector is at 830, the extra 190 is the gripper mechanism.
eff0 = [1;0;0;0;0;820;0;400];

s = [0   0   0  0  1;  %sx
     0  -1  -1 -1  0;  %sy
     1   0   0  0  0]; %sz

s0 = [  0  120 370 570 570;  %s0x
        0    0   0   0   0;  %s0y
      400  400 400 400 400]; %s0z

for i=1:dof
    a11 = (s(1,i)^2-1)*(1-cos(theta(i))) + 1;
    a12 = s(1,i)*s(2,i)*(1-cos(theta(i))) - s(3,i)*sin(theta(i));
    a13 = s(1,i)*s(3,i)*(1-cos(theta(i))) + s(2,i)*sin(theta(i));
    a21 = s(2,i)*s(1,i)*(1-cos(theta(i))) + s(3,i)*sin(theta(i));
    a22 = (s(2,i)^2-1)*(1-cos(theta(i))) + 1;
    a23 = s(2,i)*s(3,i)*(1-cos(theta(i))) - s(1,i)*sin(theta(i));
    a31 = s(3,i)*s(1,i)*(1-cos(theta(i))) - s(2,i)*sin(theta(i));
    a32 = s(3,i)*s(2,i)*(1-cos(theta(i))) + s(1,i)*sin(theta(i));
    a33 = (s(3,i)^2-1)*(1-cos(theta(i))) + 1;
    a14 = - s0(1,i)*(a11-1) - s0(2,i)*a12 - s0(3,i)*a13;
    a24 = - s0(1,i)*a21 - s0(2,i)*(a22-1) - s0(3,i)*a23;
    a34 = - s0(1,i)*a31 - s0(2,i)*a32 - s0(3,i)*(a33-1);

    [h(:,i),h_conj(:,i)] = make_h(s(:,i), theta(i), [a14;a24;a34], 'RT');
end

H(:,1) = h(:,1);
for i=2:dof
    H(:,i) = MultDualQuat(H(:,i-1),h(:,i));
end

H_conj(:,1) = h_conj(:,1);
for i=2:dof
    H_conj(:,i) = MultDualQuat(h_conj(:,i),H_conj(:,i-1));
end

for i=1:dof
    transformation(:,i) = MultDualQuat(MultDualQuat(H(:,i),[1;s(:,i);0;s0(:,i)]),H_conj(:,i));
end
effector_DQ = MultDualQuat(MultDualQuat(H(:,dof),eff0),H_conj(:,dof));

effector_pos = effector_DQ(6:8);
effector_quat = H(1:4,dof);
junta_pos = transformation(6:8,:);
z_axis = transformation(2:4,:);

end