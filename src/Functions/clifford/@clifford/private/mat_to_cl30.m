function  m = mat_to_cl30(M)

% Copyright © 2017 Harry I. Elman (code contributed to the toolbox with
% edits by Steve Sangwine). This code is licensed under the same terms as
% the toolbox itself, for which see the file : Copyright.m for further
% details.

N = deinterleave(M, 2);

[r, c] = size(N); assert(all(rem([r, c], 2) == 0));

% Split the array into quarters.

L = N(:,1:c/2); R = N(:,c/2+1:end); clear N

A = L(1:r/2,:); C = L(r/2+1:end,:); clear L
B = R(1:r/2,:); D = R(r/2+1:end,:); clear R

% Now apply the matrix to Cl(0,1) isomorphism to the quarters.

CA = mat_to_cl01(A); clear A
CB = mat_to_cl01(B); clear B
CC = mat_to_cl01(C); clear C
CD = mat_to_cl01(D); clear D

RCA = part(CA, 1); ICA = part(CA, 2); % Extract the scalar and imaginary.
RCB = part(CB, 1); ICB = part(CB, 2);
RCC = part(CC, 1); ICC = part(CC, 2);
RCD = part(CD, 1); ICD = part(CD, 2);

a =  (RCA + RCD) ./ 2;
b =  (RCB + RCC) ./ 2;
c =  (RCA - RCD) ./ 2;
d = -(ICB - ICC) ./ 2;
e = -(RCB - RCC) ./ 2;
f =  (ICA - ICD) ./ 2;
g = -(ICB + ICC) ./ 2;
h = -(ICA + ICD) ./ 2;

clifford_signature(3, 0);

m = clifford(a, b, c, d, e, f, g, h);

end

% $Id: mat_to_cl30.m 271 2021-07-11 19:54:47Z sangwine $