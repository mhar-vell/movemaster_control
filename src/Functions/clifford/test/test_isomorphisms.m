function test_isomorphisms
% Test code for the clifford isomorphism functions including private
% functions that implement each isomorphism.

% Copyright (c) 2017, 2019 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

tdisp('Testing isomorphisms ...');

T = 1e-12;

s = clifford_signature;
p = s(1);
q = s(2);
r = s(3);
           
if p == 0 && q == 0 && r == 0
    tdisp('Isomorphisms not tested in Cl(0,0).')
    return
end

if r > 0
    tdisp('Not testing isomorphisms in this algebra.')
    return
end

% Test the multiplication of basis elements. This should be exact, as we
% are dealing with zeros and +1/-1.

% This code runs very slowly and requires some rethink before committing.

% B = clifford_basis;
% K = cell(size(B));  % Precompute the matrix representations of the basis.
% for j = 1:length(B)
%     K{j} = iso(B(j));
% end
% 
% for j = 1:length(B)
%     for k = j:length(B)
%         if any(any(iso(B(j) .* B(k)) - K{j} * K{k}))
%            terror(['Multiplication of basis elements fails at index ', ...
%                    num2str(j), ' times ', num2str(k)]) 
%         end
%     end
% end

% Test the isomorphisms from a given algebra Cl(p,q) to a matrix of real
% values.

A = randm; B = randm;

a = iso(A); b = iso(B); c = iso(A * B);

residual = max(max(abs(a * b - c)));
if residual > T
    terror(['Isomorphism to Cl(0,0) fails for Cl(', ...
        num2str(p), ',' num2str(q), ') with residual ', ...
        num2str(residual)])
end

% Now test that we can map the matrix of reals back to the algebra
% we started with.

clifford_signature(0,0);

E = iso(a .* e0, p, q); % Back to p, q. E should match A.

residual = max(max(abs(A - E)));
if residual > T
    twarning(['Isomorphism fails for Cl(0,0) back to Cl(', ...
        num2str(p), ',' num2str(q), ') with residual ', ...
        num2str(residual)])
end

% Now test that we can map matrices of multivectors from Cl(p,q).

M = [A, B; B, A];
N = iso(M);
n = [a, b; b, a];
residual = max(max(abs(N - n)));
if residual > T
    twarning(['Block isomorphism to Cl(0,0) fails for Cl(', ...
        num2str(p), ',' num2str(q), ') with residual ', ...
        num2str(residual)])
end

clifford_signature(0,0);
O = iso(n .* e0, p, q); % Map back to Cl(p,q)
residual = max(max(abs(M - O)));
if residual > T
    twarning(['Block isomorphism fails for Cl(0,0) back to Cl(', ...
        num2str(p), ',' num2str(q), ') with residual ', ...
        num2str(residual)])
end

% Test that the isomorphic block matrix squares to match the
% isomorphic matrix of the square of the Clifford matrix.

residual = max(max(abs(iso(M^2) - n^2)));
if residual > T
    twarning(['Block isomorphism fails for matrix product', ...
        ' with residual ', num2str(residual)])
end

tdisp('Passed');

end

% $Id: test_isomorphisms.m 242 2020-05-26 20:52:01Z sangwine $
