function p = vector(m)
% VECTOR  Extracts the vector component of a clifford multivector.
% The result is a multivector.

% Copyright © 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

global clifford_descriptor;

if clifford_descriptor.n < 1
    error('There are no vectors in the current clifford algebra.')
end

p = grade(m, 1);

end

% $Id: vector.m 271 2021-07-11 19:54:47Z sangwine $
