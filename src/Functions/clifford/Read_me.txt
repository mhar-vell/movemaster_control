Clifford Multivector Toolbox for Matlab - installation instructions
-------------------------------------------------------------------

To install this toolbox:

1. Unzip the distribution file. Copy or move the 'clifford' directory/folder
   to a suitable location. DO NOT CHOOSE the location where MATLAB itself
   and its toolboxes are located. When you run Matlab, it must have write
   access to the chosen folder, not just read access. This is to permit
   creation of a cache folder with files holding the multiplication tables
   for each algebra that you initialise. Secondly, the e0.m, e1. etc files
   will not be correctly found on the search path if the folder is in the
   MATLAB/toolboxes folder due to path cacheing. 

2. Set the Matlab path to include the directory/folder 'clifford'.
   This is done from the Matlab Home tab, Environment section in version 9.
   [The clifford folder must be near the top of the path, i.e.
   higher than the standard Matlab folders, otherwise the
   overloading of Matlab functions will not work.]

3. To run a test of the toolbox, type the command 'clifford_test'
   in the Matlab command window. This runs a test of many parts
   of the toolbox and will allow you to confirm that installation
   is correct. This will not work unless the path is set correctly
   (see previous point). This test takes many minutes because it tests the
   toolbox in many algebras. If you have the parallel computing toolbox,
   the tests will be run in parallel, and will complete somewhat faster,
   depending on how many processor cores you have.

4. Documentation for the toolbox is provided, and should be visible in the
   Help window provided the path has been set correctly as noted in point 2
   above. Look for the hyperlink under Supplemental Software.

   Also, the MATLAB command 'doc clifford' typed in the command window will
   produce a helpful listing of functions with help information derived
   from the source code files.

   A function clifford_helpdb is provided which will build a searchable
   database of Clifford helpfiles. This database is specific to the version
   of Matlab used to build it, which is why it is not distributed with the
   toolbox. If this database exists, searches in the Matlab documentation
   will return results from the Clifford toolbox as well as from standard
   Matlab.

5. There is a mailing list

   clifford_multivector-toolbox-releases@lists.sourceforge.net

   Subscribe to this list to receive (infrequent) email notification of new
   releases or other important information about the toolbox.

6. For TeX/LaTeX users: there is a folder within the toolbox containing
   BiBTeX records for the toolbox itself and any papers referred to in the
   source code.

Steve Sangwine
Eckhard Hitzer

March 2015
Updated June 2015
Updated July 2015
Updated November 2016
Updated April 2018
Updated July 2021

$Id: Read_me.txt 269 2021-07-11 18:16:44Z sangwine $
