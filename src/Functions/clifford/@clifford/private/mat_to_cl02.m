function  m = mat_to_cl02(M)

% Copyright © 2017 Harry I. Elman (code contributed to the toolbox with
% edits by Steve Sangwine). This code is licensed under the same terms as
% the toolbox itself, for which see the file : Copyright.m for further
% details.

N = deinterleave(M, 4);

[m, n] = size(M);

a =   N(1:m/4,           1:n/4);
b = - N(1:m/4,     n/4 + 1:n/2);
c =   N(1:m/4,     n/2 + 1:3 * n/4);
d = - N(1:m/4, 3 * n/4 + 1:n);

clifford_signature(0, 2);

m = clifford(a, b, c, d);

end

% $Id: mat_to_cl02.m 271 2021-07-11 19:54:47Z sangwine $