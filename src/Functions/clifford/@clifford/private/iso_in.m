function [M, path] = iso_in(m, path)

% Copyright © 2017 Harry I. Elman (code contributed to the toolbox with
% edits by Steve Sangwine). This code is licensed under the same terms as
% the toolbox itself, for which see the file : Copyright.m for further
% details.

% The path parameter accumulates a sequence of function call names, but
% these are the inverse operations to those used in mapping to Cl(0,0).
% Thus if this code calls isom1m1, which reduces p and q by one each, the
% path records that isop1p1 is needed to reverse the process, by adding one
% to each of p and q.

global clifford_descriptor
p = double(clifford_descriptor.signature(1));
q = double(clifford_descriptor.signature(2));
M = m;
while (p ~= 0) && (q ~= 0)
    M = isom1m1(M);
    path{end + 1} = 'isop1p1(m)'; %#ok<AGROW>
    p = double(clifford_descriptor.signature(1));
    q = double(clifford_descriptor.signature(2));
end
if (abs(p - q) <= 3)
    M = eval(strcat('cl', num2str(p), num2str(q), '_to_mat(M)'));
    path{end + 1} = strcat('mat_to_cl', num2str(p), num2str(q), '(m)');
else
    if (abs(p - q) == 4)
        if ((q > p) && (p == 0))
            M = isop4m4(M);
            path{end + 1} = 'isom4p4(m)';
        end
        M = isop1m1s(M);
        path{end + 1} = 'isop1m1s(m)';
    else
        if (p > q)
            M = isom4p4(M);
            path{end + 1} = 'isop4m4(m)';
        else
            M = isop4m4(M);
            path{end + 1} = 'isom4p4(m)';
        end
    end
    p = clifford_descriptor.signature(1); % Redundant surely? If the signature
    q = clifford_descriptor.signature(2); % is p, q, setting it to p,q is null.
    clifford_signature(p, q)
    [M, path] = iso_in(M, path);
end
end

% $Id: iso_in.m 271 2021-07-11 19:54:47Z sangwine $