function r = ne(a, b)
% ~=  Not equal.
% (Clifford overloading of standard Matlab function.)

% Copyright © 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(2, 2), nargoutchk(0, 1) 

r = ~(a == b); % Use the Clifford equality operator and invert the result.

end

% $Id: ne.m 271 2021-07-11 19:54:47Z sangwine $
