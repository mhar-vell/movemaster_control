function test_wedge_product
% Test code for the clifford wedge product function.

% Copyright (c) 2016 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

tdisp('Testing wedge product ...');

s = clifford_signature;

if sum(s) == 0
    tdisp(['Not testing wedge product, ' ...
           'because there are no vectors in this algebra'])
    return
end

v1 = grade(randm(5), 1); % Make two random arrays OF VECTORS.
v2 = grade(randm(5), 1);

% The first test is based on the classic formula which relates the
% geometric product to the sum of the wedge and scalar products FOR VECTOR
% ARGUMENTS. These tests assume that the scalar product has already been
% tested and that the geometric product has also been tested by
% verification of the multiplication table. This is why this test is
% referred to as a test of the wedge product which, until this test, has
% not been tested.

T = 1e-10;

compare(v1 .* v2, wedge(v1, v2) + scalar_product(v1, v2), T, ...
        'Wedge product fails test 1.');
compare(v2 .* v1, wedge(v2, v1) + scalar_product(v2, v1), T, ...
        'Wedge product fails test 2.');
 
% TODO Add further tests on full multivectors. Problem: there doesn't seem
% to be a formula for this that we can use.

% TODO Add tests on accuracy for calls with more than two arguments. See a
% note in wedge.m about computation in this case, where it appears that
% computing the products in a different order can yield better accuracy.

tdisp('Passed');

end

% $Id: test_wedge_product.m 242 2020-05-26 20:52:01Z sangwine $
