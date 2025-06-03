function M = cl10_to_mat(m)

% Copyright © 2017 Harry I. Elman (code contributed to the toolbox with
% edits by Steve Sangwine). This code is licensed under the same terms as
% the toolbox itself, for which see the file : Copyright.m for further
% details.

a = part(m, 1);
b = part(m, 2);
M = interleave([a, b; ...
                b, a], 2);
end

% $Id: cl10_to_mat.m 271 2021-07-11 19:54:47Z sangwine $