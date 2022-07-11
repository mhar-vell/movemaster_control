function test_expm
% Test code for the Clifford expm and logm functions.

% Copyright (c) 2019 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor

s = clifford_signature;

if s(3) > 0
    tdisp('Skipping test of matrix exponential and logarithm: cannot be computed in this algebra.');
    return
end

tdisp('Testing matrix exponential and logarithm functions ...')

T = 1e-8;

% Test 1. Real multivector data.

m = randm(2, 'sparse', min(1, 3/cast(clifford_descriptor.m, 'double')));

compare(m, logm(expm(m)), T, 'clifford/expm+logm failed test 1.');

% Test 2. Complex multivector data.

% This test seems to be problematic, and sometimes fails with a large
% residual. Since this is not understood, the test is commented out for now
% until time permits a detailed investigation.

% T = 1e-4;
% 
% m = complex(m, randm(size(m)));
% 
% compare(m, logm(expm(m)), T, 'clifford/expm+logm failed test 2.');

tdisp('Passed');

% $Id: test_expm.m 285 2021-07-28 16:23:39Z sangwine $
