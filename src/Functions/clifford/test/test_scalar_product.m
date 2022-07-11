function test_scalar_product
% Test code for the clifford scalar product function.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

tdisp('Testing scalar product ...');

m1 = randm(2); % Make two random arrays.
m2 = randm(2);

% The test is based on a simple formula for computing the scalar product.
% The scalar_product function does not use this formula because it would
% compute the entire product of two multivectors and then discard most of
% the result. We do however use the formula here as a check that the rather
% more complicated code in the scalar product function yields the correct
% result. This takes some time because of the time wasted computing the
% parts of the result that are discarded, which is significant in larger
% algebras.

check(scalar_product(m1, m2) == part(m1 .* m2, 1), 'Scalar product fails.');

tdisp('Passed');

end

% $Id: test_scalar_product.m 283 2021-07-22 21:09:48Z sangwine $
