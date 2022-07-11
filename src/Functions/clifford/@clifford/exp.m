function Y = exp(X)
% EXP Exponential of the elements of a multivector array.
% (Clifford overloading of standard Matlab function.)

% Copyright © 2017 Harry I. Elman
% (code contributed to the toolbox with edits by Steve Sangwine).
% This code is licensed under the same terms as the toolbox itself, for
% which see the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

% TODO Consider whether an explicit formula could be used in the two and
% three-dimensional cases. Beware - idempotents and nilpotents may need
% special treatment, which is not the case with the exponential series. The
% following reference gives formulae, which would need checking and testing
% against the code below:
%
% James M. Chappell, Azhar Iqbal, Lachlan J. Gunn, Derek Abbott
% Functions of Multivector Variables, PLOS One.
% doi:10.1371/journal.pone.0116943

% The method used here is a Taylor series, evaluated using Horner's rule.
% This works for any algebra.

% The exponential series coefficients are 1/factorial(k). This value is
% less than epsilon (for double precision) for k > 18. Therefore the value
% of the last coefficient compared to the first (which is unity) is less
% than epsilon. This provides a sound basis for the choice, but it requires
% that the multivector X have unit norm (since a large norm would result in
% large norms for higher powers of X). Therefore it remains to consider the
% cases where the norm of the multivector is large. TODO

N = 18;

T = e0 .* ones(size(X)); % This is for intermediate results.
Y = T;

for k = 1:N
    T = T .* (X / k);
    Y = Y + T;
end

end

% $Id: exp.m 270 2021-07-11 19:42:06Z sangwine $
