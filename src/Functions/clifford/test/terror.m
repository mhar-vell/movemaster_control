function terror(S)
% As error, but adds a string defining the current algebra as a prefix. Used
% to avoid having to edit complex edits into all the test functions,
% instead error is changed to terror everywhere in the test code.

% Copyright (c) 2017  Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

error([current_signature, ': ', S])

end

% $Id: terror.m 166 2017-12-30 22:12:23Z sangwine $