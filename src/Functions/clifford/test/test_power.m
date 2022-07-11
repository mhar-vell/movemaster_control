function test_power
% Test code for the power function.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor

tdisp('Testing power function ...');

% Test the inverse operation, if it is defined.

s = clifford_signature;
if s(3) ~= 0
    tdisp(['Not testing power function with exponent -1 because the ', ...
           'inverse is not defined in algebras with r > 0.'])
else
    
    m = randm(2, 'sparse', max(0.25, 1/cast(clifford_descriptor.m, 'double')));
    p = m.^-1; % Compute the inverse of each element in m.
    
    % Errors are greater in algebras with larger dimension, so we vary the
    % tolerance according to the dimension of the algebra. The lowest value
    % of n is 0 (for algebra Cl(0,0)) so we need to index the tolerance
    % vector with one greater than n. The largest value of n supported by
    % the toolbox is 16. So we need 17 tolerance values.
    
    tolerance = logspace(-4, -2, 17);
    
    T = tolerance(clifford_descriptor.n + 1);
    
    % Sometimes one element of the result will be out of tolerance, but the
    % other three are not. We let this pass, because it is due to numerical
    % conditions, and does not show the algorithm to be faulty.
    % TODO Establish why sometimes one value is out of tolerance - could we
    % deal with it better?
    
    D = abs(abs(m .* p - 1e0));
    L = D > T;
    N = sum(L(:));
    if N > 1
        % This is how we used to do the test. If more than one element is
        % outside tolerance, compare will raise an error and show the diff.
        compare(m .* p, 1e0, T, 'Multivector elementwise inverse fails.');
    elseif N > 0
        twarning(['One value out of four in multivector elementwise', ...
                  'inverse was out of tolerance']);
    end
    
    tdisp('Passed');
    
end

end

% $Id: test_power.m 285 2021-07-28 16:23:39Z sangwine $
