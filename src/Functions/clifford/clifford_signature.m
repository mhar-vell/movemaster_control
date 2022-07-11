function s = clifford_signature(p, q, r)
% CLIFFORD_SIGNATURE sets the signature (p, q, r) to be the signature of
% the current Clifford algebra and initialises data structures used
% internally such as the multiplication table. If q and/or r is omitted
% they default to zero. If called without arguments, the function outputs
% diagnostic information about the currently initialised algebra. A single
% input parameter of form [p, q] or [p, q, r] is also acceptable. If called
% with an output argument, it returns the values of p, q and r from the
% descriptor as a vector. This vector will be empty if no algebra has been
% initialised. It is not permitted to have input and output arguments at
% the same time.

% Copyright © 2013, 2014, 2015, 2019, 2021 
%             Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% Changed with version 1.4 of the toolbox to read and write the descriptor
% from cache in two parts:
%
% (a) the fields that depend on the signature, and are thus different for
% every algebra - these are written to a cache file with name p_q_r.mat
% (e.g. 0_2_0.mat), where (p,q,r) is the signature;
%
% (b) the fields that are invariant to the signature and depend only on n =
% p + q + r - these are written to a file with name n.mat (e.g. 4.mat).
%
% The descriptor structure has the following fields:
%
%           signature: a 3-element uint16 vector containing [p, q, r]
%                   n: the sum of p, q, and r, uint16
%                   m: n^2, uint32 (maximum value 65536)
%               empty: empty clifford multivector of signature (p,q,r)
%                sign: m-by-m matrix of int8               #
%         index_table: an n-element uint16 vector         *
% reverse_index_table: ditto                              *
%       index_strings: an n-element cell array of strings *
%         grade_table: n+1-by-m logical                   *
%               index: n-by-n matrix of uint16            *#
%
% * denotes invariant to the signature, but dependent on n, and therefore
% loaded/saved separately, and # denotes that for algebras with n > 10 this
% field is an empty array - dynamic computation is used to avoid a heavy
% memory use and a large cache file.
%
% The sign and index tables are in lexical order, the same order in which
% coefficients of a multivector are stored. The index_strings are in the
% same order. The index values are 1-based and ready for use. Since large
% algebras use dynamic index computation, the 16-bit limitation in the
% index in the descriptor does not apply to the larger algebras.

% From version 1.6 of the toolbox, the sign and index values are computed
% on-the-fly in the two multiplication methods, using clifford_index.m, for
% large algebras (n > 10). This saves a large amount of memory for large
% algebras and reduces the size of the cache files. This change
% necessitated a change to cache format v2.

global clifford_descriptor;
                            
narginchk(0, 3), nargoutchk(0, 1)

if nargin > 0 && nargout > 0
    error('Cannot have input arguments and output arguments at the same time.')
end

switch nargin
    case 0
        if isempty(clifford_descriptor)
            if nargout == 1
                s = [];
                return
            else
                error('No Clifford algebra has been initialised.')
            end
        else
            switch nargout
                case 0
                    diagnostic
                    return
                case 1
                    s = clifford_descriptor.signature; return
            end
        end
    case 1
        if isscalar(p)
            % Assume that q and r are implicit.
            q = 0; r = 0; % Supply the default values for q and r.
        else
            % p must be a vector. It could be of length 2 or 3.
            if isvector(p) && length(p) == 2
                q = p(2); r = 0; p = p(1);
            elseif isvector(p) && length(p) == 3
                q = p(2); r = p(3); p = p(1);
            else
                error('First parameter must be scalar, or a vector of length 2 or 3.')
            end
        end
    case 2
        r = 0; % Supply the default value for r.
end

% Check the values of p, q, r.

if ~isscalar(p) || ~isscalar(q) || ~isscalar(r)
    error('The input parameters must be scalars.')
end

if ~isnumeric(p) || ~isnumeric(q) || ~isnumeric(r)
    error('The input parameters must be numeric.')
end

if p < 0,       error('The first parameter must not be negative'), end
if p ~= fix(p), error('The first parameter must be an integer'), end

if q < 0,       error('The second parameter must not be negative'), end
if q ~= fix(q), error('The second parameter must be an integer'), end

if r < 0,       error('The third parameter must not be negative'), end
if r ~= fix(r), error('The third parameter must be an integer'), end

pqr = uint16([p, q, r]);

if sum(pqr) > 16 % intmax('uint16') is 65535. (2^16 = 65536.)
    error('Implementation limit: p + q + r cannot exceed 16')
