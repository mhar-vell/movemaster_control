function u = uminus(a)
% -  Unary minus.
% (Clifford overloading of standard Matlab function.)

% Copyright © 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

global clifford_descriptor;

index = 1:clifford_descriptor.m;

u = a;

for i = index(~cellfun('isempty', a.multivector))
    u.multivector{i} = - u.multivector{i};
end

% $Id: uminus.m 271 2021-07-11 19:54:47Z sangwine $
