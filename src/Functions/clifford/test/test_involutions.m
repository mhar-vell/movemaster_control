function test_involutions
% Test code for the clifford involution functions, and the odd/even and
% symmetric/antisymmetric functions.

% Copyright (c) 2021 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor

tdisp('Testing involutions, odd/even, anti/symmetric functions ...');

m = randm; % We test with a scalar rather than an array for speed, as the
           % functions being tested simply change signs and move elements
           % of the multivector around, and these operations would work the
           % same on arrays as they do on scalars.

% Test the dual. This is not self-inverse, instead the result of applying
% it twice is either an identity or a negation according to the sign of the
% squared pseudoscalar. However, this provides a simple but not conclusive
% test. This function cannot work when the pseudoscalar squares to zero.

s = clifford(clifford_descriptor.index_strings{end}).^2;

if s == 0
    tdisp('Skipping test of dual function, pseudoscalar squares to zero.');
else
    check(dual(dual(m)) == s .* m, 'Dual function fails test.');
end

% Test the reverse. This is defined in terms of reversing the lexical
% indices, such that e1234 becomes e4321. Since we can compute these with
% the constructor, we base this test on actually reversing the string of
% characters found in the descriptor. This also, of course, tests the code
% in the constructor that evaluates strings such as 'e4321'. However, since
% the index_strings in the descriptor are the same for any algebra of the
% same dimension, we don't need to recalculate their reversals for every
% algebra and we use persistent variables to avoid this. Note that we could
% use the same approach as is used below for the principal involution and
% the conjugate, but the merit of what we do here is that it also tests
% some other important code in the constructor.

persistent rstrings dimension

if isempty(rstrings) || dimension ~= clifford_descriptor.n   
    dimension = clifford_descriptor.n;
    rstrings = cellfun(@(x) [x(1), fliplr(x(2:end))], ...
        clifford_descriptor.index_strings, 'UniformOutput', false);
end

r = reverse(m); % Compute the reverse, then the problem becomes how to
                % check each element of r for the correct sign (no change
                % should be made to the numeric value, up to sign).

% Find out which elements of r have had their sign changed and which have
% not. We compute two logical arrays, p and n, n for negated, and p for
% positive (i.e. not negated).
                
n = cellfun('isempty', coefficients(r + m));
p = cellfun('isempty', coefficients(r - m));

index = 1:clifford_descriptor.m;

for j = index(n)
    % For these indices the reversed string should evaluate to minus the
    % unreversed string.
    if clifford(clifford_descriptor.index_strings{j}) ~= ...
      -clifford(rstrings{j})
        terror(['Reverse fails test 1 at index ', num2str(j)])
    end
end

for j = index(p)
    % For these indices the reversed string should evaluate to the same
    % value as the unreversed string.
    if clifford(clifford_descriptor.index_strings{j}) ~= ...
       clifford(rstrings{j})
        terror(['Reverse fails test 2 at index ', num2str(j)])
    end
end

% The conj function is the same thing as the clifford_conjugate. Therefore
% we can test one and verify that the other matches.

check(conj(m) == clifford_conjugate(m), ...
    'Clifford conjugate and conj do not match.');

% Test the clifford_conjugate. We use a formula given in: Guy Laville and
% Ivan Ramadanoff, 'Stone-Weierstrass Theorem', arXiv:math/0411090v2, 25
% January 2007, page 2, where they use the designation 'anti-involution'.

c = clifford_conjugate(m);

for k = 0:cast(clifford_descriptor.n, 'double') % For each grade ...
    check(grade(c, k) == (-1).^(k .* (k + 1) ./ 2) .* grade(m, k), ...
       ['Clifford conjugate fails test on grade ', num2str(k)]);
end

% Test the reverse (again) using the formula given by Laville and
% Ramadanoff (see above). This is strictly not necessary, but since it is
% just a minor change from the code above, why not? We computed the reverse
% above in r.

for k = 0:cast(clifford_descriptor.n, 'double') % For each grade ...
    check(grade(r, k) == (-1).^(k .* (k - 1) ./ 2) .* grade(m, k), ...
       ['Reverse fails test 3 on grade ', num2str(k)]);
end

% Test the grade involution. We use the same approach as for the conjugate,
% the formula is given by Laville and Ramadanoff (see above) but they call
% it the principal involution (a name which we use for a different
% involution).

p = grade_involution(m);

for k = 0:cast(clifford_descriptor.n, 'double') % For each grade ...
    check(grade(p, k) == (-1).^k .* grade(m, k), ...
       ['Grade involution fails test on grade ', num2str(k)]);
end

% The composition of the reverse and the grade involution is the same as
% the conjugate, so check this too. The composition is commutative, so we
% check both orderings.

check(reverse(grade_involution(m)) == conj(m), ...
    'Reverse composed with grade involution does not match conjugate.');
check(grade_involution(reverse(m)) == conj(m), ...
    'Grade involution composed with reverse does not match conjugate.');

% Test the symmetric and antisymmetric functions. The definitions of these
% provide the test: the sign changes or doesn't under reversion. This means
% we depend on the reverse being correct, which we checked above.

sm = symmetric(m);
am = antisymmetric(m);

check(reverse(sm) ==  sm,     'Symmetric function fails.');
check(reverse(am) == -am, 'Antisymmetric function fails.');
                                     
% Test the odd and even functions.

g = size(clifford_descriptor.grade_table, 1); % The number of grades.

om = odd(m);  % This could be empty in Cl(0,0) where there is no grade 1+.
em = even(m); % Even in Cl(0,0), this won't be empty.

if ~isempty(om)
    check(om + em == m, 'Odd/even functions fail test 1.');
end

for j = 0:2:g-1 % For even grades.
    check(grade(em, j) == grade(m, j), 'Even function fails test 2.');
    check(isempty(grade(om, j)),        'Odd function fails test 3.');
end

for j = 1:2:g-1 % For odd grades.
    check(grade(om, j) == grade(m, j),  'Odd function fails test 4.');
    check(isempty(grade(em, j)),       'Even function fails test 5.');
end

% Test the grade involution. This affects even and odd elements
% differently, so that is how we test it. We re-use a result from above
% when testing the odd function.

p = grade_involution(m);

check(even(m) == even(p) , 'Grade involution fails test 1.');
if ~isempty(om)
    check(om == -odd(p),   'Grade involution fails test 2.');
end

% Test the grade four involution (if grade 4 exists, quietly skip if not).
% The basis of this test is to check that elements of grade 4 are negated
% and all others are not.

if g > 4 % Grades start from 0 ...
    p = grade_four_involution(m);
    check(grade(p, 4) == -grade(m, 4), 'Grade 4 involution fails test 1.');
    for j = [0:3, 5:g-1] % The list of grades not including 4.
       check(grade(p, j) == grade(m, j), 'Grade 4 involution fails test 2.'); 
    end
end

tdisp('Passed');

end

% $Id: test_involutions.m 300 2021-08-12 11:05:30Z sangwine $
