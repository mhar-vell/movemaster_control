function b = subsref(a, ss)
% SUBSREF Subscripted reference.
% (Clifford overloading of standard Matlab function.)

% This function was copied from the Quaternion Toolbox for Matlab (QTFM)
% with modifications to work with matrices of Clifford multivectors.

% Copyright © 2005, 2010 Stephen J. Sangwine and Nicolas Le Bihan.
% Copyright © 2015       Stephen J. Sangwine and Eckhard Hitzer.
% See the file : Copyright.m for further details.

global clifford_descriptor;

if length(ss) ~= 1
    error('Only one level of subscripting is currently supported for multivectors.');
end

check_signature(a);

switch ss.type
case '()'
    if length(ss) ~= 1
        error('Multiple levels of subscripting are not supported for multivectors.')
    end
    
    b = a; % Copy the input parameter to avoid calling the constructor.
   
    % To implement indexing, we operate separately on the components.
    
    z = zeros(size(a), classm(a)); % We need this only if some components
                                   % of a are empty, but we don't want to
                                   % construct it repeatedbly in the loop.

    for j = 1:clifford_descriptor.m
        t = get(a, j);
        if isempty(t)
            t = z; % We need to supply explicit zeros, for the subscripted
                   % reference to operate on, because we don't know what it
                   % will do.
        end
        b.multivector{j} = t(ss.subs{:}); % For some reason this cannot be
                                          % done with PUT. TODO Why?
    end
case '.'
    error('Structure indexing is not implemented for multivectors.')
case '{}'
    error('Cell array indexing is not valid for multivectors.')
otherwise
    error('subsref received an invalid subscripting type.')
end

b = suppress_zeros(b);

end

% $Id: subsref.m 271 2021-07-11 19:54:47Z sangwine $
