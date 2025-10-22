Visual Studio 12 2013
---------------------

移除。这个生成器曾经生成过Visual Studio 12 2013项目文件，但是从CMake 3.31开始，这个生成\
器就被删除了。通过安装VS 2017（或更高）和使用\ :generator:`Visual Studio 15 2017`\
（或更高）生成器并将\ :variable:`CMAKE_GENERATOR_TOOLSET`\ 设置为\ ``v120``，或使用\
:generator:`NMake Makefiles`\ 生成器，仍然可以使用VS 12 2013工具集进行构建。
