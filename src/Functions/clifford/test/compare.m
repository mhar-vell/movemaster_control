function compare(A, B, T, E)
% Test function to check that two multivector arrays (real or complex)
% are equal, to within a tolerance, and if not, to output an error
% message from the string in the parameter E.

% Copyright (c) 2015, 2021 Stephen J. Sangwine and Eckhard Hizer
% See the file : Copyright.m for further details.

narginchk(4, 4), nargoutchk(0, 0)

if any(any( abs(abs(A - B)) > T ))
    Diff = max(max(abs(abs(A - B))));
    terror([E, ' Tolerance error: ', num2str(Diff)]);
end

% $Id: compare.m 259 2021-06-16 12:26:07Z sangwine $
