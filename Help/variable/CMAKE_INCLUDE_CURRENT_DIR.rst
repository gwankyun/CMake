CMAKE_INCLUDE_CURRENT_DIR
-------------------------

自动将当前源代码和构建目录添加到包含路径。

If this variable is enabled, CMake automatically adds
:variable:`CMAKE_CURRENT_SOURCE_DIR` and :variable:`CMAKE_CURRENT_BINARY_DIR`
to the include path for each directory.  These additional include
directories do not propagate down to subdirectories.  This is useful
mainly for out-of-source builds, where files generated into the build
tree are included by files located in the source tree.

By default ``CMAKE_INCLUDE_CURRENT_DIR`` is ``OFF``.
