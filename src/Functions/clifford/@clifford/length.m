function n = length(x)
% LENGTH   Length of vector or length of longest array dimension.
% (Clifford overloading of standard Matlab function.)

% Copyright © 2015 Stephen J. Sangwine and Eckhard Hitzer.
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

n = max(size(x));

% $Id: length.m 271 2021-07-11 19:54:47Z sangwine $
