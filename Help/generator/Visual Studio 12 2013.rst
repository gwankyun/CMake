Visual Studio 12 2013
---------------------

移除。这个生成器曾经生成过Visual Studio 12 2013项目文件，但是从CMake 3.31开始，这个生成\
器就被删除了。  It is still possible
to build with the VS 12 2013 toolset by also installing VS 2015 (or above)
and using the :generator:`Visual Studio 14 2015` (or above) generator with
:variable:`CMAKE_GENERATOR_TOOLSET` set to ``v120``,
or by using the :generator:`NMake Makefiles` generator.
