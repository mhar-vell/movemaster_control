function test_multiplication_table(debug)
% Test code for the clifford multiplication table. The debug parameter
% controls output of progress information. This code is slow. An exhaustive
% test is done for algebras with n <= 10. For larger algebras a selection
% of tests are done, rather than an exhaustive test.

% Copyright (c) 2015, 2021 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

tdisp('Checking multiplication table ...');

narginchk(1,1);

if ~islogical(debug) || ~isscalar(debug)
    error('Input argument must be a logical scalar')
end

% The method used here is to test the products of combinations of basis
% elements using character string manipulation as the reference case (the
% fundamental definition of multiplication of basis blades). For example,
% e12 * e13 = - e23. The result can be computed by concatenating the
% indices 12 and 13 to make 1213, then permuting and sign changing to
% obtain -1123, then replacing 11 with the sign of e1^2. The sign of the
% basis element squared must be taken into account, of course.

global clifford_descriptor

m = clifford_descriptor.m;
n = clifford_descriptor.n;

if n <= 6
    rows = 1:m; % These vectors specify and exhaustive test (every choice
    cols = 1:m; % of row and column from the sign and index tables).
else
    % For larger algebras the time taken to run an exhaustive test would be
    % far too great, so we test only specific combinations of left and
    % right arguments by supplying vectors of row and column indices that
    % specify a subset. We test blocks of rows and columns, covering the
    % scalar, the pseudoscalar, and blocks in between. Ideally we would
    % test a few rows and columns either side of each grade boundary. That
    % is for another day.
    % TODO Choose the blocks to span grade boundaries.
    
    rows = [1:20, (m/4 - 5):(m/4 + 5), ...
                  (m/2 - 5):(m/2 + 5), ...
                  (m/4 + m./2 - 5):(m/4 + m/2 + 5), (m-20):m];
    cols = rows;
end

d = '0123456789abcdefg'; % Subscript digits, as in 'e123'.

% Compute the signs of the n basis blades, for use in the permutation
% algorithm below.

s = clifford_signature;

signs = ['+' ... % This is the sign of e0 squared, which is always positive
         repmat('+', [1, s(1)]) ... % p positive squares
         repmat('-', [1, s(2)]) ... % q negative squares
         repmat('0', [1, s(3)])];   % r zero squares.
     
assert(length(signs) == n + 1)

c0 = clifford(0); % This is computed once for the case where the sign is 0.
                  % Its value is 0.0000 e0.

for row = rows % of the multiplication table.
    if debug
        disp(['Processing row: ' num2str(row)])
    end
    l = clifford_descriptor.index_strings{uint32( ...
        clifford_descriptor.reverse_index_table(row)) + 1}; % E.g. 'e123'
    cl = clifford(l); % This is a multivector version of the string in l.
    l2end = l(2:end);
    for col = cols
        if debug
            if mod(col, 64) == 0
                disp(['Processing column: ' num2str(col)])
            end
        end
        r = clifford_descriptor.index_strings{uint32( ...
            clifford_descriptor.reverse_index_table(col)) + 1};
        cr = clifford(r);
        p = [l2end r(2:end)];          % E.g. '1232'
                
        % Now we have in p the string of numeric indices, e.g. 1232.
        
        % The numeric indices may include letters for large algebras, but
        % these are lexically ordered correctly by Matlab, so we do not
        % need special treatment.
        
        % First sort the string into lexical order, and determine the
        % number of swaps needed. We do this by creating a permutation
        % matrix, the determinant of which gives us the sign directly
        % (-1 if an odd number of swaps, +1 if even).
        
        % Because e0 commutes we need to treat any zeros in p specially, by
        % not including them in the sort. Since zeros can occur only at the
        % start or end of the string, and a zero at the start is already
        % correctly sorted, we just need to move a zero at the end, if
        % present to the start.
        
        if p(end) == '0'
            p = ['0' p(1:end-1)];
        end
        
        % Now make a permutation matrix from the string p showing the swaps
        % needed to rearrange the matrix into lexical order. The
        % determinant of this matrix will give us the sign parity.
        
        [p, I] = sort(p); % Sort p into order. I is the index order needed.
       
        P = eye(length(p)); % Make an identity matrix, then ...
        P(1:end, I) = P;    % re-arrange the columns into the order in I.
        
        s = sign(det(P)); % The sign due to the parity of swaps.
        
        % We have the string in lexical order. Now remove duplicates.
        
        q = ''; % This will become the string without duplicates.
        
        while length(p) > 1
            if p(1) == p(2)
                % The first two characters of p are duplicates. We need to
                % compute a sign change, and remove the two duplicate
                % characters. The means that e1 * e1 will be replaced with
                % e0 (in effect) plus a 'sign' which may be -1, 0, or +1.
                
                % Index the signs table with the index of the character in
                % the string d (the list of subscripts).
                
                I = find(p(1) == d); assert(~isempty(I));
                switch signs(I)
                    case '+'
                        % Nothing to do here, the sign is positive. Since
                        % there is no no-operation statement in Matlab, we
                        % do a harmless unary plus.
                        s = +s;
                    case '-'
                        % We need to toggle the current sign value.
                        s = -s;
                    case '0'
                        % This means the entire result is going to be zero,
                        % so we could stop right here, but if we do, it
                        % makes the further processing complicated, so we
                        % will continue.
                        s = 0;
                    otherwise
                        error('Program error, found a sign not in {-1,0,+1}')
                end
                
                p = p(3:end); % Delete the pair of characters.
                
                if isempty(q) && isempty(p)
                    q = '0'; % This is needed for cases like e1 * e1, where
                             % otherwise q would be left empty.
                end
            else
                % The first character of p differs from the second, so just
                % move it across from the head of p to the tail of q.
                q = [q, p(1)]; p = p(2:end);
            end
        end
        
        q = [q p]; % Move the last character from p.
        
        assert(length(p) == 1 || isempty(p));
        
        % Check for a leading zero and remove it if present. We need to
        % remove only one leading zero, since if we computed e0 * e0, we
        % would have two zeros only, and we want the final result to be
        % '0'. In all other cases, there can only be one zero at most, if
        % we multiplied e0 by something else.
        
        if ~strcmp(q, '0') && q(1) == '0'
            q(1) = '';
        end

        % We have the two literal values that we started with, in the form
        % 'e1', 'e123' etc. and the corresponding clifford multivectors in
        % cl and cr. We can use .* (times) to multiply the latter together
        % and test the table. We form the result from the above calculation
        % with character indices in the same way and compare the two. For
        % good measure we also test the * (mtimes) function.
        
        switch s
            case -1
                u = - clifford(['e' q]);
            case 0
                u = c0; % Replaced 29 June 2021, was: 0 .* clifford(['e' q]);
            case 1
                u = clifford(['e' q]);
            otherwise
                terror('Sign value not in {-1, 0, +1}.')
        end
        
        if debug
            disp([l ' × ' r ' = ' char(u)])
        end
        
        if times(cl, cr) ~= u
            terror(['Error in multiplication of ' l ' .* ' r ...
                   ' found ' char(cl .* cr) ', expected' char(u)]);
        end
        
        if mtimes(cl, cr) ~= u
            terror(['Error in multiplication of ' l ' * ' r ...
                    ' found ' char(cl * cr) ', expected' char(u)]);
        end
        
    end
end

tdisp('Passed');

end

% $Id: test_multiplication_table.m 268 2021-07-11 17:17:54Z sangwine $
