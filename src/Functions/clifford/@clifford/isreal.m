function tf = isreal(m)
% ISREAL True for real (clifford) array.
% (Clifford overloading of standard Matlab function.)

% Copyright © 2013, 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% This function returns true if all multivector components of A are real,
% that is, A is a multivector with real coefficients.

narginchk(1, 1), nargoutchk(0, 1)

tf = all(cellfun('isreal', m.multivector));

end

% $Id: isreal.m 271 2021-07-11 19:54:47Z sangwine $
