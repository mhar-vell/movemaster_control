function tdisp(S)
% As disp, but adds a string defining the current algebra as a prefix. Used
% to avoid having to edit complex edits into all the test functions,
% instead disp is changed to tdisp everywhere in the test code.

% Copyright (c) 2017  Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

disp([current_signature, ': ', S])

end

% $Id: tdisp.m 165 2017-12-29 21:21:30Z sangwine $