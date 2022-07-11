function test_exp
% Test code for the Clifford exp and log functions. This code relies on
% isomorphisms and the Matlab expm function for a comparison on the
% isomorphic real matrices.

% Copyright (c) 2019 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

tdisp('Testing exponential function ...')

global clifford_descriptor

if clifford_descriptor.signature(3) ~= 0
    tdisp(['Cannot test exponential/logarithm functions in algebra with r > 0 ' ...
           'due to limitation in iso function.'])
    return
end

% Errors are greater in algebras with larger dimension, so we vary the
% tolerance according to the dimension of the algebra. The lowest value
% of n is 0 (for algebra Cl(0,0)) so we need to index the tolerance
% vector with one greater than n. The largest value of n supported by
% the toolbox is 16. So we need 17 tolerance values.

tolerance = logspace(-5, -3, 17);

T = tolerance(clifford_descriptor.n + 1);

% Test 1. Real multivector data.

m = randm(2,3, 'sparse', min(1, 3/cast(clifford_descriptor.m, 'double')));
e = exp(m);

for r = 1:size(m, 1)
    for c = 1:size(m, 2)
        compare(expm(iso(m(r, c))), iso(e(r, c)), T, ...
            'clifford/exp failed test 1.');
    end
end

% Test 2. Complex multivector data.

m = complex(randm(3,2, 'sparse', min(1, 3/cast(clifford_descriptor.m, 'double'))), ...
            randm(3,2, 'sparse', min(1, 3/cast(clifford_descriptor.m, 'double'))));
e = exp(m);

for r = 1:size(m, 1)
    for c = 1:size(m, 2)
        compare(expm(iso(m(r, c))), iso(e(r, c)), 10 .* T, ...
            'clifford/exp failed test 2.');
    end
end

% Test 3. Arrays with more than 2 dimensions.

m = randm(2,2,3, 'sparse', min(1, 3/cast(clifford_descriptor.m, 'double')));
e = exp(m);

for r = 1:size(m, 1)
    for c = 1:size(m, 2)
        for p = 1:size(m, 3)
            compare(expm(iso(m(r, c, p))), iso(e(r, c, p)), T, ...
                'clifford/exp failed test 3.');
        end
    end
end

% Test 4. Check the logarithm function against the exponential.

m = randm(3);

compare(m, log(exp(m)), T, 'clifford/exp+log failed test 4.');

tdisp('Passed');

% $Id: test_exp.m 285 2021-07-28 16:23:39Z sangwine $
