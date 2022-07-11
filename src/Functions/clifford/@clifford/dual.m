function r = dual(m)
% DUAL  Computes the dual of a multivector.

% Copyright © 2013, 2019, 2021 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

% This function can be computed as the left multiplication of the
% multivector m by the inverse of the pseudoscalar. (If the pseudoscalar
% squares to 0, that is it is nilpotent, there cannot be an inverse, and
% this function cannot compute a result.)

% The dual can be computed without multiplication however, since only two
% things happen: the elements of the multivector are reversed in order
% (assuming lexical order, which is how we store them), and some elements
% have a change of sign. Hence we can compute the dual without performing
% any multiplications, provided we can compute the necessary sign changes.

global clifford_descriptor;

% Find and copy across to the result the non-empty elements of the input
% argument, at this stage preserving the input ordering.

ne = ~cellfun('isempty', m.multivector);

r = clifford.empty;
r.multivector(ne) = m.multivector(ne);

% Now work out the signs from the index values of the non-empty elements of
% m, and the index of the pseudoscalar, and negate any elements for which
% the sign is negative.

index = 1:clifford_descriptor.m;

signs = zeros(size(index), 'int8');

signs(ne) = clifford_sign(index(end), index(ne)); % These are the signs due
                                                  % to the product of the
                                                  % pseudoscalar (on the
                                                  % left) with the
                                                  % non-empty elememts of
                                                  % m (on the right).

% If the square of the pseudoscalar is negative, we need to invert the
% signs. This is because the inverse of the pseudoscalar is itself cubed.
% Instead of inverting the signs we just detect the opposite case when
% computing the indices that require negation.

switch clifford_sign(index(end), index(end))
    case +1
        negate = index(ne & signs == -1);
    case -1
        negate = index(ne & signs == +1);
    case 0
        error('Dual cannot be computed, pseudoscalar squares to zero.');
    otherwise
        error('Pseudoscalar squared is not in {-1, 0, +1}');
end

% Negate (only) the elements that require negation.

r.multivector(negate) = cellfun(@uminus, r.multivector(negate), ...
    'UniformOutput', false);

% Flip the ordering, including the empty elements.

r.multivector = flip(r.multivector);

end

% $Id: dual.m 294 2021-08-06 19:10:06Z sangwine $
