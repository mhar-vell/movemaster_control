% Test script for the Clifford Toolbox for Matlab.

% Copyright (c) 2015  Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% This script runs a series of test functions, each designed to test one
% or more functions in the toolbox. No errors should be generated and the
% script should run to completion. The first functions run are designed to
% verify the installation and environment before running the tests proper.

type([clifford_root filesep 'Contents.m'])
disp(' ')

test_version;
test_path;

% Output some diagnostic information about where the test code is running
% from, for use in diagnosing problems reported by users who may have paths
% and so on set up incorrectly.

v = ver('clifford');
disp(['Toolbox version number reported as: ', v.Version])
clear v
disp(['Toolbox root directory reported as: ', clifford_root])
disp(['Running test code from directory:   ', pwd])

% For some reason the pwd function returns a filename with changed case in
% some cases. Using strcmpi makes the comparison case-insensitive. If the
% reason for the change of case in the pwd result can be found, and fixed,
% this could revert to strcmp (case-sensitive).
if strcmpi(pwd, [clifford_root, filesep, 'test']) == 0
    error('Test code is not running from the clifford root/test directory.')
end

disp(' ')

% Now run the tests. We have to test the toolbox for multiple algebras, and
% we run the same set of tests for every algebra. If any tests are written
% that cannot work for certain algebras this scheme will have to be modified,
% perhaps to make running the test conditional on the parameters of the
% algebra.

% Define a list of algebras to be tested. Each row in the table is a triple
% of p, q, r values, used to initialise an algebra before running tests on
% it.

algebras = [0,0,0; ...
            1,0,0; ...
            0,1,0; ... % Two grades
            %
            0,2,0; ... % Three grades
            2,0,0; ...
            1,1,0; ...
            %
            0,3,0; ... % Four grades
            2,1,0; ...
            %
            0,4,0; ... % Five grades
            2,2,0;
            %
            0,5,0; ... % Six grades
            1,4,0; ...
            %
            0,6,0; ... % Seven grades
            4,2,0; ...
            %
            0,7,0; ... % Eight grades
            7,0,0; ...
            %
            0,8,0; ... % Nine grades
            %
            1,1,1; ... % Now some with blades that square to 0
            2,2,1; ...
            1,1,2; ...
            1,0,2; ...
            %
            5,6,0; ... % The remaining tests take a long time. TODO.
            6,6,1  ...
                ];

tic;

% TODO Work out what happens when an error occurs in one of the tests. It
% looks like the parallel worker hangs until the others have finished. Is
% there a better way to stop the process on error, without the wait?

parfor row = 1:size(algebras, 1)
    clifford_signature(algebras(row, :));
    tdisp('Starting tests')
    test_fundamentals;
    test_subsasgn;
    test_multiplication_table(false);
    test_scalar_product;
    test_wedge_product;
    test_contractions;
    test_power;
    test_exp;
    test_expm;
    test_lu;
    test_inverses;
    test_matfuns;
    test_isomorphisms;
    test_involutions;
    test_sqrt;
    test_sqrtm;
    tdisp('Completed tests')
end

toc

clear algebras

disp('All tests completed without error.')

% TODO Update this to check for v1, v2 etc. when the current cache version
% is greater than v2.

cache = [clifford_root filesep 'cache' filesep, 'v1'];

if exist(cache, 'dir')
    warning(['Cache directory/folder ', cache, ' exists but is no' ...
             ' longer used by the toolbox. You can safely delete it.'])
end

% $Id: test.m 289 2021-07-30 18:56:20Z sangwine $
