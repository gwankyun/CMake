CMAKE_TOOLCHAIN_FILE
--------------------

提供给\ :manual:`cmake(1)`\ 的工具链文件的路径。

This variable is specified on the command line when cross-compiling with CMake.
It is the path to a file which is read early in the CMake run and which
specifies locations for compilers and toolchain utilities, and other target
platform and compiler related information.

Relative paths are allowed and are interpreted first as relative to the
build directory, and if not found, relative to the source directory.

This is initialized by the :envvar:`CMAKE_TOOLCHAIN_FILE` environment
variable if it is set when a new build tree is first created.

See the :variable:`CMAKE_PROJECT_TOP_LEVEL_INCLUDES` variable for setting
other things not directly related to the toolchain.
