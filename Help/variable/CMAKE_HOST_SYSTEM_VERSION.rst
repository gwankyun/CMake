CMAKE_HOST_SYSTEM_VERSION
-------------------------

当前运行CMake的操作系统版本。

A numeric version string for the system.  On systems that support
``uname``, this variable is set to the output of ``uname -r``. On other
systems this is set to major-minor version numbers.
