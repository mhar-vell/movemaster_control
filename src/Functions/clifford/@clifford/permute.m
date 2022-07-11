function B = permute(A, order)
% PERMUTE Rearrange dimensions of N-D array
% (Clifford overloading of standard Matlab function.)

% Copyright © 2015, 2016 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(2, 2), nargoutchk(0, 1)

B = overload(mfilename, A, order);

% $Id: permute.m 271 2021-07-11 19:54:47Z sangwine $
