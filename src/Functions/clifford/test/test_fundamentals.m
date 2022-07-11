function test_fundamentals
% Test code for the fundamental clifford functions.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

tdisp('Testing fundamentals ...');

% Do some checks on the basis and signature.

s = clifford_signature; p = s(1); q = s(2); r = s(3);
n = sum(s);
m = 2.^n;
b = clifford_basis;

check(2.^sum(s) == length(b), 'Basis does not agree with signature.')

% The next step takes quite a lot of time in large algebras, so we break
% the calculation into pieces.

B = clifford.empty;

for j=1:512:m
    B(j:min(m, j+511)) = b(j:min(m, j+511)) .* b(j:min(m, j+511));
end

S = part(B, 1); % The coefficient of the scalar part.

check(S(1)     ==  1, 'e0 does not square to +1! Test 1.')
check(e0 .* e0 == e0, 'e0 does not square to +1! Test 2.')

check(sum(S(2:2+n-1) == +1) == p, 'Number of basis elements squaring to +1 incorrect')
check(sum(S(2:2+n-1) == -1) == q, 'Number of basis elements squaring to -1 incorrect')
check(sum(S(2:2+n-1) ==  0) == r, 'Number of basis elements squaring to 0 incorrect')

% Check that the constructor can make a multivector out of m numerics.

A = part(clifford(1:m), 1); % This result is numeric.
for j = 1:m
   check(A(j) == j, 'Constructor fails on 1:m test');
end

tdisp('Passed');

end

% $Id: test_fundamentals.m 3 2015-03-26 11:38:49Z sangwine $
