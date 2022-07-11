function m = times(l, r)
% .*  Array multiply.
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
        
    % 20 April 2017 Removed a check here on the sizes of the operands, as
    % it is better to let Matlab do this, in order to permit singleton
    % expansion.
    
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
    
    if ~any(nel), m = l; return, end % If all elements of the left operand
    if ~any(ner), m = r; return, end % are empty, we can return it and we
                                     % are done. Ditto right.

    % Each component of the result multivector is the sum of m products
    % of pairs of components of the left and right operands. Each
    % product has a sign identified in the sign field of the descriptor
    % and it contributes to an element of the result identified by the
    % index field of the descriptor. If these fields are empty they are
    % dynamically computed.
    
    indices = 1:clifford_descriptor.m;

    columns = indices(ner);
    
    e0flag = false; % We use this below to detect the case where we need to
                    % create an explicit 0.0000 e0.
    
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

        for j = find(sign > 0 & e)
            m.multivector{index(j)} = lr .* r.multivector{columns(j)};
        end
        
        for j = find(sign > 0 & ne)
            I = index(j);
            m.multivector{I} = m.multivector{I} ...
                             + lr .* r.multivector{columns(j)};
        end
        
        for j = find(sign < 0 & e)
            m.multivector{index(j)} = -lr .* r.multivector{columns(j)};
        end
        
        for j = find(sign < 0 & ne)
            I = index(j);
            m.multivector{I} = m.multivector{I} ...
                             - lr .* r.multivector{columns(j)};
        end
        
        % If there is at least one product with zero sign AND the result
        % currently has an empty in the e0 element, we put an explicit zero
        % array there. We don't otherwise need to do anything with the
        % products where the sign is zero. If the rest of the multivector
        % is non-zero, this zero will be suppressed later.
        
        if clifford_descriptor.signature(3) ~= 0 && ...
                                   ~isempty(find(sign == 0, 1))
             e0flag = true;
        end
    end
    
    if e0flag && isempty(m.multivector{1})
        % We need to insert an explicit zero, which may be suppressed
        % later, and the size of this explicit zero needs to match the size
        % of m, unless m is empty. What complications!
        if isempty(m)
            m.multivector{1} = zeros(1, c); % If m is empty, the zero needs
                                            % to be of size [1, 1].
        else
            m.multivector{1} = zeros(size(m), c);
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
        m.multivector(nem) = cellfun(@(x) x .* r, m.multivector(nem), ...
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
        m.multivector(nem) = cellfun(@(x) l .* x, m.multivector(nem), ...
                                     'UniformOutput', false);
    else
        error(['Multiplication of a Clifford multivector ', ...
               'by a non-numeric is not implemented.'])
    end
end

m = suppress_zeros(m);

end

% $Id: times.m 280 2021-07-20 15:37:18Z sangwine $
