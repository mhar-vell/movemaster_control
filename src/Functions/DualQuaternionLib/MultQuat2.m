function [s] = MultQuat2(q1,q2)
    
    a0 = q1(1);
    a1 = q1(2);
    a2 = q1(3);
    a3 = q1(4);
    
    b0 = q2(1);
    b1 = q2(2);
    b2 = q2(3);
    b3 = q2(4);
    
    s(1) = a0*b0 - a1*b1 - a2*b2 - a3*b3;
    s(2) = a0*b1 + a1*b0 + a2*b3 - a3*b2;
    s(3) = a0*b2 - a1*b3 + a2*b0 + a3*b1;
    s(4) = a0*b3 + a1*b2 - a2*b1 + a3*b0;
    
    s=s';
    
end