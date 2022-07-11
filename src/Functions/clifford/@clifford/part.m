function p = part(m, n)
% PART  Extracts the n-th component of a clifford multivector, possibly zero.

% Copyright © 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(2, 2), nargoutchk(0, 1)

global clifford_descriptor;

if ~isnumeric(n)
    error('Second parameter must be numeric.')
end

if n < 1
    error('Second parameter must be positive.')
end

if ~isscalar(n)
    error('Second parameter must be a scalar.')
end

% TODO Check that n has an integer value. Although if it doesn't the
% indexing of the cell array below will raise an error.

if n > clifford_descriptor.m
    error(['Second parameter is greater than the number of parts in a ' ...
           'multivector, given the currently selected algebra.'])
end

p = get(m, n);
if ~isempty(p)
    return
end

% The component we have been asked to return is empty. Now we are forced to
% test the whole multivector in order to return empty if all components are
% empty, but a zero array of the correct size and class if not.

if ~isempty(m)
    p = zeros(size(m), classm(m));
else
    p = cast([], classm(m));
end

end

% $Id: part.m 271 2021-07-11 19:54:47Z sangwine $
