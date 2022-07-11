function m = mat_to_cl00(M)

% Copyright © 2017 Harry I. Elman (code contributed to the toolbox with
% edits by Steve Sangwine). This code is licensed under the same terms as
% the toolbox itself, for which see the file : Copyright.m for further
% details.

clifford_signature(0,0);

m = clifford(M);

end

% $Id: mat_to_cl00.m 271 2021-07-11 19:54:47Z sangwine $