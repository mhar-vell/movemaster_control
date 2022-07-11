function S = randm(varargin)
% RANDM   Creates random multivectors. Accepts parameters as for Matlab's
% randn (q.v.), but optionally a final pair of parameters 'sparse' and k,
% where k is a numeric value equal to or greate than 1/m (where m is the
% number of elements in a multivector) and less than or equal to 1. A
% sparse multivector has k * 100% of the multivector elements non-empty.
% The default is all are non-empty.

% TODO Write this properly so that the results are normalised and uniformly
% distributed. See the corresponding quaternion function.

% Copyright © 2013, 2015, 2017, 2021 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

nargoutchk(0, 1)

global clifford_descriptor

% Handle the two optional last parameters which control creation of sparse
% multivectors (that is where some elements are empty). The default is that
% a full multivector is returned with numeric values in every element.

k = 1; % Default value.

if length(varargin) > 1 
    if isa(varargin{end - 1}, 'char') || isstring(varargin{end - 1})
        if strcmp(varargin{end - 1}, 'sparse')
            assert(isnumeric(varargin{end}), ...
                'Last parameter must be numeric if penultimate is ''sparse''.');
            k = varargin{end};
            if (k < 1.0/cast(clifford_descriptor.m, 'double')) || (k > 1.0)
                error(['Last parameter must be in range (1/m, 1), where' ...
                    ' m is the number of elements in a multivector in ', ...
                    'the current signature. Given: ', num2str(k)]);
            end
            varargin = varargin(1:end-2); % Delete the 'sparse' and k values.
        end
    end
end

% Make an index array to select the elements to be populated. If k = 1 this
% will be all elements, otherwise it will be some fraction of the elements
% from at least one element upwards. We must be sure that at least one
% index is chosen, otherwise we would return an empty multivector. This is
% why we use permutation and not random numbers compared against a
% threshold.

% TODO Can we do this without creating the full list?

index = randperm(clifford_descriptor.m);
index = sort(index(1:fix(k * clifford_descriptor.m)));

S = clifford.empty;

for j = index
    S = put(S, j, randn(varargin{:}));
end

if clifford_descriptor.m > 1 % If we are working in the reals, do not normalise!
    S = unit(S); % Normalise the random multivectors to unit norm.
end

end

% $Id: randm.m 285 2021-07-28 16:23:39Z sangwine $
