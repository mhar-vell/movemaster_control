function clifford_helpdb
% CLIFFORD_HELPDB  Update or build Clifford help database.
%
% Copyright © 2016 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

% This function creates or rebuilds a searchable database of the Clifford
% documentation. Since this database works only with the version of Matlab
% that was used to build it, it is not sensible to distribute the database
% with the toolbox.

% TODO Consider whether there could be a way to invoke this from the test
% code, if the database does not exist, or from some sort of installation
% script (not currently provided for Clifford because there is nothing for
% such a script to do).

builddocsearchdb([clifford_root filesep 'helpfiles'])

end

% $Id: clifford_helpdb.m 270 2021-07-11 19:42:06Z sangwine $
