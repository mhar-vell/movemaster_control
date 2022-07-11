function descriptor
% CLIFFORD_DESCRIPTOR Outputs the values stored in the descriptor, for
% debugging purposes.

% Copyright © 2015, 2021 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% TODO Adjust the output according to the size of the algebra. Or consider
% providing a parameter, so that without a parameter the function prints
% just the summary, with a parameter (string), a certain field can be
% returned as a result. Idea: this could provide access to the fields
% without using the global! Maybe make it a private function.

global clifford_descriptor;

if isempty(clifford_descriptor)
    disp('The Clifford descriptor is empty (un-initialised).')
    return
end

disp(clifford_descriptor) % This shows all the fields, but the values only
                          % of scalars and small vectors.

% Now output the arrays. Skip this if the algebra is too large.

if clifford_descriptor.m > 10
    disp('Array field values are too large to output here.');
    disp('Consider declaring ''global clifford_descriptor'' in command');
    disp('window to make the descriptor visible in the workspace.')
    return
end

if clifford_descriptor.m > 8
    disp('index_strings')
    disp(clifford_descriptor.index_strings)
end

% disp('sign:')
% disp(clifford_descriptor.sign)

disp('grade_table:')
disp(clifford_descriptor.grade_table)

end

% $Id: descriptor.m 270 2021-07-11 19:42:06Z sangwine $