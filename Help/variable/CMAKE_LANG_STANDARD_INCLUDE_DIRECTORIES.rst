CMAKE_<LANG>_STANDARD_INCLUDE_DIRECTORIES
-----------------------------------------

.. versionadded:: 3.6

``<LANG>``\ 编译器编译的每个源文件所使用的包含目录。这意味着当前平台的语言所需的系统包含\
目录的规范。这些目录总是出现在传递给编译器的include路径的末尾。

This variable should not be set by project code.  It is meant to be set by
CMake's platform information modules for the current toolchain, or by a
toolchain file when used with :variable:`CMAKE_TOOLCHAIN_FILE`.

See also :variable:`CMAKE_<LANG>_STANDARD_LIBRARIES`.
