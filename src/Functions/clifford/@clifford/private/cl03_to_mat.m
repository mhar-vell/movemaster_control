function M = cl03_to_mat(n)

% Copyright © 2017 Harry I. Elman (code contributed to the toolbox with
% edits by Steve Sangwine). This code is licensed under the same terms as
% the toolbox itself, for which see the file : Copyright.m for further
% details.


%explain why - signs in parts
ae =  part(n, 1);
be =  part(n, 2);
ce =  part(n, 3);
df = -part(n, 4);
de =  part(n, 5);
cf =  part(n, 6);
bf = -part(n, 7);
af =  part(n, 8);

M = interleave([ae, af, be, bf, ce, cf, de, df; ...
                af, ae, bf, be, cf, ce, df, de; ...
               -be, -bf, ae, af, -de, -df, ce, cf; ...
               -bf, -be, af, ae, -df, -de, cf, ce; ...
               -ce, -cf, de, df, ae, af, -be, -bf; ...
               -cf, -ce, df, de, af, ae, -bf, -be; ...
               -de, -df, -ce, -cf, be, bf, ae, af; ...
               -df, -de, -cf, -ce, bf, be, af, ae], 8);
end

% $Id: cl03_to_mat.m 271 2021-07-11 19:54:47Z sangwine $