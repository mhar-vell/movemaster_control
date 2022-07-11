function clifford_helpup
% Update Clifford help files from XML masters.
%
% Copyright © 2008 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

current_dir = pwd;

root = [clifford_root filesep 'helpfiles'];
cd(root)
process % This is the script that actually processes the XML files.

cd(current_dir);

% This file is provided to enable refreshing of HTML help files from the
% Start menu. Master help files for Clifford functions are stored in the
% directory helpfiles/xmlfiles, and it is these files that are stored on
% the SVN repository. Whenever a SVN update is done, the HTML files must be
% regenerated from the XML masters. (This is only necessary for people who
% update from SVN, since each major release will include already-generated
% HTML files.) This code is based on that used to call the test code (q.v.
% for a more detailed rationale for its operation.)

end

% $Id: clifford_helpup.m 270 2021-07-11 19:42:06Z sangwine $
