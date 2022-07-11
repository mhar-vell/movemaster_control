function [s] = ConjDualQuat(q)
    
%     s = [ConjQuat(q(1:4)); ConjQuat(q(5:8))]; %---Essa é do TCC
    s = [ConjQuat(q(1:4)); -ConjQuat(q(5:8))];

end

