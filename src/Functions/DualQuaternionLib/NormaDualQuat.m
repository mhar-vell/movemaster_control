function [s] = NormaDualQuat(dq)
    c1 = sqrt(sum(MultDualQuat(dq,ConjDualQuat(dq)).^2));
    c2 = sqrt(sum((MultQuat(ConjQuat(dq(1:4)),dq(5:8))+MultQuat(ConjQuat(dq(5:8)),dq(1:4))).^2));

    s = [c1;c2];
end

