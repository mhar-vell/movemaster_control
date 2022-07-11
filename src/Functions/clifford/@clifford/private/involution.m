function r = involution(m, g)
% Private function to negate the grades of the multivector indicated by g,
% which may be a scalar or an array, e.g. [1, 4] to negate grades 1 and 4.
% The name of this function is perhaps incorrect, since it may be used to
% implement a mapping which is not strictly an involution or
% anti-involution. However, it does provide efficient common code for
% implementing the negation of particular grades required to implement
% several Clifford involutions. For a discussion on involutions and
% anti-involutions see:
%
% Todd A. Ell and Stephen J. Sangwine,
% ‘Quaternion involutions and anti-involutions’,
% Computers and Mathematics with Applications, 53 (2007), 137–143.
% DOI: 10.1016/j.camwa.2006.10.029

% Copyright © 2021 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor

r = m; % Copy the multivector argument to the result.

% Construct a logical row vector N indicating the elements of r which must
% be negated, by extracting rows of the grade table selected by g, followed
% by a logical OR applied down the columns.

N = any(~clifford_descriptor.grade_table(g + 1, :), 1);
    
% Negate the elements of the multivector selected by N.

r.multivector(N) = cellfun(@uminus, m.multivector(N), 'UniformOutput', false);

end

% $Id: involution.m 295 2021-08-09 16:51:26Z sangwine $
