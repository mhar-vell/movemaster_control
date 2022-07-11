function r = suppress_zeros(m)
% Private function to suppress zero components of a multivector by
% replacing them with empty. Only components which are exactly zero are
% suppressed (all elements of the component must be exact zeros).

% Copyright © 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor

r = m; % Copy the input multivector.

% Establish which elements of r are empty. Loops and cellfun have been
% tried here at various times. See times.m for an undocumented speedup in
% Matlab using string notation for the function to be applied over the
% cell array.

er = cellfun('isempty', r.multivector);

if all(er)
    return % The multivector m was empty, no suppression to do.
end

index = 1:clifford_descriptor.m;

c = classm(m);             
e = cast([], c); % Make an empty of the correct class once, for use below.

for j = index(~er)
    % Test the numeric elements of the j-th numeric component of the
    % multivector for zero. If any are non-zero, then move on, we do not
    % need to suppress the j-th element.
    
    if any(r.multivector{j}, 'all') % Requires Matlab R2018b (9.5).
        continue
    end
    r.multivector{j} = e; % All elements must be zero: replace with empty.
end

% Some elements, indicated by er, were empty on entry. We now need to check
% the others to see if all of them are now empty. If so, we should set the
% e0 coefficient to be an array of zeros of the same size as m on entry.
% Notice that if all elements are now empty, this cannot be because m was
% empty on entry: we excluded that above and returned an empty multivector
% in that case.

if all(cellfun('isempty', r.multivector(~er)))
    r.multivector{1} = zeros(size(m), c);
end

end

% $Id: suppress_zeros.m 283 2021-07-22 21:09:48Z sangwine $
