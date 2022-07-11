function p = symmetric(m)
% SYMMETRIC  Extracts the grades of a clifford multivector which do not
%            change sign under reversion.

% Copyright © 2019 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

% global clifford_descriptor;

% check_signature(m); % Redundant for now because reverse will check this.

% TODO A better algorithm here would calculate which grades are needed and
% retain just those, cf the reverse function. The code below is an initial
% hack to implement this function.

p = (m + reverse(m)) ./ 2;

end

% $Id: symmetric.m 271 2021-07-11 19:54:47Z sangwine $
