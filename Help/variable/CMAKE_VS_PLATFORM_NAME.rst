CMAKE_VS_PLATFORM_NAME
----------------------

.. versionadded:: 3.1

当前生成器使用的Visual Studio目标平台名称。

VS 8 and above allow project files to specify a target platform.
CMake provides the name of the chosen platform in this variable.
See the :variable:`CMAKE_GENERATOR_PLATFORM` variable for details.

See also the :variable:`CMAKE_VS_PLATFORM_NAME_DEFAULT` variable.
