function  m = mat_to_cl03(M)

% Copyright © 2017 Harry I. Elman (code contributed to the toolbox with
% edits by Steve Sangwine). This code is licensed under the same terms as
% the toolbox itself, for which see the file : Copyright.m for further
% details.

N = deinterleave(M, 8);

[m, n] = size(M);

a =  N(1:m/8,               1:n/8);
h =  N(1:m/8,     (n / 8) + 1:n / 4);
b =  N(1:m/8,     (n / 4) + 1:3 * n / 8);
g = -N(1:m/8, (3 * n / 8) + 1:n / 2);
c =  N(1:m/8,     (n / 2) + 1:5 * n / 8);
f =  N(1:m/8, (5 * n / 8) + 1:3 * n / 4);
e =  N(1:m/8, (3 * n / 4) + 1:7 * n / 8);
d = -N(1:m/8, (7 * n / 8) + 1:n);

clifford_signature(0, 3);

m = clifford(a, b, c, d, e, f, g, h);
%m = a * e0 + b * e1 + c * e2 + d * e3 + e * e12 + f  * e13 + g * e23 + h * e123;
end

% $Id: mat_to_cl03.m 271 2021-07-11 19:54:47Z sangwine $