function [p, e] = grade(m, k)
% GRADE  Extracts the k-th grade component of a clifford multivector.
% The result may be empty (example: grade(e1, 2) = []). The second output
% parameter (a logical) indicates whether this is the case.

% Copyright © 2013, 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(2, 2), nargoutchk(0, 2)

global clifford_descriptor;

if ~isscalar(k) || ~isnumeric(k) || k < 0 || fix(k) ~= k
    error('Second parameter must be non-negative integer scalar.')
    % TODO This restriction could be relaxed to permit a vector of integers
    % specifying multiple grades.
end

if k > clifford_descriptor.n
    error(['Second parameter (', num2str(k), ') is greater than the number', ...
           ' of grades (', num2str(clifford_descriptor.n), ') in a multivector,', ...
           ' given the currently selected algebra.'])
end

check_signature(m);

% Make an empty result and then copy across only the components of m that
% we need. If these are empty, they will be copied anyway. But before we do
% this, we must cast the empty arrays to the same type as m.

c = classm(m);
if strcmp(c, 'double')
    p = clifford_descriptor.empty; % Default class is fine.
else
    p = cast(clifford_descriptor.empty, c);
end

index = ~clifford_descriptor.grade_table(k + 1, :);

p.multivector(index) = m.multivector(index);

if nargout == 2
    % The second output parameter is needed so we need to determine whether
    % the elements just written to p are empty. The point of doing this
    % (and therefore of the second output parameter) is to avoid a
    % subsequent test for empty on the whole multivector, which is a much
    % more expensive operation.
    
    e = all(cellfun('isempty', p.multivector(index)));
end

end

% $Id: grade.m 285 2021-07-28 16:23:39Z sangwine $
