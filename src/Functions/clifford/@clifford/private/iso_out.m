function m = iso_out(M, path)

% Copyright © 2017 Harry I. Elman (code contributed to the toolbox with
% edits by Steve Sangwine). This code is licensed under the same terms as
% the toolbox itself, for which see the file : Copyright.m for further
% details.

path = fliplr(path); % TODO This could be changed to flip in the future, introduced with R2013b.
m = M;
for instruction_count = 1:numel(path)
    instruction = path{instruction_count};
    % disp(instruction)
    m = eval(instruction);
end

end

% $Id: iso_out.m 271 2021-07-11 19:54:47Z sangwine $