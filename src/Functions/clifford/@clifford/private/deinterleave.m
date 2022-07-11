function A = deinterleave(B, N)
% Private function. The reverse of the function interleave (q.v.).

% Copyright © 2017 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(2,2); nargoutchk(0,1);

assert(isa(B, 'numeric') || isa(B, 'clifford'));
assert(isa(N, 'numeric') && isscalar(N));

[R, C] = size(B); assert(all(rem([R, C], N) == 0));

J = interleave_index(R, N);
K = interleave_index(C, N);

% This is a private class method, therefore we cannot use normal array
% indexing here. See the file implementation_notes.txt, 'Indexing within
% class methods'.

A = subsref(B, substruct('()', {J, K})); % A = B(J, K);

end

% $Id: deinterleave.m 271 2021-07-11 19:54:47Z sangwine $
