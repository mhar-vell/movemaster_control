function Y = log(X)
% LOG Logarithm of the elements of a multivector array.
% (Clifford overloading of standard Matlab function.)

% Copyright © 2019 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

check_signature(X);

S = get_signature(X); p = S(1); q = S(2);

if S(3) ~= 0
    error(['Cannot compute logarithms in algebras ', ...
          'with basis elements that square to zero.'])
end

% The method used here is based on isomorphism with real/complex matrices
% and the matrix logarithm. We are forced to operate on one element of
% the input array at a time because of this. Maybe a better algorithm is
% possible?

% Convert the input array to a column vector of multivectors and then to an
% isomorphic block matrix of reals/complexes. We do it in this way and not
% by converting the multivectors one-by-one as the computation of the
% isomorphism requires switching of algebras which can be very
% time-consuming.

M = iso(reshape(X, [numel(X), 1]));
[r, c] = size(M);

N = min(r, c); % This is the size of the blocks within M.

% Now compute the matrix logarithm of each of the blocks. This could be
% done with a parfor, but the overhead may not be worth it for smaller
% algebras and arrays of multivectors.

for j = 1:N:r - N + 1
    V = j:j + N - 1;
    M(V, :) = logm(M(V, :));
end

% Compute the inverse isomorphism to convert back from real/complex blocks
% to multivectors, and reshape the result back to the size of the input
% array.

clifford_signature(0,0);

Y = reshape(iso(M .* e0, p, q), size(X));

end

% $Id: log.m 270 2021-07-11 19:42:06Z sangwine $
