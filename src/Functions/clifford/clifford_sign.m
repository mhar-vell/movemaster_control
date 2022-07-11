function S = clifford_sign(I, J)
% CLIFFORD_SIGN computes the sign of a product of two multivector elements,
% represented by their uint16 lexical indices I and J. The two parameters
% may be both scalar, both vector, or one may be scalar and one vector, in
% which case a vectorised computation is performed to yield a vector of
% signs. The result has elements from {-1, 0, +1} returned as an int8. An
% algebra must have been partially initialised before this function is
% called (not checked due to need for speed), because the values of some
% fields of the descriptor are needed for the calculation of the sign. If I
% or J is a vector, it need not be a contiguous vector, that is it could
% represent a subset of the multivector elements at non-consecutive
% positions in the lexical ordering.

% Copyright © 2021 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% This function is not intended for user use. It cannot be a class method
% because the input parameters are numeric and not multivector. Therefore
% it cannot be made into a private function. There is minimal error
% checking because of the need for this function to be fast in order not to
% slow down multiplication, which uses the sign computed here.

% Based on code in the earlier function clifford_sign_table (q.v.) which
% computed the entire table in a 2D vectorised calculation, but could not
% handle vectorisation by rows or columns.

% The input parameters must be both scalar, both vector, or one of each.
% The first parameter must be a column vector representing row numbers in
% the sign table, the second a row vector representing column numbers.
% CAUTION: If both are vectors, the result in S will be a matrix, which
% could be huge for algebras with large N (4GB for n = 16).

global clifford_descriptor

if ~isempty(clifford_descriptor.sign)
    % The sign table exists in the descriptor, so return a result by lookup
    % rather than computation.
    
    S = clifford_descriptor.sign(I, J);
    return
end

% There is no sign table in the descriptor, so we must compute the required
% sign here and that is what the rest of this function does.

% The algebra Cl(p,q,r) has p basis elements that square to +1, q that
% square to -1 and r that square to 0. clifford_descriptor.n is p+q+r.

p = clifford_descriptor.signature(1);
q = clifford_descriptor.signature(2);

% The third element in (p, q, r) is used implicitly below in setting up E
% to be a vector of squared basis elements.

E = zeros(1, clifford_descriptor.n, 'int8');
E(1:p)       = +1;
E(p + (1:q)) = -1;

% Convert the input parameters into binary indices (the entry parameters I
% and J are lexical), ensuring that BI is a column vector (BJ will be a row
% vector because the index table is a row vector).

BI = clifford_descriptor.index_table(I).';
BJ = clifford_descriptor.index_table(J);

% Stage 1. Eliminate the common basis elements from the BI and BJ values.
% Notionally, we are moving an element inside the product represented by BI
% to the right, and the same element inside the product represented by BJ
% to the left, in order to cancel them out. The number of position swaps we
% have to do is the number of sign changes. In addition when we eliminate
% an element, we must take account of the sign of its square, which is
% determined by the values of p, q and r.

C = bitand(BI, BJ);

% Preallocate the sign result. This may be a scalar, vector, or matrix
% depending on the dimensions of I and J.

S = ones(size(C), 'int8');

% Make three arrays of zeros from which we can make copies inside the loop
% for counting.

ZI = zeros(size(BI), 'uint8');
ZJ = zeros(size(BJ), 'uint8');
ZC = zeros(size(C),  'uint8');

for t = 1:clifford_descriptor.n % Iterate through the n basis vectors.
    
    D = logical(bitget(C, t)); % Index for elements of C where bit t is set.
    
    % In what follows we count up swaps for all elements of I, J, C, even
    % though we are going to apply the result only where D is true. This is
    % a possible inefficiency, to be studied later.
        
    % Count the number of swaps needed (uint8 is sufficient for this). We
    % have to work one bit at a time here because the bitgets are operating
    % on the whole arrays BI, BJ and C, and we cannot simultaneously have
    % an array of index values: the second parameter must be scalar or the
    % same size as the first.
    
    MI = ZI;
    MJ = ZJ;
    MC = ZC;

    % We need to count up the number of bits to the right of t in I,
    % plus the number to the left of t in J, less the number to the
    % left of t in C.
    
    for u = t+1:clifford_descriptor.n
        MI = MI + uint8(bitget(BI, u));
    end
    
    for u = 1:t-1
        MJ = MJ + uint8(bitget(BJ, u));
        MC = MC + uint8(bitget(C,  u));
    end
    
    M = MI + MJ - MC; % These may be of different sizes, but singleton
                      % expansion will expand the smaller ones.
    
    % Determine which elements of the sign need to be negated
    % according as to whether M is odd (LSB == 1).
    
    N = D & logical(bitget(M, 1));
    
    S(N) = - S(N); % Negate the elements in the sign indexed by N.
    
    S(D) = S(D) .* E(t); % Include the 'sign' of the basis element.
end
        
% Stage 2. Merge the non-common elements into lexical order, again
% accumulating the signs as we do.
        
UI = bitxor(BI, C); % Clear any bits in BI that are set in C.
UJ = bitxor(BJ, C); % Ditto for BJ. Hence these two arrays
                    % represent the non-common basis elements.

for t = 1:clifford_descriptor.n

   D = logical(bitget(UJ, t));
       
   % Where the t element of the right product is present, move it to
   % its position in the left, and take account of signs.
   
   M = zeros(size(D), 'uint8');
   
   for u = t+1:clifford_descriptor.n
       M = M + uint8(bitget(UI, u));
   end
   
   N = D & logical(bitget(M, 1));
   
   S(N) = -S(N); % Negate the elements in the sign vector indexed by N.
end

end

% $Id: clifford_sign.m 283 2021-07-22 21:09:48Z sangwine $
