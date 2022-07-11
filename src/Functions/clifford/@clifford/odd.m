function p = odd(m)
% ODD  Extracts the sum of the odd grades of a clifford multivector.

% Copyright © 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

global clifford_descriptor;

check_signature(m);

% TODO A better algorithm here would avoid the composition of grades using
% plus, and just copy the cells across corresponding to the odd grades. Or
% copy the entire multivector and then set the even grades to empty? A
% vectorised algorithm would construct a logical array representing the
% elements of odd grade then copy them into an empty multivector in a
% logical indexing copy.

if size(clifford_descriptor.grade_table, 1) > 1
    p = grade(m, 1); % We call this only if grade 1 exists.
else
    p = clifford.empty;
end

for k = 3:2:clifford_descriptor.n
    if isempty(p)
        p = grade(m, k); % The RHS here could also be empty, but since p is
                         % empty too, we don't need to worry/
    else
        g = grade(m, k); % Here we need to be careful, because p is not
        if ~isempty(g)   % empty, but g could be, and we must not add empty
            p = p + g;   % to non-empty.
        end
    end
end

end

% $Id: odd.m 289 2021-07-30 18:56:20Z sangwine $
