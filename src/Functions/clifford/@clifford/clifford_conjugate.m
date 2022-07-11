function r = clifford_conjugate(m)
% CLIFFORD_CONJUGATE  Computes the Clifford conjugate of a multivector.

% Copyright © 2013, 2021 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

check_signature(m);

global clifford_descriptor;

g = 0:clifford_descriptor.n; % List of grade numbers.

t = mod(g, 4); % Grades 1, 2, 4, 5, ... are to be negated.

r = involution(m, g(t == 1 | t == 2));

end

% $Id: clifford_conjugate.m 292 2021-08-02 18:31:06Z sangwine $
