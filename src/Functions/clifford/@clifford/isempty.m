function tf = isempty(m)
% ISEMPTY True for empty matrix.
% (Clifford overloading of standard Matlab function.)

% Copyright © 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor

% We use a loop here in order to cut short the tests if we find a non-empty
% element in the multivector cell array, because testing for empty is quite
% a time-consuming operation.

for j = 1:clifford_descriptor.m
    tf = isempty(m.multivector{j});
    if ~tf
        return % One element is not empty. We don't need to check any more.
    end
end

tf = true; % All the elements were found to be empty.

end

% $Id: isempty.m 271 2021-07-11 19:54:47Z sangwine $
