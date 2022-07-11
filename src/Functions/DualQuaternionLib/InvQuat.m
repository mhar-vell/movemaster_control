function [s] = InvQuat(q)
    
    s = ConjQuat(q)/NormaQuat(q)^2;
    
end

