function r = grade_four_involution(m)
% GRADE_FOUR_INVOLUTION  Computes the grade 4 involution of a clifford multivector.
% This function negates the grade four elements of a multivector.

% Copyright © 2015, 2021 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

check_signature(m);

r = involution(m, 4);

end

% $Id: grade_four_involution.m 292 2021-08-02 18:31:06Z sangwine $
