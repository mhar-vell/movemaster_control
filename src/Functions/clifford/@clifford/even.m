function p = even(m)
% EVEN  Extracts the sum of the even grades of a clifford multivector.

% Copyright © 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

global clifford_descriptor;

check_signature(m);

% TODO See note in odd.m about a better algorithm.

p = grade(m, 0); % This could be empty.

for k = 2:2:clifford_descriptor.n
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

% $Id: even.m 271 2021-07-11 19:54:47Z sangwine $
