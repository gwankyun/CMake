Visual Studio 10 2010
---------------------

移除。这个生成器曾经生成过Visual Studio 10 2010项目文件，但是从CMake 3.25开始，这个生成\
器就被删除了。使用\ :generator:`Visual Studio 12 2013`\ （或更高版本）生成器，将\
:variable:`CMAKE_GENERATOR_TOOLSET`\ 设置为\ ``v100``，或者使用\
:generator:`NMake Makefiles`\ 生成器，仍然可以构建VS 10 2010工具。
