function m = dip(l, r)
% DIP  Dorst or (fat) dot inner product

% This product is based on a formula (2.10) by Leo Dorst:
%
% Leo Dorst, 'The inner products of geometric algebra', ch. 2, pp. 35-46,
% in: L. Dorst, C. Doran, J. Lasenby, 'Applications of geometric algebra in
% computer science and engineering', Birkhauser, Boston, 2002.
% DOI: 10.1007/978-1-4612-0089-5.
%
% See also the function HIP which defines a closely related inner product
% due to David Hestenes, and defined by Dorst as (2.9).

% Copyright © 2018 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor;

ml = isa(l, 'clifford');
mr = isa(r, 'clifford');

if ml, check_signature(l); end
if mr, check_signature(r); end

if ml && mr
    
    % Both arguments are multivectors.
    
    m = clifford(zeros(size(l)));
       
    for k = 0:clifford_descriptor.n
        for s = 0:clifford_descriptor.n % TODO Work out whether - k could be added, cf wedge.m
            [lk, el] = grade(l, k);               if el, continue; end
            [rs, er] = grade(r, s);               if er, continue; end
            [g,  eg] = grade(lk .* rs, abs(s-k)); if eg, continue; end
            m = m + g;
        end
    end
 
else

    % One of the arguments is not a multivector. If it is numeric, we can
    % handle it. For simplicity we promote the numeric to a multivector and
    % make a recursive call.
    % TODO Check whether there is a simplification, for example the result
    % is defined to be zero? If so, cut out the computation and return
    % zero.
    
    if ml && isa(r, 'numeric')
        m = dip(l, clifford(r));
    elseif isa(l, 'numeric') && mr
        m = dip(clifford(l), r);
    else
        error('Dorst or (fat) dot inner product of a Clifford multivector with a non-numeric is not defined.')
    end
end

end

% $Id: dip.m 271 2021-07-11 19:54:47Z sangwine $
