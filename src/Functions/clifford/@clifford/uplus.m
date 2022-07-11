function u = uplus(a)
% +  Unary plus.
% (Clifford overloading of standard Matlab function.)

% Copyright © 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1) 

u = a; % Since + does nothing, we can just return a.

% $Id: uplus.m 271 2021-07-11 19:54:47Z sangwine $

