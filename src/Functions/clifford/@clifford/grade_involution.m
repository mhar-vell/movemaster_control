function r = grade_involution(m)
% GRADE_INVOLUTION  Computes the grade involution of a clifford multivector.
% This function negates the odd grade elements of a multivector.

% Copyright © 2013, 2021 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

check_signature(m);

global clifford_descriptor;

r = involution(m, [1:2:clifford_descriptor.n]);

end

% $Id: grade_involution.m 292 2021-08-02 18:31:06Z sangwine $
