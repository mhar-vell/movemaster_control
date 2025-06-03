% Script to process XML help files into HTML. This script can be invoked
% from the Matlab Start button (via the function clifford_helpup).

% Based on the file of the same name in the Quaternion Toolbox for Matlab.

% Copyright (c) 2008 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

Files = dir('xmlfiles/*.xml'); % Entries in the name field of this struct
                               % will be of the form 'functionname.xml'.

N = length(Files);

S = 'xmlfiles/cliffunction.xsl';

h = waitbar(0, 'Processing XML to HTML helpfiles ...');

for i = 1:N
    waitbar(i/N, h)
    
    F = Files(i).name;
    
    % end-4 strips the characters '.xml' from the end of the filename.
    xslt(['xmlfiles/', F], S, [F(1:end-4), '.html']);
end

close(h)

% $Id: process.m 208 2019-04-29 17:14:51Z sangwine $
