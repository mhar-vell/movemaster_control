function J = interleave_index(L, N)
% Private function. Computes an index vector for converting between two
% block matrix representations of a multivector. This vector can be used to
% rearrange elements in a row or column, using the vector as the index, for
% example A(J).

% The two matrix representations differ in what is contained in a block of
% size N. In one representation each block contains the corresponding
% coefficients of all the multivectors in the array. In this case the
% blocksize is the number of multivectors. In the other representation,
% each block contains all the coefficients of one multivector. In this case
% the blocksize is the number of coefficients in the multivector.

% L is the length of the vector required, and N is the blocksize.

% Copyright © 2017 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(2,2); nargoutchk(0,1);

assert(rem(L, N) == 0); % L must be an integer multiple of N.

M = 1:L;
J = [];

for i = 1:N
    J = [J M(i:N:end)]; %#ok<AGROW>
end

end

% $Id: interleave_index.m 271 2021-07-11 19:54:47Z sangwine $
