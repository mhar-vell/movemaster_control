function m = mtimes(l, r)
% *  Matrix multiply.
% (Clifford overloading of standard Matlab function.)
 
% Copyright © 2013, 2021 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor;

ml = isa(l, 'clifford');
mr = isa(r, 'clifford');

if ml && mr
    
    % Both arguments are multivectors.
    
    check_signature(l);
    check_signature(r);
        
    % Testing for empty, scalar, matrix etc is time-consuming, and since
    % this is important low-level code, we do it explicitly here after
    % finding the size of the operands. Otherwise, more time is taken doing
    % these tests than in computing the multiplication itself.
    
    sl = size(l);
    sr = size(r);
    
    if prod(sl) == 0, m = l; return, end % Test for empty. and if so return
    if prod(sr) == 0, m = r; return, end % an empty array.
    
    if length(sl) > 2 || length(sr) > 2
       error('Operands to matrix multiplication must have two dimensions.') 
    end
    
    lrows = sl(2);
    rcols = sr(1);
    
    if ~(all(sl == [1, 1]) || all(sr == [1, 1]) || lrows == rcols)
        error('Left and right operands must be conformable or one must be scalar.')
    end
    
    c = classm(l);
    if ~strcmp(c, classm(r))
        % NB Empty components have a class, so even if the scalar part is
        % empty it enables us to check the class of the components.
        error('Left and right operands must have components of the same class.')
    end
    
    m = clifford_descriptor.empty; % Create a result array.
            
    % Find out which elements of the multivectors are empty and which are
    % not. cellfun was originally used here, but loops were found to be
    % faster. However, there is an undocumented speedup if you use string
    % notation and not a function handle for the function to be applied, so
    % this is what we now do.
    %
    % https://undocumentedmatlab.com/blog/cellfun-undocumented-performance-boost
    
    nel = ~cellfun('isempty', l.multivector);
    ner = ~cellfun('isempty', r.multivector);
    
    % Each component of the result multivector is the sum of m products
    % of pairs of components of the left and right operands. Each
    % product has a sign identified in the sign field of the descriptor
    % and it contributes to an element of the result identified by the
    % index field of the descriptor.
    
    indices = 1:clifford_descriptor.m;

    columns = indices(ner);

    for row = indices(nel)
        lr = l.multivector{row};
        
        index = clifford_index(row, columns);
        sign  = clifford_sign (row, columns);
        
        % Find out which elements of the result multivector are empty for
        % use in the loops below (because we must not add a product to an
        % empty element of the result, we must store the product there).
        % We compute the empty status for all indices but in the two loops
        % they are processing in two disjoint sets (pos and neg), so there
        % is no need to update the empty status because we do not return to
        % the same element twice.
        
        e  = cellfun('isempty', m.multivector(index));
        ne = ~e;
        
        % Now loop over the four possible cases according to sign and
        % whether the multivector element to be updated is empty or not.

        for j = find(sign > 0 & e)
            m.multivector{index(j)} = lr * r.multivector{columns(j)};
        end
        
        for j = find(sign > 0 & ne)
            I = index(j);
            m.multivector{I} = m.multivector{I} ...
                             + lr * r.multivector{columns(j)};
        end
        
        for j = find(sign < 0 & e)
            m.multivector{index(j)} = -lr * r.multivector{columns(j)};
        end
        
        for j = find(sign < 0 & ne)
            I = index(j);
            m.multivector{I} = m.multivector{I} ...
                             - lr * r.multivector{columns(j)};
        end
        
        % If there is at least one product with zero sign AND the result
        % currently has an empty in the e0 element, we need to put an
        % explicit zero array there. We don't otherwise need to do anything
        % with the products where the sign is zero. The size must match the
        % size of the rest of m, which we already know from the size checks
        % done on entry.
        
        if clifford_descriptor.signature(3) ~= 0 && ...
                ~isempty(find(sign == 0, 1)) && isempty(m.multivector{1})
            m.multivector{1} = zeros(size(lrows, rcols), c);
        end
    end
    
else

    % One of the arguments is not a multivector. If it is numeric, we can
    % handle it: we just need to multiply all the elements of the
    % multivector by the numeric argument. If the numeric argument is empty
    % the result will be a multivector with empty components.
    
    if ml && isa(r, 'numeric')
        check_signature(l);
        c = classm(l);
        if ~strcmp(c, class(r))
            error(['Left and right operands must have ', ...
                   'components of the same class.'])
        end
        m = l;
        nem = ~cellfun('isempty', m.multivector); % Not empty m.
        m.multivector(nem) = cellfun(@(x) x * r, m.multivector(nem), ...
                                     'UniformOutput', false);
    elseif isa(l, 'numeric') && mr
        check_signature(r);
        c = classm(r);
        if ~strcmp(c, class(l))
            error(['Left and right operands must have ', ...
                   'components of the same class.'])
        end        
        m = r;
        nem = ~cellfun('isempty', m.multivector); % Not empty m.
        m.multivector(nem) = cellfun(@(x) l * x, m.multivector(nem), ...
                                     'UniformOutput', false);
    else
        error(['Multiplication of a Clifford multivector ', ...
               'by a non-numeric is not implemented.'])
    end
end

m = suppress_zeros(m);

end

% $Id: mtimes.m 280 2021-07-20 15:37:18Z sangwine $
