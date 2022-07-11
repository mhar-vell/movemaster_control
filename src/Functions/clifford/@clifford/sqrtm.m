function X = sqrtm(A)
% SQRTM  Matrix square root.
% (Clifford overloading of standard Matlab function.)

% Adapted from the Quaternion Toolbox for Matlab.
% Copyright © 2008, 2010 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

X = overloadm(mfilename, A);

% TODO Implement a more accurate dedicated algorithm for this function.

% $Id: sqrtm.m 271 2021-07-11 19:54:47Z sangwine $
