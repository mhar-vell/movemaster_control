function test_inverses
% Test code for the matrix inverse.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% Test the matrix inverse operation, if it is defined. (The elementwise
% inverse is tested in the test_power function.)

s = clifford_signature;
if s(3) ~= 0
    tdisp(['Skipping test of matrix inverse: ', ...
          'inverse of a multivector is not defined in algebras with r > 0.'])
else
    tdisp('Testing matrix inverse ...');
    
    % Ideally we would check whether the matrix is well-conditioned, but we
    % don't have the necessary functions implemented to do this (e.g. with
    % the SVD we could check the condition number). Some matrices generated
    % by randm will be ill-conditioned. So we try several and if all fail,
    % there must be an error in the inverse.
    
    T = 1e-4; % The tolerance.
    D = zeros(3,1);
    
    for j = 1:3
        m = randm(5);
        D(j) = max(max(normm(m * inv(m) - e0 .* eye(size(m)))));
    end
    
    if all(D > T)
        terror('Matrix inverse fails')
    end
    
    tdisp('Passed');
end

end

% $Id: test_inverses.m 259 2021-06-16 12:26:07Z sangwine $
