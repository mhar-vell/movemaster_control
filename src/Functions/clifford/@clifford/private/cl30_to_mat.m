function M = cl30_to_mat(m)

% Copyright © 2017 Harry I. Elman (code contributed to the toolbox with
% edits by Steve Sangwine). This code is licensed under the same terms as
% the toolbox itself, for which see the file : Copyright.m for further
% details.

a = part(m, 1);
b = part(m, 2);
c = part(m, 3);
d = part(m, 4);
e = part(m, 5);
f = part(m, 6);
g = part(m, 7);
h = part(m, 8);

clifford_signature(0,1);

A = clifford(a + c,   f - h);
B = clifford(b - e, -(d + g));
C = clifford(b + e,   d - g);
D = clifford(a - c, -(f + h));

C = [cl01_to_mat(A), cl01_to_mat(B); ...
     cl01_to_mat(C), cl01_to_mat(D)];

M = interleave(C, 2);
            
clifford_signature(3,0); % Restore the algebra we had on entry (assumed).

end

% $Id: cl30_to_mat.m 271 2021-07-11 19:54:47Z sangwine $