function tf = isexplicit(m)
% ISEXPLICIT True for a clifford multivector without empty components.
% This means that every component of the multivector contains a numeric
% array, none is empty.

% Copyright © 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

tf = ~any(cellfun('isempty', m.multivector));

% $Id: isexplicit.m 271 2021-07-11 19:54:47Z sangwine $
