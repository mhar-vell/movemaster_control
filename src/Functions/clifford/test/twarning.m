function twarning(S)
% As warning, but adds a string defining the current algebra as a prefix.
% Used to avoid having to edit complex edits into all the test functions,
% instead warning is changed to twarning everywhere in the test code.

% Copyright (c) 2017  Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

warning([current_signature, ': ', S])

end

% $Id: twarning.m 167 2017-12-31 17:18:20Z sangwine $