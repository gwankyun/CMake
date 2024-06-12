CMAKE_VS_DEVENV_COMMAND
-----------------------

:generator:`Visual Studio 12 2013`\ 及以上版本的生成器将此变量设置为与相应的\
Visual Studio版本一起安装的\ ``devenv.com``\ 命令。注意，此变量在Visual Studio Express\
版本上可能为空，因为它们不提供此工具。

This variable is not defined by other generators even if ``devenv.com``
is installed on the computer.

The :variable:`CMAKE_VS_MSBUILD_COMMAND` is also provided for
:generator:`Visual Studio 12 2013` and above.
See also the :variable:`CMAKE_MAKE_PROGRAM` variable.
