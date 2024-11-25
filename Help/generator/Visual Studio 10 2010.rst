Visual Studio 10 2010
---------------------

移除。这个生成器曾经生成过Visual Studio 10 2010项目文件，但是从CMake 3.25开始，这个生成\
器就被删除了。通过安装VS 2015（或更高）和使用\ :generator:`Visual Studio 14 2015`\
（或更高）生成器并将\ :variable:`CMAKE_GENERATOR_TOOLSET`\ 设置为\ ``v100``，或使用\
:generator:`NMake Makefiles`\ 生成器，仍然可以使用VS 10 2010工具集进行构建。
