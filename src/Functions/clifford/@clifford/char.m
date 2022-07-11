
function str = char(m, tf)
% CHAR Create character array (string).
% (Clifford overloading of standard Matlab function.)

% The second parameter controls whether to output an explicit leading +
% sign. The default is false.

% Copyright © 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 2), nargoutchk(0, 1) 

global clifford_descriptor;

if nargin == 2
   if ~islogical(tf), error('Second parameter must be logical.'), end
else
    tf = false;
end

% There are two cases to be handled. The argument is either an empty or a
% non-empty multivector.

if isempty(m)
    str = '[] multivector'; % This case must be handled first
    return;                    % because an empty multivector is not
end                            % scalar, and the next check would fail.

if ~isscalar(m)
    error('char cannot handle a vector or a matrix.')
end

% TODO We should exercise more careful control over the formatting of the
% result, and/or provide an additional parameter to control it, so that the
% disp function can output a multivector with due regard to the magnitudes
% of the various components. E.g. what happens if one component is very
% small (1e-8 for example), but others are between 0 and 1?

f = '%6.4f'; % Control over the format of each numeric value.

str = ''; % Start with an empty string.

flag = false; % Indicates whether any value has been output.
for i = 1:clifford_descriptor.m
    t = m.multivector{i};
    if ~isempty(t)
        if isreal(t)
            % We are outputting a real value.
            S = plusminus(t);
            if ~flag
                % This is the first value output, and we must output a -
                % sign if the value is negative and a + sign if the tf flag
                % is set.
                if S == '+'
                    if ~tf
                        S = ' ';
                    end
                end
            end
            str = [str ' ' S ' ' num2str(abs(t), f)]; %#ok<*AGROW>
        else
            % We are outputting a complex value, surrounded by parentheses.
            % There is no overall sign in this case, the complex number has
            % signs on the real and imaginary parts, INSIDE the
            % parentheses.
            
            if flag
                % This is not the first value output, so we output a + sign
                % if needed.
                S = plusminus(t);
            else
                S = ' '; % Empty string => no sign.
            end
            rt = real(t);
            if sign(rt) == -1
                srt = '-';
            else
                srt = ' ';
            end
            it = imag(t);
            str = [str ' ' S ' (' srt num2str(abs(rt), f) ' ' ...
                       plusminus(it) ' ' num2str(abs(it), f) 'i)'];
        end
        
        % TODO The padding here is based on the longest index_strings
        % value. When outputting a multivector which does not have high
        % grade elements (e.g. a vector), the padding could be reduced.
        % So, can we devise a better padding algorithm that would adapt to
        % the content of the multivector?
        
        str = [str ' ' pad(clifford_descriptor.index_strings{i})];
        flag = true; % Record that we have output at least one value.
    end
end
end

function S = plusminus(X)
% Extracts the sign of X and returns the character '-', '+'.

if sign(X) == -1
    S = '-';
else
    S = '+';
end
end

function S = pad(X)
% Pads the string X to the length of the longest index string.

global clifford_descriptor;

L = length(clifford_descriptor.index_strings{end}) - 1;
S = [X blanks(L - length(X))];
end

% $Id: char.m 271 2021-07-11 19:54:47Z sangwine $
