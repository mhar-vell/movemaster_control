function M = cl02_to_mat(m)

% Copyright © 2017 Harry I. Elman (code contributed to the toolbox with
% edits by Steve Sangwine). This code is licensed under the same terms as
% the toolbox itself, for which see the file : Copyright.m for further
% details.


a = part(m, 1);
b = part(m, 2);
c = part(m, 3);
d = part(m, 4);
M = interleave([a, -b,  c, -d; ...
                b,  a,  d,  c; ...
               -c, -d,  a,  b; ...
                d, -c, -b,  a], 4);
end

% $Id: cl02_to_mat.m 271 2021-07-11 19:54:47Z sangwine $