function test_version
% Test code to verify the Matlab or GNU Octave version.

% Copyright (c) 2015, 2021 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% Notes on versions needed.

M = 9; % These are the minimum supported major and minor Matlab
N = 5; % version numbers (R2018b).

disp('Checking Matlab version ...');

V = ver('Matlab'); % This gets a structure containing information about the
                   % Matlab version, if we are running under Matlab. If we
                   % are not, the result will be empty.
if ~isempty(V)

    S = V.Version; % This gets and displays a string containing the Matlab
    disp(S);       % version. S starts with 7.7, 8.1 or 7.10 or similar.
    
    E = ['Matlab version must be ' num2str(M) '.' num2str(N) ' or later'];
    
    Dots = strfind(S, '.'); % Find the positions of the dots in the string.
    
    Major = str2double(S(1:Dots(1)-1));
    if length(Dots) == 1
        Minor = str2double(S(Dots(1) + 1:end));
    else
        Minor = str2double(S(Dots(1) + 1:Dots(2) - 1));
        % We ignore the sub-minor version if present. (e.g. 1 in 7.10.1).
    end
    
    if Major < M
        error(['Versions of Matlab earlier than ' num2str(M), ...
               ' are not supported.'])
    end
    
    if Major == M && Minor < N
        error(['Matlab version must be ' ...
               num2str(M) '.' num2str(N) ' or later.']);
    end
    
    % Otherwise Major must be greater than M and we are OK, without
    % checking the minor version.
    
    disp('Matlab version is OK');

else
    
    disp('Not running under Matlab, checking for Octave ...');
    
    V = ver('Octave');
    if isempty(V)
        error('Not running under Matlab or Octave, giving up!');
    end
    
    disp('Running under Octave. This is not yet supported or tested')

end

% $Id: test_version.m 276 2021-07-14 17:28:04Z sangwine $
