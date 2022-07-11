function p = scalar(m)
% SCALAR  Extracts the scalar component of a clifford multivector.
% The result is a multivector with all components empty except the scalar.

% Copyright © 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

p = grade(m, 0);

end

% $Id: scalar.m 271 2021-07-11 19:54:47Z sangwine $
