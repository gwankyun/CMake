CMAKE_PARENT_LIST_FILE
----------------------

包含当前文件的CMake文件的完整路径。

While processing a CMake file loaded by :command:`include` or
:command:`find_package` this variable contains the full path to the file
including it.

While processing a ``CMakeLists.txt`` file, even in subdirectories,
this variable has the same value as :variable:`CMAKE_CURRENT_LIST_FILE`.
While processing a :option:`cmake -P` script, this variable is not defined
in the outermost script.

See also :variable:`CMAKE_CURRENT_LIST_FILE`.
