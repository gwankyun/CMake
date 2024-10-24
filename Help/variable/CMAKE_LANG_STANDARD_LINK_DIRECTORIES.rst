CMAKE_<LANG>_STANDARD_LINK_DIRECTORIES
--------------------------------------

.. versionadded:: 3.31

为语言\ ``<LANG>``\ 所链接的每个可执行文件和库指定的链接目录。这意味着规范语言针对当前平台\
所需的系统链接目录。

This variable should not be set by project code.  It is meant to be set by
CMake's platform information modules for the current toolchain, or by a
toolchain file when used with :variable:`CMAKE_TOOLCHAIN_FILE`.

See also :variable:`CMAKE_<LANG>_STANDARD_LIBRARIES`.
