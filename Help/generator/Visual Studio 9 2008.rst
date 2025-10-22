Visual Studio 9 2008
--------------------

移除。这个生成器曾经生成过Visual Studio 9 2008的项目文件，但是从CMake 3.30开始，这个\
生成器就被删除了。通过安装VS 10 2010和VS 2017（或更高），使用\
:generator:`Visual Studio 15 2017`\（或更高）生成器并且\
:variable:`CMAKE_GENERATOR_TOOLSET`\ 设置为\ ``v90``，或使用\
:generator:`NMake Makefiles`\ 生成器，仍然可以使用VS 9 2008工具集进行构建。
