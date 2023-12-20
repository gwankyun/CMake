CMAKE_SOURCE_DIR
----------------

到源代码树顶层的路径。

This is the full path to the top level of the current CMake source
tree.  For an in-source build, this would be the same as
:variable:`CMAKE_BINARY_DIR`.

When run in :option:`cmake -P` script mode, CMake sets the variables
:variable:`CMAKE_BINARY_DIR`, ``CMAKE_SOURCE_DIR``,
:variable:`CMAKE_CURRENT_BINARY_DIR` and
:variable:`CMAKE_CURRENT_SOURCE_DIR` to the current working directory.
