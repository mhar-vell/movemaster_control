function p = imag(m)
% IMAG   Imaginary part of a multivector.
% (Clifford overloading of standard Matlab function.)
%
% This function returns the multivector that is the imaginary
% part of m. If m is a real multivector, it returns zero.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% Copyright © 2017 Stephen J. Sangwine and Eckhard Hitzer.
% Adapted from the Quaternion Toolbox for Matlab (QTFM), for use with
% Clifford multivectors.
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

p = overload(mfilename, m);

% $Id: imag.m 271 2021-07-11 19:54:47Z sangwine $
