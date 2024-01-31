CMAKE_<LANG>_STANDARD_LIBRARIES
-------------------------------

.. versionadded:: 3.6

链接到语言\ ``<LANG>``\ 的每个可执行库和共享库中的库。这意味着对当前平台的语言所需的系统库\
进行规范。

This variable should not be set by project code.  It is meant to be set by
CMake's platform information modules for the current toolchain, or by a
toolchain file when used with :variable:`CMAKE_TOOLCHAIN_FILE`.

See also :variable:`CMAKE_<LANG>_STANDARD_INCLUDE_DIRECTORIES`.
