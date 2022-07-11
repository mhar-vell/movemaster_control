% Clifford Algebra Toolbox for MATLAB
%
% Clifford multivector class definition and constructor method/function.

% Copyright © 2013, 2017 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

classdef clifford
    properties (Access = 'private', Hidden = true)
        % The multivector data is stored in a cell array. The elements of
        % the cell array are the arrays of component data for each element
        % of the multivector. The ordering is lexical, for example:
        %
        % e0 e1 e2 e3 e12 e13 e23 e123
        
        multivector = {}; % Default this to an empty cell array.        
        signature; % [p, q, r], the signature of the algebra of the multivector.
    end
    methods
        
        function s = get_signature(m)
        % GET_SIGNATURE returns the signature of a multivector.
            s = m.signature;
        end
        
        function C = coefficients(m)
        % COEFFICIENTS returns the numeric coefficients of a multivector as
        % a cell array.
            C = m.multivector;
        end

        function dump(m)
        % DUMP outputs a human readable dump of the contents of the
        % multivector (for debugging purposes). The output is elided where
        % successive lines would have the same content. Some key parameters
        % are output first. If the multivector has size 1-by-1, some
        % numerical stats are also output.
        
        disp(['Signature: ', num2str(m.signature)])
        disp(['Size:      ', num2str(size(m))])
        disp(['Class:     ', classm(m)])
        disp(['Empty:     ', num2str(sum(cellfun('isempty', m.multivector)))])
        disp(['Non-empty: ', num2str(sum(~cellfun('isempty', m.multivector)))])
        disp(' ')
        if all(size(m) == 1)
            disp(['Max coefficient: ' num2str(max(cell2mat(m.multivector)))])
            disp(['Min coefficient: ' num2str(min(cell2mat(m.multivector)))])
            disp(['Min absolute:    ' num2str(min(abs(cell2mat(m.multivector))))])
            disp(' ')
        end
        disp('Multivector components:')
        % TODO A more compact output is possible here. Instead of eliding
        % lines, we could output the range of index values for which
        % successive components have the same size, followed by one
        % statement of the size. For example, existing output on the left,
        % more compact output on the right:
        %
        % 1: [0  0]  double                 1:      [0  0]  double
        % 2: [1  1]  double                 2:      [1  1]  double
        % 3: [0  0]  double                 3:8     [0  0]  double
        % ...                               9:      [1  1]  double
        % 8: [0  0]  double                 10:128: [0  0]  double
        % 9: [1  1]  double
        % 10: [0  0]  double
        % ...
        % 128: [0  0]  double
        %
        P = ''; % Empty string for previous line output.
        E = false; % This is set true when a line of output is elided.
        for j = 1:length(m.multivector) % NB Not clifford_descriptor.m in
                                        % case we are currently in a
                                        % different signature.
            S = ['[', num2str(size(m.multivector{j})), ']  ', ...
                             class(m.multivector{j})];
            if strcmp(P, S)
                E = true; % Flag that we are not outputting a line for this
                          % value of j.
            else
                if E
                    % The previous line must have been elided, but the line
                    % for j will not be, so output an ellipsis to indicate
                    % the elided lines, then the output for line j.
                    disp('...')
                    disp([num2str(j - 1), ': ', P])
                    E = false;
                end
                disp([num2str(j), ': ', S])
                P = S;
            end
        end
        if E
            % The last entry in the loop must have been elided, so we need
            % to output the last line, for the maximum value of j.
            disp('...')
            disp([num2str(j), ': ', P])
        end
        end
        
        function check_signature(m)
        % CHECK_SIGNATURE Checks that the signature of an object m matches
        % with the current signature and raises an error if they do not
        % match. This should be called from any class method that has
        % multivectors as input parameters, and it should be called on each
        % such parameter to guard against attempts to combine multivectors
        % with differing signatures.
        
        global clifford_descriptor;
        
        if isempty(clifford_descriptor)
            error('No Clifford algebra has been initialised.')
        end

        if any(m.signature ~= clifford_descriptor.signature)
            error(['Clifford multivector has a signature different to '...
                   'that of the current Clifford algebra.'])
        end
        end
        
        function object = clifford(varargin)
        % CLIFFORD   Construct multivectors from components. Accepts the 
        % following possible arguments, which may be scalars, vectors or
        % matrices:
        %
        % No argument     - returns an empty multivector.
        % One argument    - A multivector argument returns the argument
        %                   unmodified. A non-multivector argument returns
        %                   the argument in the e0 part.
        % 2+ arguments    - returns a multivector, provided the number of
        %                   arguments equals the number of components of a
        %                   multivector in the current Clifford algebra.
        %
        % One string      - the string must be of the form 'e1', 'e123' or
        %                   a permutation thereof, e.g. 'e231'. The result
        %                   will be a multivector representing a basis
        %                   element of the current algebra if the string is
        %                   valid.

        global clifford_descriptor; % This is a structure containing fields
                                    % initialised by the function
                                    % clifford_signature, which must be
                                    % called before this constructor.
        
        if isempty(clifford_descriptor)
            error(['The Clifford algebra you wish to use must first be '...
                   'initialised by calling clifford_signature(p, q)'])
        end
        
        nargoutchk(0, 1) % The number of input arguments is checked below.
                         
        L = length(varargin);
        
        if L > clifford_descriptor.m
            error('Too many input arguments for the algebra')
        end
        
        if L == 0
            % Although the descriptor contains an empty multivector, we
            % cannot use it here, because this is where the empty
            % multivector in the descriptor gets created.
            object.multivector = cell(1, clifford_descriptor.m);
            object.signature = clifford_descriptor.signature;
            return
        end
        
        if L == 1
            V = varargin{1};
            if ischar(V)
                % The parameter is a string. See whether it represents a
                % valid basis element or a permutation of one, and if so
                % return a suitable multivector.
                
                TF = strcmp(V, clifford_descriptor.index_strings);
                
                if any(TF)
                    % One element of TF is true (it can only be one since V
                    % cannot match more than one string in index_strings),
                    % so we have a valid multivector element.
                    
                    object = clifford_descriptor.empty;
                    object.multivector{TF} = 1; % Set one element to unity.
                    
                    return
                end
                
                % Now sort the string into lexical order to find out
                % whether it is a valid permutation of an index_string. The
                % first character must be 'e', so we don't sort this, and
                % if it isn't 'e' we will detect that later.
                
                W = V;
                [W(2:end), I] = sort(V(2:end));

                TF = strcmp(W, clifford_descriptor.index_strings);
                
                if ~any(TF)
                    error([V ...
                           ' does not exist in current Clifford algebra.'])
                end
                
                % The sorted string in W is a valid multivector element, so
                % compute the number of swaps needed to sort the original
                % permuted string V into W and use this to determine the
                % sign.
                
                P = eye(length(W) - 1); % Make an identity matrix, then ...
                P(1:end, I) = P;        % re-arrange the columns into the
                                        % order in I.
                
                object = clifford_descriptor.empty;
                
                % TODO Permit the class of the multivector elements to be
                % specified. This will require a second parameter for the
                % class, which will need checking. And there could be a
                % conflict with something like clifford(2,3) in an algebra
                % with only two elements.
                object.multivector{TF} = sign(det(P)); 
                
                return
            elseif isa(V, 'clifford')
                % The input argument is already a clifford multivector.
                check_signature(V);
                object = V;
                return
            else
                if isnumeric(V)
                    % We can store V in the scalar part, and leave the rest
                    % empty, subject to altering the class to match V.
                    
                    object = cast(clifford_descriptor.empty, class(V));
                    object.multivector{1} = V;
                    return
                else
                    error('A Clifford multivector cannot contain non-numeric components.')
                end
            end
        end
        
        if L == clifford_descriptor.m
            % The parameters supplied must be numeric, or empty.
            
            % TODO Tricky problem here. We want to combine empty with
            % numeric elements, but the first component could be empty. We
            % need to check the size of any non-empty elements against the
            % first non-empty not the first element.
            
            object = clifford_descriptor.empty;
            V = varargin{1};
            if ~isnumeric(V)
                error('Multivector elements must be numeric.')
            end
            C = class(V); S = size(V);
            object.multivector{1} = V;
            for i = 2:L
                V = varargin{i};
                if ~isnumeric(V)
                    error('Multivector elements must be numeric.')
                end
                if ~strcmp(C, class(V))
                    error('Cannot mix elements of different classes in one multivector.')
                end
                T = size(V);
                if length(S) ~= length(T)
                   error('Cannot mix elements with different numbers of dimensions in one multivector.') 
                end
                if any(S ~= T)
                    error('Cannot mix elements with different sizes in one multivector.')
                end
                object.multivector{i} = V;
            end
        else
            error('The number of arguments must equal the number of components in the current Clifford algebra.')
        end
        end

        function n = numArgumentsFromSubscript(~,~,~)
            % Introduction of this function with Matlab R2015b
            % permitted numel to revert to its obvious function
            % of providing the number of elements in an array.
            n = 1;
        end
        
        function r = put(m, j, v)
            % An internal function to insert a value into a multivector at
            % a given index position. It does in reverse what the part and
            % private/component functions do (extract a value from a
            % multivector at a given index). m must be a multivector in the
            % current algebra, j must be an integer from
            % 1:clifford_descriptor.m, and v must be of the same type and
            % size as any existing non-empty elements of the multivector.
            % We do not check the parameters in order to reduce overhead,
            % since the purpose of this function is to make possible
            % efficient insertion of a value into a multivector. Note that
            % it is not necessary to use this function from within a class
            % method, since such methods can directly manipulate the fields
            % within a multivector. The randm function is a classic case of
            % a non-class method that uses this function.
            
            r = m; % Copy the input multivector.
            r.multivector{j} = v;
        end
        
        function r = get(m, j)
            % An internal function to get the j-th component of the
            % multivector m. This returns empty if the component is empty,
            % which is not useful at user level, for which see the
            % function PART.

            r = m.multivector{j};
        end
    end
    methods (Static = true)
        function m = empty(varargin)
            % This function makes it possible to use the dotted notation
            % clifford.empty or clifford.empty(0,1) to create an empty
            % array. Acceptable values for varargin are:
            %
            % 1. Empty, in which case a 0-by-0 double empty multivector is
            %    returned.
            % 2. A list of numeric values, such as 2,3,0, one of which must
            %    be zero.
            % 3. A size vector, with numeric elements, one of which must be
            %    zero.
            % Plus an optional final value (which may occur on its own)
            % which is a string denoting a valid numeric class, such as
            % 'double', 'int8' etc.
            
            global clifford_descriptor;
            
            if isempty(clifford_descriptor)
                error(['The Clifford algebra you wish to use must ' ...
                       'first be initialised by calling ' ...
                       'clifford_signature(p, q)'])
            end

            if isempty(varargin)
                % Default case, return a 0-by-0 double multivector.
                m = clifford_descriptor.empty;
                return
            end
            
            % Check whether the last element of varargin is a string, and
            % if so extract the string and check it.
            
            if ischar(varargin{end})
                C = varargin{end};
                
                if ~strcmp(C, {'double' 'single' ...
                                'int8'  'int16'  'int32'  'int64' ...
                               'uint8' 'uint16' 'uint32' 'uint64'})
                   error([C ' is not a valid numeric classname.']) 
                end
                
                varargin = varargin(1:end - 1); % Delete the last element.
            else
                if ~isnumeric(varargin{end})
                    error(['Unexpected parameter type: ' ...
                            class(varargin{end}) ])
                end
                C = 'double'; % Set C to the default class. We will process
                              % the numeric value(s) below.
            end
            
            % We now need to check the remaining parameters, if any,
            % to make sure they are all numeric and of the same class.
            % First eliminate the possibilty of non-numerics or differing
            % classes.
            
            if isempty(varargin)
                S = [0 0]; % There are no other parameters, supply default.
            else
                if ~all(cellfun(@isnumeric, varargin))
                    error('Size parameter(s) must be numeric.')
                end
                
                K = cellfun(@class, varargin, 'UniformOutput', false);
                for j = 2:length(K)
                    if ~strcmp(K{1}, K{j})
                        error(['All size parameters must be of the ' ...
                               'same numeric class.'])
                    end
                end
                
                if length(varargin) == 1
                    S = varargin{1};
                    if isscalar(S)
                        if S == 0
                            S = [0 0];
                        else
                            error(['Dimension must be zero, found: ' ...
                                    num2str(S)])
                        end
                    end
                    if ~isrow(S)
                        error('Size vector must be a row vector.')
                    end
                else
                    % There is more than one parameter. At least one must
                    % be 0. Check them and build a row vector in S from the
                    % values.
                    
                    S = varargin{1};
                    for j = 2:length(varargin)
                        S = [S varargin{j}]; %#ok<AGROW>
                    end
                    if ~any(S == 0)
                        error('At least one dimension must be zero.')
                    end
                end
                if ~isreal(S)
                    error('Size vector must have real elements.')
                end
            end
            
            % Now make the array using the size S and class C.
                     
            m = clifford_descriptor.empty;
            E = cast(double.empty(S), C); % Make an empty array of the
                                          % correct class and size.
            for j = 1:clifford_descriptor.m
               m.multivector{j} = E;
            end
        end
    end
end

% $Id: clifford.m 271 2021-07-11 19:54:47Z sangwine $
