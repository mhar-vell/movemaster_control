function varargout = size(m, dim)
% SIZE   Size of matrix.
% (Clifford overloading of standard Matlab function.)

% Copyright © 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% We need to find the size of any non-empty part of the multivector. If
% there is no non-empty part, we need to return the appropriate values for
% the empty parts.

switch nargout
    case 0
        switch nargin
            case 1
                size(m.multivector{find_non_empty})
            case 2
                size(m.multivector{find_non_empty}, dim)
            otherwise
                error('Incorrect number of input arguments.')
        end
    case 1
        switch nargin
            case 1
                varargout{1} = size(m.multivector{find_non_empty});
            case 2
                varargout{1} = size(m.multivector{find_non_empty}, dim);
            otherwise
                error('Incorrect number of input arguments.')
        end
    case 2
        switch nargin
            case 1
                [varargout{1}, varargout{2}] = size(m.multivector{find_non_empty});
            case 2
                error('Unknown command option.'); % Note 1.
            otherwise
                error('Incorrect number of input arguments.')
        end
    otherwise
        switch nargin
            case 1
                d = size(m.multivector{find_non_empty});         
                for k = 1:length(d)
                    varargout{k} = d(k); %#ok<AGROW>
                end
            case 2
                error('Unknown command option.'); % Note 1.                
            otherwise
                error('Incorrect number of input arguments.')
        end
end

    function k = find_non_empty
        % Find the first non-empty element of m and return its index.
        
        global clifford_descriptor
        
        % The search is broken into 1024 element chunks of the multivector.
        % For algebras up to n = 10, this means the entire multivector is
        % searched in one cellfun operation. For larger algebras the chunks
        % mean that the search terminates if a non-empty element is found,
        % but proceeds through all of the multivector only when the entire
        % multivector is empty.
        
        for j = 1:1024:clifford_descriptor.m
            nempty = ~cellfun('isempty', ...
                    m.multivector(j:min(j + 1023, clifford_descriptor.m)));
            if any(nempty)
               k = find(nempty, 1) + j - 1;
               return
            end
        end
        
        k = 1; % The index of the first element will do if all are empty
               % (size will then return the size of the empty element).
    end
end

% Note 1. Size does not support the calling profile [r, c] = size(q, dim),
% or [d1, d2, d3, .... dn] = size(q, dim). The error raised is the same as
% that raised by the built-in Matlab function.

% $Id: size.m 277 2021-07-17 21:14:23Z sangwine $
