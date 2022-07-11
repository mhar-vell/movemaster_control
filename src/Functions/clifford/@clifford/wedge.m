function m = wedge(l, r, varargin)
% WEDGE  Clifford wedge product

% Copyright © 2013, 2016 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% The wedge product is associative, which is why we allow varargin
% parameters. However, to simplify the coding, especially of error
% checking, we make recursive calls to process the varargin parameters.

global clifford_descriptor;

ml = isa(l, 'clifford');
mr = isa(r, 'clifford');

if ml, check_signature(l); end
if mr, check_signature(r); end

if ml && mr
    
    % Both arguments are multivectors.
    
    m = clifford(zeros(size(l)));
       
    for k = 0:clifford_descriptor.n
        for s = 0:clifford_descriptor.n - k
            [lk, el] = grade(l, k);            if el, continue; end
            [rs, er] = grade(r, s);            if er, continue; end
            [g,  eg] = grade(lk .* rs, k + s); if eg, continue; end
            m = m + g;
        end
    end
 
else

    % One of the arguments is not a multivector. If it is numeric, we can
    % handle it.
    
    if ml && isa(r, 'numeric')
        m = l .* r;
    elseif isa(l, 'numeric') && mr
        m = l .* r;
    else
        error('Wedge product of a Clifford multivector with a non-numeric is not defined.')
    end
end

% We now have in m the wedge product of l and r. But we are not finished if
% varargin is non-empty.

% TODO This method may not be a good choice numerically (serially wedging
% the varargin parameters). A better method appears to be to wedge the
% parameters in adjacent pairs, then wedge the adjacent results. Requires
% further study.

if ~isempty(varargin)
    m = wedge(m, varargin{1}, varargin{2:end});
end

end

% $Id: wedge.m 271 2021-07-11 19:54:47Z sangwine $
