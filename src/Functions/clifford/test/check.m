function check(L, E)
% Test function to check a logical condition L, and output an error
% message from the string in the parameter E if false. L may be a vector,
% in which case, all its elements are required to be true.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(2, 2), nargoutchk(0, 0)

if ~islogical(L)
    terror('First parameter must be logical.');
end

if ~all(L)
    terror(E);
end

% $Id: check.m 165 2017-12-29 21:21:30Z sangwine $
