function test_lu
% Test code for the clifford LU decomposition.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

s = clifford_signature;
if s(3) ~= 0
    tdisp(['Skipping test of LU decomposition: ', ...
           'multivector inverse is not defined in this algebra'])
else
    tdisp('Testing LU decomposition ...');

    A = randm(5);
    
    [L, U, P] = lu(A);
    
    if max(max(abs(L * U - P * A))) < 5e-5
        tdisp('Passed')
    else
        twarning(['LU decomposition residual exceeds test threshold: ', ...
                  num2str(max(max(abs(L * U - P * A)))) ])
    end

end

end

% $Id: test_lu.m 225 2019-05-30 15:59:46Z sangwine $
