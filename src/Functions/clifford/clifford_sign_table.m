function g = clifford_sign_table(p, q, r)
% CLIFFORD_SIGN_TABLE computes a matrix which represents the multiplication
% rules for the Clifford algebra Cl(p,q,r).

% Copyright © 2011, 2014, 2015, 2019, 2021
%             Stephen J. Sangwine and Eckhard Hitzer.

% From version 1.6 of the toolbox this code is replaced by the function
% clifford_sign.

% This function was based on the function clifford_tensor, which is how the
% multiplication table for a clifford algebra was originally computed.
% However, the tensor is a three-dimensional array, and it cannot be
% computed in practice for algebras with n = p + q + r greater than about
% 10 or 11 because of the amount of memory needed to store it.

% In 2019 this function was re-written to use a much faster vectorised
% computation rather than the nested loops used previously. The last
% version of the previous code was SVN rev 177, for comparison. In contrast
% to the earlier code, this version will use more memory, which is
% significant only for larger algebras where the earlier code took many
% tens of hours to run.

% The tensor g is a 3-dimensional array of dimension [m, m, m], where
% m = 2.^n and n = p + q. The parameters p, q, r are the usual values
% representing the numbers of basis elements of the vector space that
% square to 1, -1 and 0 respectively. Elements of the tensor are in the set
% {-1, 0, +1} and every 'row' (in any direction) has at most one non-zero
% element. The tensor encodes the multiplication rules of the algebra.
% The formal details are given in the paper below by Perwass et al, using
% tensor notation and the Einstein summation convention, but a simpler
% account is given in the paper by Schultz et al, in which the matrices Tx
% are the planes of the tensor with the third index constant.

% References:
%
% 1. C. Perwass, C. Gebken and G. Sommer,
% 'Estimation of geometric entities and operators from uncertain data',
% in W. G. Kropatsch, R. Sablatnig and A. Hanbury (editors),
% PATTERN RECOGNITION, PROCEEDINGS, 27th Annual Meeting of the German
% Association for Pattern Recognition, Vienna University of Technology,
% Vienna, Austria, 31 August - 2 September 2005.
% LECTURE NOTES IN COMPUTER SCIENCE, Vol. 3663, pp.459-467.
% SPRINGER-VERLAG BERLIN.
%
% (The tensor g is defined in section 2, on p461.)
%
% 2. Dominik Schulz, Jochen Seitz and Joao Paulo C. Lustosa da Costa,
% 'Widely Linear SIMO Filtering for Hypercomplex Numbers',
% 2011 IEEE Information Theory Workshop (ITW 2011), 16-20 October, 2011,
% Paraty, Brazil.
%
% (The matrices Tx which are planes of the tensor are defined in equation
% 1, section II.B.)
%
% The tensor is computed in natural binary order, and then re-ordered
% before return into lexical order, which is the order in which it is most
% naturally expressed and used elsewhere.

% Check the sanity of the parameters.

narginchk(3, 3), nargoutchk(0, 1)

assert(isnumeric(p) && isnumeric(q) && isnumeric(r), 'Parameters must be numeric.');
assert( isscalar(p) &&  isscalar(q) &&  isscalar(r), 'Parameters must be scalars.');
assert(      p >= 0 && q >= 0       && r >= 0,       'Parameters must be non-negative.');
assert( fix(p) == p && fix(q) == q  && fix(r) == r,  'Parameters must be integers.');
assert(p + q + r >= 0, 'Parameters must sum to a non-negative value.');

n = uint32(p + q + r); m = 2 .^ n;

% TODO Rewrite this function so that g is the only two-dimensional array
% used. Process row by row so that all other arrays are vectors and
% therefore do not add significantly to the memory footprint. The structure
% will therefore be a loop by row, rather than processing all of g at once.

