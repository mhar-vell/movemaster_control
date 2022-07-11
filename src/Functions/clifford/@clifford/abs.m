function a = abs(m)
% ABS Absolute value, or modulus, of a multivector.
% (Clifford overloading of standard Matlab function.)

% Copyright © 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1) 

a = sqrt(normm(m)); % TODO There are multiple definitions that could be
                    % used here. It is not certain that this is the best.

end

% $Id: abs.m 270 2021-07-11 19:42:06Z sangwine $
