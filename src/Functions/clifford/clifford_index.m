function ix = clifford_index(r, c)
% CLIFFORD_INDEX  Given the indices of two multivector components, computes
% the index of the multivector component which is the product of the two
% components. Until version 1.5 of the toolbox this calculation was done as
% part of the initialisation of the signature and stored in the cache as
% the index table. However, this used a lot of memory and cache filespace
% for n = 16 (the table needed 4GB). From version 1.6 this function is
% called to provide a table for the descriptor for smaller algebras, but is
% used to compute indices dynamically for larger algebras.

% Copyright © 2021 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% This function is not intended for user use. It cannot be a class method
% because the input parameters are numeric and not multivector.

% This function will work for both input parameters scalar, or one scalar
% and one vector, or both vectors.

% The data returned is ready for use. That is the index value is 1 based
% even for algebras with n = 16. The data type is either uint16 or uint32
% depending on whether the data is looked up or computed dynamically.

global clifford_descriptor

% Note that the index field must exist before this function is called. This
% is ensured by intialising it as empty in the clifford_signature function
% before the call to this function.

if isempty(clifford_descriptor.index)
    
    % Compute the index dynamically and return a uint32 result to cater for
    % the case when n = 16 (the index range is then from 1 to 65536). Note
    % that the index_table and the reverse_index_table store uint16 values,
    % one less than the 'true' index. So we must convert to uint32 and add
    % the 1 to obtain the correct 32-bit value. This matters only for
    % algebras with n = 16, since all other algebras have 32768 elements or
    % less.

    ix = uint32(clifford_descriptor.reverse_index_table(...
         uint32(bitxor(clifford_descriptor.index_table(r).', ...
                       clifford_descriptor.index_table(c))) + 1)) + 1;
else
    
    % The index exists in the descriptor, so return a result by lookup
    % instead of computing it. In this case the result returned will be
    % uint16.
    
    ix = clifford_descriptor.index(r, c);
    
end

% $Id: clifford_index.m 268 2021-07-11 17:17:54Z sangwine $