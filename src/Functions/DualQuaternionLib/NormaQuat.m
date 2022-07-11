function [s] = NormaQuat(q)
    
    s = sqrt(sum(q.^2));
    
end