end

% Check whether an algebra has already been initialised.

if ~isempty(clifford_descriptor)
    
    % The descriptor has already been initialised with an algebra. Check it
    % to find out whether it is the same as Cl(p, q, r).
    
    if all(clifford_descriptor.signature == pqr)
        
        % Algebra Cl(p, q, r) is already initialised, no need to initialise
        % it again (this check was added in June 2019 to make it possible
        % to call clifford_signature from a script, so that on first call,
        % the script will initialise the algebra, but on subsequent calls
        % it will not, to avoid wasted time, particularly with large
        % algebras.
        
        return
    end
end

% Now check whether the cache directories exist, and if not create them.

cache = [clifford_root filesep 'cache'];

if ~exist(cache, 'dir')
    % The main cache directory does not exist, so create it for future use.
    mkdir(cache)
end

cache = [cache filesep 'v2']; % This is the cache version number. This MUST
                              % be changed if the format of the cache files
                              % is altered.
if ~exist(cache, 'dir')
    % The versioned cache sub-directory does not exist, so create it.
    mkdir(cache)
end

% The cache contains two types of files, signature dependent, and signature
% invariant. Construct the filenames. Then we can check whether the files
% exist, and if so read them in, if not, we have to create the data and
% save to the files from the newly created descriptor.

invariant_filename = [cache filesep num2str(p + q + r) '.mat'];
dependent_filename = [cache filesep ...
                      num2str(p) '_' num2str(q) '_' num2str(r) '.mat'];

% Code here was completely reorganised for version 1.6 of the toolbox, at
% the same time as implementing omission of the sign and index tables for
% algebras with n > 10.
                   
if exist(dependent_filename, 'file') == 2

    % The algebra Cl(p, q, r) already has a cache file of name p_q_r.mat,
    % so we can read it in and initialise those fields of the descriptor
    % that are stored in this type of file. Note that the sign field always
    % exists but may be empty for larger algebras.
    
    clifford_descriptor = load(dependent_filename);
    
    % The invariant file n.mat must exist, because the dependent file
    % exists, and this function will not create one without the other.
    % However, we check this in case of programming error, or some other
    % mistake (for example, the user has deleted it).
    
    assert(exist(invariant_filename, 'file') == 2, ...
        ['Serious error, file ' invariant_filename ' is missing from ' ...
         'the cache directory ' cache ...
         '. Try clearing the cache, then try again.'])
     
     load_invariant;
     return
end
    
% The signature-dependent file doesn't exist for the given algebra, but the
% invariant file may exist (we check below). We need to create the
% descriptor and initialise the signature-dependent fields.

% To avoid the need for type conversions all over the place wherever the
% signature is used, we store it as uint16. 2^16 = 65536, which is the
% current theoretical implementation limit on the number of elements in a
% multivector. m has to be stored as uint32 in order to permit the value
% 65536, when n = 16 (which is the largest possible value for n), because
% the range of values in a uint16 is 0 to 65535.

clifford_descriptor.signature = pqr;
clifford_descriptor.n = sum(pqr, 'native'); % n has class uint16.
clifford_descriptor.m = 2^uint32(clifford_descriptor.n);

% Create and store an empty multivector in the descriptor. This enables
% code in the toolbox to avoid calling the constructor to make a
% multivector, instead it can just copy this empty multivector and modify
% it, thus avoiding all the parameter checking overhead of the constructor.

clifford_descriptor.empty = clifford(); % This must be a call to the
                                        % constructor and not to
                                        % clifford.empty to avoid a
                                        % circularity.

% We cannot initialise the sign here, because clifford_sign requires the
% index_table field in the descriptor, so we need to defer this until the
% index table has been loaded or initialised.

% Now we can check whether the invariant file exists, and if so load its
% data, if not, create the data and write the file.
    
if exist(invariant_filename, 'file') == 2
    load_invariant;
else
    % The invariant file does not exist, so we must create the data and
    % write it to a file.
    
    % Compute the index tables and strings. For a description, see the
    % function that computes them (clifford_lexical_index_mapping).
    
    [clifford_descriptor.index_table, ...
     clifford_descriptor.reverse_index_table, ...
     clifford_descriptor.index_strings] = ...
     clifford_lexical_index_mapping(clifford_descriptor.n);
    
    % Calculate the grade table, which indicates which parts of the
    % multivector are included for each grade. The rows correspond to the
    % grades, and the columns correspond to the indexing of the multivector
    % itself, which is lexical, e.g. e0 e1 e2 e3 e12 e13 e23 e123. The
    % tablel is a Boolean array containing true where the n-th grade has a
    % null multivector element, that is, the logical values in the table
    % indicate by TRUE which elements of the multivector are NOT included
    % in the grade represented by a given row.
    
    clifford_descriptor.grade_table = true(clifford_descriptor.n + 1, ...
                                           clifford_descriptor.m);
    index = uint32(0); % The second index of the grade table must reach
                       % 65536 which requires uint32 in the case n = 16.
    for grade = 0:clifford_descriptor.n
        N = uint32(nchoosek(clifford_descriptor.n, grade));
        clifford_descriptor.grade_table(grade + 1, ...
                                        index + 1:index + N) = false;
        index = index + N;
    end

    % In version 1.6 of the toolbox, a change was made to the index table,
    % which is now stored in the descriptor only for algebras of smaller
    % sizes. For larger algebras, the index is computed dynamically as
    % needed in the multiplication functions, and a small number of other
    % functions. We initialise the index field to empty first, before we
    % test and call clifford_index, so that the field can be assumed to
    % exist in clifford_index.
    
    clifford_descriptor.index = uint16.empty;
    
    if clifford_descriptor.n <= 10
        clifford_descriptor.index = ...
        clifford_index(1:clifford_descriptor.m, 1:clifford_descriptor.m);
    end
    
    % Now we have initialised all the fields that are invariant to the
    % signature, we can write them to file.
    
    save(invariant_filename, '-struct', 'clifford_descriptor', ...
                             'index_table', 'reverse_index_table', ...
                             'index_strings', 'grade_table', 'index');
end

% Now that the necessary fields (index_table and n) are initialised, we can
% create the sign table. In version 1.6 of the toolbox, a change was made
% to the sign table, which is now stored in the descriptor only for
% algebras of smaller sizes. For larger algebras, the sign is computed
% dynamically as needed in the multiplication functions, and a small number
% of other functions. This change was made to reduce the size of the
% descriptor cache, and speed up the initialisation of large algebras (at
% the expense of course of slower computation with them). We initialise the
% sign field before calling clifford_sign, so that the code in
% clifford_sign can assume that the field exists.

clifford_descriptor.sign = int8.empty;

if clifford_descriptor.n <= 10
    clifford_descriptor.sign = clifford_sign(1:clifford_descriptor.m, ...
                                             1:clifford_descriptor.m);
end

% Finally, we can now write the signature dependent fields from the
% descriptor to file.
 
save(dependent_filename, '-struct', 'clifford_descriptor', ...
                         'signature', 'n', 'm', 'empty', 'sign');
                     
    function load_invariant
        % Nested function to read in the invariant file and copy its data
        % to the descriptor. This is needed more than once in the code
        % above, which is why it is written as a nested function.
        
        % Load the contents of the invariant file and copy the fields into
        % the descriptor. Note that index may be empty for larger algebras.
        
        temp = load(invariant_filename);
        
        % The code below for copying the structure fields with a loop is
        % from: Matlab Central answers 229604 by 'Guillaume' 13 Jul 2015.
        
        for f = fieldnames(temp).'
            field = f{1};
            clifford_descriptor.(field) = temp.(field);
        end
        
        % TODO temp will be destroyed on return, but we could consider
        % clearing the fields of temp as we copy them across to the
        % descriptor to reduce memory footprint (but this will take more
        % time).
        
    end

end

function diagnostic
% Output some diagnostic information.
% TODO To be expanded to include other information cf CLICAL.

global clifford_descriptor;

if clifford_descriptor.signature(3) == 0
    disp(['Algebra Cl(' num2str(clifford_descriptor.signature(1)), ',' ...
                        num2str(clifford_descriptor.signature(2)), ')']);
else
    disp(['Algebra Cl(' num2str(clifford_descriptor.signature(1)), ',' ...
                        num2str(clifford_descriptor.signature(2)), ',' ...
                        num2str(clifford_descriptor.signature(3)), ')']);
end

disp(['Dimensionality:   ', num2str(clifford_descriptor.m)])
disp(['Number of grades: ', num2str(size(clifford_descriptor.grade_table, 1))])
disp('Multiplication table:')
if clifford_descriptor.m > 64
    disp('Too large to output to command window')
else
    disp(clifford_multiplication_table)
end

end

% $Id: clifford_signature.m 268 2021-07-11 17:17:54Z sangwine $