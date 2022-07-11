function a = normm(m)
% NORMM  Norm of a multivector (norm of each element for arrays)

% Copyright © 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1) 

global clifford_descriptor;

index = 1:clifford_descriptor.m;

a = zeros(size(m), classm(m)); % To accumulate the sum of the squares.

nem = ~cellfun('isempty', m.multivector);

% TODO A solution to the vectorisation of this function would be to define
% a Hadamard product function which computes the elementwise product within
% a multivector. The result could then be summed over all multivector
% elements. An issue is how to do the product if the elements of the
% multivector are matrices - should it be a pointwise or matrix product?

% S = diag(clifford_descriptor.sign);

for j = index(nem)
    
    % If any element of the multivector is empty, it is treated as an
    % implicit zero (array) and skipped.
    
    %if ~isempty(m.multivector{j})
        % 23 November 2018 - error here found by Radek Tichy in Brno: the
        % sign of the squared basis element needs to be included. This
        % should then give the same result as scalar_product(m, conj(m)).
        
        % TODO A better solution would be to use m .*
        % principal_involution(m).
        
        % TODO IT DOESN'T, e.g. for Cl(2,2)
%         switch S(j)
%             case -1
%                 a = a - m.multivector{j}.^2;
%             case 0
%                 continue % To the next value of j. If the sign is 0,
%                          % the square of the product is also zero, so we
%                          % don't add it, nor even compute it.
%             case 1
                a = a + m.multivector{j}.^2;
%             otherwise
%                 error(['Program error, descriptor sign array ', ...
%                        'has value not in set {-1, 0, +1}'])
%         end
    %end
end

end

% $Id: normm.m 271 2021-07-11 19:54:47Z sangwine $
