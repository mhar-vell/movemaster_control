function p = real(m)
% REAL   Real part of a multivector.
% (Clifford overloading of standard Matlab function.)
%
% This function returns the multivector that is the real part of m.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% Copyright © 2017 Stephen J. Sangwine and Eckhard Hitzer.
% Adapted from the Quaternion Toolbox for Matlab (QTFM), for use with
% Clifford multivectors.
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

p = overload(mfilename, m);

% $Id: real.m 271 2021-07-11 19:54:47Z sangwine $
