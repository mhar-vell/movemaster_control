function [s] = MultQuat(q1,q2)
    
    q1_s = q1(1);
    q1_v = q1(2:4);
    q2_s = q2(1);
    q2_v = q2(2:4);

    s = [q1_s*q2_s - dot(q1_v,q2_v); (q1_s.*q2_v + q2_s.*q1_v + cross(q1_v,q2_v))];
    
end