function L = clifford_literal(K, n)
% CLIFFORD_LITERAL Construct a basis literal from an index K. Example 'e1',
% 'e23'. n is the number of bits in the binary representation of K. The
% subscripts are present in the literal string if the correspondingly
% numbered bit in the natural binary representation of K is set, where the
% least significant bit is numbered 1 and the most significant bit is
% numbered n.

% Copyright © 2011 Stephen J. Sangwine and Eckhard Hitzer.

% Check the sanity of the parameters.

narginchk(2, 2), nargoutchk(0, 1)

assert(isnumeric(K) && isnumeric(n), 'Parameters must be numeric.');
assert( isscalar(K) &&  isscalar(n), 'Parameters must be scalar.');
assert(      K >= 0 && n >= 0,       'Parameters must be non-negative.');
assert( fix(K) == K && fix(n) == n,  'Parameters must be an integer.');

assert(K < 2.^uint32(n), ...
                 'First parameter has non-zero bits beyond n-th bit');
assert(n <= 16,  'Second parameter, n, must be 16 or less.');

% TODO Consider whether we should use uppercase for the letters A to G.
% These letters are used in the filenames of the parameterless functions,
% and lowercase results in names like ea.m, ed.m, rather than eA.m and
% eD.m.
d = '123456789abcdefg'; % These are the subscript digits, up to 16.

if K == 0
    L = 'e0'; % The scalar.
else
    L = ['e', d(logical(bitget(K, 1:n)))];
end

end

% $Id: clifford_literal.m 270 2021-07-11 19:42:06Z sangwine $
