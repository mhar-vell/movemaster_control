function b = cast(q, newclass)
% CAST  Cast multivector variable to different data type.
% (Clifford overloading of standard Matlab function.)

% This function was copied from the Quaternion Toolbox for Matlab (QTFM).

% Copyright © 2008 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

narginchk(2, 2), nargoutchk(0, 1)

if ~ischar(newclass)
    error('Second parameter must be a string.')
end

b = overloade(mfilename, q, newclass);

% $Id: cast.m 271 2021-07-11 19:54:47Z sangwine $
