function B = clifford_basis
% CLIFFORD_BASIS Return a column vector containing the basis elements of
% the current algebra.

% Copyright © 2015 Stephen J. Sangwine and Eckhard Hitzer.

narginchk(0, 0), nargoutchk(0, 1)

global clifford_descriptor;

if isempty(clifford_descriptor)
    error('No Clifford algebra has been initialised.')
end

C = [1; zeros(clifford_descriptor.m - 1, 1)];

B = clifford.empty;

for j = 1:clifford_descriptor.m
    B = put(B, j, circshift(C, j - 1));
end

end

% $Id: clifford_basis.m 283 2021-07-22 21:09:48Z sangwine $
