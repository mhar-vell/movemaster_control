function B = interleave(A, N)
% Private function. Converts a matrix A which is the real representation of
% a multivector array, from a block matrix form in which each block
% contains e0, e1, e2, etc., coefficients, to a form in which each block
% contains the coefficients of one multivector. The reverse process is done
% by the function deinterleave.

% Copyright © 2017 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(2,2); nargoutchk(0,1);

assert(isa(A, 'numeric') || isa(A, 'clifford'));
assert(isa(N, 'numeric') && isscalar(N));
assert(isa(N, 'double')); % Needed for the rem function call to work.

[R, C] = size(A); assert(all(rem([R, C], N) == 0));

J = interleave_index(R, R/N);
K = interleave_index(C, C/N);

% This is a private class method, therefore we cannot use normal array
% indexing here. See the file implementation_notes.txt, 'Indexing within
% class methods'.

B = subsref(A, substruct('()', {J, K})); % B = A(J, K);

end

% $Id: interleave.m 271 2021-07-11 19:54:47Z sangwine $
