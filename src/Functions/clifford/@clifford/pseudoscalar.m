function p = pseudoscalar(m)
% PSEUDOSCALAR  Extracts the pseudoscalar component of a clifford multivector.
% The result is a multivector.

% Copyright © 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

global clifford_descriptor;

p = grade(m, clifford_descriptor.n);

end

% $Id: pseudoscalar.m 271 2021-07-11 19:54:47Z sangwine $
