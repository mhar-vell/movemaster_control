function e = end(a, k, n)
% End indexing for clifford arrays.

% Copyright © 2005, 2008, 2010 Stephen J. Sangwine and Nicolas Le Bihan.
% Copyright © 2017 Stephen J. Sangwine and Eckhard Hitzer.
% Adapted from the Quaternion Toolbox for Matlab (QTFM), for use with
% Clifford multivectors.
% See the file : Copyright.m for further details.

% This function is implemented by calling the Matlab builtin function on a
% non-empty component of a, if one exists. This means the complexities of
% implementing this function can be avoided, which is helpful given the
% scant information provided in the Matlab documentation (see Matlab ->
% programming -> Classes and Objects -> Designing User Classes in Matlab ->
% Defining end Indexing for an Object). Prior to 31 March 2008, this code
% was implemented incorrectly as e = size(a, k) which fails when a is a row
% vector. Note that we do not check n, because it is passed to the builtin
% function, and will presumably raise an error there if there is a problem.

% Find the first non-empty element of a and return its index.
% (Method copied from the size.m file, q.v.).

% TODO This operation is quite costly. Is it possible to cut out
% some of the time in most cases by checking the size of the first
% element, and only then inspecting others? Or should we store the
% size of the multivector as an extra field inside the multivector?

j = find(~cellfun('isempty', a.multivector), 1);

if isempty(j)
    j = 1; % The first element serves if they are all empty.
end

e = builtin('end', a.multivector{j}, k, n);

end

% $Id: end.m 271 2021-07-11 19:54:47Z sangwine $
