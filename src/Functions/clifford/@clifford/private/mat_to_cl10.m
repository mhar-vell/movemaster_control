function m = mat_to_cl10(M)

% Copyright © 2017 Harry I. Elman (code contributed to the toolbox with
% edits by Steve Sangwine). This code is licensed under the same terms as
% the toolbox itself, for which see the file : Copyright.m for further
% details.

N = deinterleave(M, 2);

[m, n] = size(M);

a = N(      1:m/2, 1:n/2);
b = N(m/2 + 1:m,   1:n/2);

clifford_signature(1, 0);

m = clifford(a, b); %a * e0 + b * e1;
    
end


% $Id: mat_to_cl10.m 271 2021-07-11 19:54:47Z sangwine $