% TODO Even better, write a function clifford_sign(p, q, r, row, col) which
% computes the sign for a single (row, column) entry in the sign table, and
% a given p, q, r or a vector like E below. Make sure this function can
% cope with either (but not both) of row and col as vectors (and the other
% a scalar, so that the calculation can be vectorised by row or column.

g = ones([m, m], 'int8'); % Pre-allocate space for the sign table.

% The algebra Cl(p,q,r) has p basis elements that square to +1, q that
% square to -1 and r that square to 0. We represent this by the following
% vector.

E = [ones([1, p], 'int8'), -ones([1, q], 'int8'), zeros([1, r], 'int8')];

% The return result is obtained conceptually by iterating over two of the
% indices of the tensor (I, J). For each pair of indices, there is at most
% one element along the corresponding third dimension of the tensor which
% has a non-zero value, and this value is +1 or -1. So, we have to compute
% the value, and the index where it belongs. The indices I and J represent
% products of basis elements of the algebra (conventionally denoted e_1,
% e_2 etc). If a bit is set in the binary representation of the index, the
% corresponding basis element is present in a product. When we multiply the
% product of elements I by J we get a result with sign S. This function
% does not compute the index along the third dimension: this is done by a
% separate function called clifford_lexical_index_mapping.
                   
% The index values used here are limited to 16-bit integers because this is
% also the limit of the index table. With 16-bit entries, the maximum
% memory footprint of the index table is 8GB.

J = uint16(0:m-1); %#ok<BDSCI>
                   % These two vectors represent a matrix of index values.
I = J.';           % They are kept as vectors to save memory, making use of
                   % singleton expansion where needed. Conceptually what
                   % they do is equivalent to:
                   % [J, I] = meshgrid(uint16(0:m-1),uint16(0:m-1)).

% Stage 1. Eliminate the common basis elements from the I and J values.
% Notionally, we are moving an element inside the product represented by I
% to the right, and the same element inside the product represented by J to
% the left, in order to cancel them out. The number of position swaps we
% have to do is the number of sign changes. In addition when we eliminate
% an element, we must take account of the sign of its square, which is
% determined by the values of p, q and r.

C = bitand(I, J);
 
for t = 1:n % Iterate through the n basis elements.
    
    D = logical(bitget(C, t)); % Index for elements of C where bit t is set.
    
    % In what follows we count up swaps for all elements of I, J, C, even
    % though we are going to apply the result only where D is true.
        
    % Count the number of swaps needed. We have to work one bit at a
    % time here because the bitgets are operating on the whole arrays
    % I, J and C, and we cannot simultaneously have an array of index
    % values: the second parameter must be scalar or the same size as
    % the first.
    
    N = zeros(size(D), 'uint8'); % 8 bits is enough to count the swaps.
    
    % We need to count up the number of bits to the right of t in I,
    % plus the number to the left of t in J, less the number to the
    % left of t in C.
    
    for u = t+1:n
        N = N + uint8(bitget(I, u));
    end
    
    for u = 1:t-1
        N = N + uint8(bitget(J, u));
    end
    
    for u = 1:t-1
        N = N - uint8(bitget(C, u));
    end
    
    % Determine which elements of the sign table need to be negated
    % according as to whether N is odd (LSB == 1). We overwrite N at
    % this point in order to avoid another potentially large array.
    
    N = D & (bitget(N, 1) == 1);
    
    g(N) = -g(N); % Negate the elements in the sign table indexed by N.
    
    g(D) = g(D) .* E(t); % Include the 'sign' of the basis element.
end
        
% Stage 2. Merge the non-common elements into lexical order, again
% accumulating the signs as we do.

% TODO The memory footprint here is high with three potentially large 2D
% arrays in existence at the same time. Unlike I and J above, it does not
% look easy to store these as vectors and generate the data by singleton
% expansion as needed, but in order to work for large algebras with n>16
% some change may be needed here.
        
UI = bitxor(I, C); % This clears any bits in I that are set in C.
UJ = bitxor(J, C); % Ditto for J. Hence these two arrays represent
                   % the non-common basis elements.
clear C

for t = 1:n
    
   D = logical(bitget(UJ, t));
       
   % Where the t element of the right product is present, move it to
   % its position in the left, and take account of signs.
   
   N = zeros(size(D), 'uint8');
   
   for u = t+1:n
       N = N + uint8(bitget(UI, u));
   end
   
   N = D & (bitget(N, 1) == 1);
   
   g(N) = -g(N); % Negate the elements in the sign table indexed by N.
end

% At this point, the table is in natural binary order because that was the
% easiest way to compute it. Convert it to lexical order before return,
% because that is the way it is used, since multivector elements are stored
% in lexical order.

[index, ~, ~] = clifford_lexical_index_mapping(n);

% At this point, index is an array of uint16 values, from 0:m. When n = 16,
% this means 0:65535. We cannot therefore add 1 to give Matlab indices
% running from 1 without changing to uint32 or double, otherwise adding 1
% to 65535 will give 65535, and not the correct value of 65536.

index32 = uint32(index) + 1;

g = g(index32, :); % We process here by rows and columns separately to
g = g(:, index32); % avoid a larger memory footprint. Previously the code
                   % was g = g(index32, index32).
end

% $Id: clifford_sign_table.m 286 2021-07-28 16:54:33Z sangwine $
