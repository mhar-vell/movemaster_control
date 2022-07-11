function [m_dash, path, solution_path] = iso(m, p, q)
% ISOMORPHISM Map a multivector argument to an isomorphic multivector
% result in a different algebra. p and q may be omitted, in which case the
% result will be automatically converted to real, and the current algebra
% will remain unchanged. If p and q are specified, the current algebra on
% return will be Cl(p, q).

% The second and third output parameters are cell arrays of strings
% indicating the sequence of isomorphisms needed to map from the input
% algebra to the output algebra. These are intended for diagnostic use
% only.

% TODO Limitation (see note 1 at end): this code will not work for
% arbitrary choice of (p,q). Step 1 would be to detect from the parameters
% and the current algebra when a failure will occur and raise an error.
% Step 2 would be to overcome the problem and provide a solution.

% Copyright © 2017 Harry I. Elman (code contributed to the toolbox with
% edits by Steve Sangwine). This code is licensed under the same terms as
% the toolbox itself, for which see the file : Copyright.m for further
% details.

% The second and third arguments specify the algebra of the result.

narginchk(1, 3); nargoutchk(0, 3);

global clifford_descriptor

% Check the parameters.

if isa(m, 'clifford')
    check_signature(m);
else
    error('First parameter must be a multivector.')
end

if ndims(m) > 2 %#ok<ISMAT>
    error('Cannot compute isomorphism for array with more than 2 dimensions.')
end

if nargin == 1
    p = 0; % Supply default target algebra values if none are specified.
    q = 0;
end

if nargin == 2
    error('Third parameter must be given if second is given.')
end

if ~isnumeric(p) || ~isnumeric(q)
    error('Second and third parameters must be numeric.')
end

if p < 0 || q < 0
    error('Second and third parameters must be non-negative.')
end

if clifford_descriptor.signature(3) ~= 0
   error(['Current signature has r = ', ...
           num2str(clifford_descriptor.signature(3)), ...
           '. Cannot handle this.'])
end

currentP = double(clifford_descriptor.signature(1));
currentQ = double(clifford_descriptor.signature(2));

% s = size_of_matrix;

path = [];
solution_path = [];

dummy = part(m, 1);
[row, ~] = size(dummy);
extraAllowed = row;
assert(2^(currentP + currentQ + extraAllowed) >= 2^(p + q), 'The desired algebra is too big')

[M, path] = iso_in(m, path); % Map m in the input algebra to real array M.

if nargin == 1
    % Implicit parameters for p and q, mean we want a result which is real,
    % i.e. not a multivector array, which is already in M.
    
   m_dash = M;
   clifford_signature(currentP, currentQ); % Restore the algebra on entry.
   return
end

if p == 0 && q == 0 && nargin > 1
    % There were explicit parameters given for p and q, but the target
    % algebra is Cl(0,0), so all we need to do is convert M to Cl(0,0).
    clifford_signature(0,0);
    m_dash = clifford(M);
    return
end

% The output algebra is not Cl(0,0), so we have a further step to map M to
% Cl(p,q). The first step is to find the sequence of isomorphisms needed to
% map from Cl(p,q) to reals, this is used in reverse to get us from reals
% to Cl(p,q).

clifford_signature(p, q)

[~, solution_path] = iso_in(e0, solution_path); % e0 is just a dummy value.

clifford_signature(0, 0)
m_dash = iso_out(M, solution_path);

% TODO We should consider suppressing zeros here.

%clifford_signature(p, q)
end

% Note 1: This code will not work for all combinations of input algebra and
% target algebra. The problem is mathematical rather than programmatical,
% as exemplified by the following examples:
%
% a) Start with a 2x2 array in Cl(2,0) and map it to Cl(0,2) using this
% function. The result will be a single multivector with only 4 coefficients
% which cannot represent all the information in the original 2x2 matrix.
%
% b) Start with a single multivector in Cl(0,2) and map it to Cl(0,1). The
% result will be a 2x2 array. Map this back to Cl(0,2) and the result will
% be identical to the starting value. However, if you do the same steps but
% replace Cl(0,1) by Cl(1,0), the result will not match. This is because
% the matrix representation in Cl(1,0) has diagonal elements with the same
% value, rather than sums and differences. Information is lost when mapping
% from Cl(0,2) to Cl(1,0), unless a larger array is used.

% function rowSize = size_of_matrix
% 
% global clifford_descriptor
% p = double(clifford_descriptor.signature(1));
% q = double(clifford_descriptor.signature(2));
% d = p + q;
% l = floor(d / 2);
% difference = mod((p - q), 8);
% if (difference == 0)
%     rowSize = 2^(l);
% elseif (difference == 1)
%     rowSize = (2^(l)) * 2;
% elseif (difference == 2)
%     rowSize = 2^(l);
% elseif (difference == 3)
%     rowSize = (2^(l)) * 2;
% elseif (difference == 4)
%     rowSize = (2^(l - 1)) * 4;
% elseif (difference == 5)
%     rowSize = (2^(l - 1)) * 8;
% elseif (difference == 6)
%     rowSize = (2^(l - 1)) * 4;
% elseif (difference == 7)
%     rowSize = (2^(l)) * 2;
% end
% end

% $Id: iso.m 270 2021-07-11 19:42:06Z sangwine $
