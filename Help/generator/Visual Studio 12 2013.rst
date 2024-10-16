Visual Studio 12 2013
---------------------

移除。这个生成器曾经生成过Visual Studio 12 2013项目文件，但是从CMake 3.31开始，这个生成\
器就被删除了。使用\ :generator:`Visual Studio 14 2015`\ （或更高版本）生成器，将\
:variable:`CMAKE_GENERATOR_TOOLSET`\ 设置为\ ``v120``，或者使用\
:generator:`NMake Makefiles`\ 生成器，仍然可以使用VS 12 2013工具进行构建。
