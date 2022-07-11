function r = hodge(m)
% HODGE DUAL  Computes the Hodge dual of a multivector. Special code for
% the algebra Cl(0,3,1) only. See the function dual.m in the Clifford
% Toolbox for Matlab for the code that handles cases where the pseudoscalar
% squares to plus or minus 1 (in the case we handle here it squares to 0).
% WARNING - this code is experimental.

% Copyright © 2021 Stephen J. Sangwine

% Reference: J. M. Selig, 'Clifford algebra of points, lines and planes',
% Robotica, v.18, pp.545-556, Cambridge University Press, 2000. [Section
% 2.2.] DOI:10.1017/S0263574799002568

global clifford_descriptor;

if any(clifford_descriptor.signature ~= [0, 3, 1])
    error('Signature of current algebra differs from (0,3,1).')
end

narginchk(1, 1), nargoutchk(0, 1)

check_signature(m)

% Define the indices of elements of the multivector which require negation
% (before flipping) and create a logical array that selects those indices.
% This list is based on the table given in Selig section 2.2 which shows
% that we need to negate basis elements e2, e4, e13, e24, e124, e234.

index = [3 5 7 10 13 15];

negate = false(1, 16);
negate(index) = true;

% Find and copy across to the result the non-empty elements of the input
% argument, at this stage preserving the input ordering.

ne = ~cellfun('isempty', m.multivector);

r = clifford.empty;
r.multivector(ne) = m.multivector(ne);

% AND together the indices which require negation, and the indices that are
% non-empty (no point negating empty elements).

negate = negate & ne;

% Negate (only) the elements that require negation.

r.multivector(negate) = cellfun(@uminus, r.multivector(negate), ...
    'UniformOutput', false);

% Flip the ordering, including the empty elements.

r.multivector = flip(r.multivector);

end

% $Id$
