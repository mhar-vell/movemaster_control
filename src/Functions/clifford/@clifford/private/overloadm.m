function R = overloadm(F, Q)
% Private function to implement overloading of matrix Matlab functions.
% Called to apply the function F to the multivector array Q by operating on
% an isomorphic representation of Q. F must be a string, giving the name of
% the function F. The calling function can pass this string using
% mfilename, for simplicity of coding.

% Copyright © 2019 Stephen J. Sangwine and Eckhard Hitzer.
% Based on a similar function in the Quaternion Toolbox for Matlab.
% See the file : Copyright.m for further details.

S = clifford_signature;

if S(3) > 0
    error('Private function overloadm cannot handle algebras with r > 0.')
end

H = str2func(F); % A handle to the function designated by F.

P = H(iso(Q));

clifford_signature(0,0);

R = iso(P .* e0, S(1), S(2));

% $Id: overloadm.m 271 2021-07-11 19:54:47Z sangwine $
