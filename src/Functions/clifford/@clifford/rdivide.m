function r = rdivide(a, b)
% ./  Right array divide.
% (Clifford overloading of standard Matlab function.)

% This function was adapted from the Quaternion Toolbox for Matlab (QTFM)
% with minor modifications to work with matrices of Clifford multivectors.

% Copyright © 2015 Stephen J. Sangwine and Eckhard Hitzer.
% See the file : Copyright.m for further details.

narginchk(2, 2), nargoutchk(0, 1)

global clifford_descriptor;

% There are three cases to be handled:
%
% 1. Left and right arguments are multivectors.
% 2. The left argument is a multivector, the right is not.
% 3. The right argument is a multivector, the left is not.
%
% In fact, cases 1 and 3 can be handled by the same code. Case 2
% requires different handling.

if isa(b, 'clifford')
    
    % The right argument is a multivector. We can handle this case by
    % forming its elementwise inverse and then multiplying. Of course,
    % if any elements have zero norm, this will result in NaNs.
     
    r = a .* b .^ -1;
    
elseif isnumeric(b)
    
    % The right argument is not a multivector, but it is numeric. We assume
    % therefore that if we divide components of the left argument by the
    % right argument, that Matlab will do the rest. However, we need to
    % avoid dividing empty elements of a by b, otherwise we will create
    % explicit zeros.
        
    nea = ~cellfun('isempty', a.multivector); % Find the non-empty elements.
    
    r = a;
    
    index = 1:clifford_descriptor.m;
    
    for j = index(nea)
        r.multivector{j} = r.multivector{j} ./ b;
    end
    
else
    error(['Right argument of unexpected type, ', ...
           'multivector or numeric is acceptable, found: ', class(b)])
end

% $Id: rdivide.m 271 2021-07-11 19:54:47Z sangwine $
