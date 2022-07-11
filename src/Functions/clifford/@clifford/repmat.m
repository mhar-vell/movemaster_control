function b = repmat(a, m, n)
% REPMAT Replicate and tile an array.
% (Clifford overloading of standard Matlab function.)

% Copyright © 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(2, 3), nargoutchk(0, 1) 

b = overload(mfilename, a, m, n);

end

% $Id: repmat.m 271 2021-07-11 19:54:47Z sangwine $
