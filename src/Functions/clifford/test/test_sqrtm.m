function test_sqrtm
% Test code for the Clifford sqrtm function.

% Copyright (c) 2019 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

s = clifford_signature;

if s(3) > 0
    tdisp('Skipping test of matrix square root: cannot be computed in this algebra.');
    return
end

tdisp('Testing matrix square root function ...')

T = 1e-12;

% Test 1. Real multivector data.

m = randm(4);

compare(m, sqrtm(m)^2, T, 'clifford/sqrtm failed test 1.');

% Test 2. Complex multivector data.

m = complex(randm(4), randm(4));

compare(m, sqrtm(m)^2, T, 'clifford/sqrtm failed test 2.');

tdisp('Passed');

% $Id: test_sqrtm.m 208 2019-04-29 17:14:51Z sangwine $
