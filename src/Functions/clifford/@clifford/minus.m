function m = minus(l, r)
% -   Minus.
% (Clifford overloading of standard Matlab function.)

% Copyright © 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(2, 2), nargoutchk(0, 1) 

m = plus(l, -r); % We use uminus to negate the right argument.

% $Id: minus.m 271 2021-07-11 19:54:47Z sangwine $
