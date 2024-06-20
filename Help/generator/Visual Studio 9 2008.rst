Visual Studio 9 2008
--------------------

移除。这个生成器曾经生成过Visual Studio 9 2008的项目文件，但是从CMake 3.30开始，这个\
生成器就被删除了。使用\ :generator:`Visual Studio 14 2015`\ 生成器（或更高版本，并且还\
安装了VS 10 2010）将\ :variable:`CMAKE_GENERATOR_TOOLSET`\ 设置为\ ``v90``，或者使用\
:generator:`NMake Makefiles`\ 生成器，仍然可以使用VS 9 2008工具进行构建。
