function  m = mat_to_cl20(M)

% Copyright © 2017 Harry I. Elman (code contributed to the toolbox with
% edits by Steve Sangwine). This code is licensed under the same terms as
% the toolbox itself, for which see the file : Copyright.m for further
% details.

N = deinterleave(M, 2);

[m, n] = size(M);

leftTop     = N(      1:m/2,     1:n/2);
rightTop    = N(      1:m/2, n/2+1:n);
leftBottom  = N(m/2 + 1:m,       1:n/2);
rightBottom = N(m/2 + 1:m,   n/2+1:n);

a = (leftTop + rightBottom) / 2;
b = (leftBottom + rightTop) / 2;
c = (leftTop - rightBottom) / 2;
d = (leftBottom - rightTop) / 2;

clifford_signature(2, 0);

m = clifford(a, b, c, d); %a * e0 + b * e1 + c * e2 + d * e12;
end

% $Id: mat_to_cl20.m 271 2021-07-11 19:54:47Z sangwine $