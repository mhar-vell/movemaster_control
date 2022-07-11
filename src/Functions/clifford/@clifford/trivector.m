function p = trivector(m)
% TRIVECTOR  Extracts the trivector component of a clifford multivector.
% The result is a multivector.

% Copyright © 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

global clifford_descriptor;

if clifford_descriptor.n < 3
    error('There are no trivectors in the current clifford algebra.')
end

p = grade(m, 3);

end

% $Id: trivector.m 271 2021-07-11 19:54:47Z sangwine $