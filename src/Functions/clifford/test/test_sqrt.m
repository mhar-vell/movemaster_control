function test_sqrt
% Test code for the Clifford sqrt function.

% Copyright (c) 2018 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

s = clifford_signature;

if s(3) > 0
    tdisp('Skipping test of square root: cannot be computed in this algebra.');
    return
end

tdisp('Testing square root function ...')

T = 1e-8;

% Test 1. Real multivector data.

m = randm(4,5);

compare(m, sqrt(m).^2, T, 'clifford/sqrt failed test 1.');

% Test 2. Complex multivector data.

m = complex(randm(3,4), randm(3,4));

compare(m, sqrt(m).^2, T, 'clifford/sqrt failed test 2.');

% Test 3. Arrays with more than 2 dimensions.

m = randm(2,2,3);

compare(m, sqrt(m).^2, T, 'clifford/sqrt failed test 3.');

tdisp('Passed');

% $Id: test_sqrt.m 226 2019-05-30 19:27:36Z sangwine $
