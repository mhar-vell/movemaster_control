function [s] = ConjQuat(q)
    
    s = q;
    s(2:4) = -q(2:4);
    
end

