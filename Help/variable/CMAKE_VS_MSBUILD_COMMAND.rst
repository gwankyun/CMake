CMAKE_VS_MSBUILD_COMMAND
------------------------

:generator:`Visual Studio 12 2013`\ 及以上版本的生成器将此变量设置为与相应的\
Visual Studio版本一起安装的\ ``MSBuild.exe``\ 命令。

This variable is not defined by other generators even if ``MSBuild.exe``
is installed on the computer.

The :variable:`CMAKE_VS_DEVENV_COMMAND` is also provided for the
non-Express editions of Visual Studio.
See also the :variable:`CMAKE_MAKE_PROGRAM` variable.
