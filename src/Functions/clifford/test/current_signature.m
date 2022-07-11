function cs = current_signature
% Construct string representing the signature of the current algebra.

% Copyright (c) 2017  Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

s = clifford_signature;

if isempty(s)
    error('No algebra initialised.')
end

if s(3) == 0
    cs = ['Cl(', num2str(s(1)), ',' num2str(s(2)), ')'];
else
    cs = ['Cl(', num2str(s(1)), ',' num2str(s(2)), ',' num2str(s(3)), ')'];
end

end

% $Id: current_signature.m 201 2019-04-24 17:21:15Z sangwine $
