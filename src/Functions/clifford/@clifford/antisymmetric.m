function p = antisymmetric(m)
% ANTISYMMETRIC  Extracts the grades of a clifford multivector which change
%                sign under reversion.

% Copyright © 2019 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

% check_signature(m); % Redundant for now because reverse will check this.

% TODO A better algorithm here would calculate which grades are needed and
% retain just those, cf the reverse function. The code below is an initial
% hack to implement this function.

p = (m - reverse(m)) ./ 2;

end

% $Id: antisymmetric.m 270 2021-07-11 19:42:06Z sangwine $
