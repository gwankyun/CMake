Visual Studio 9 2008
--------------------

移除。这个生成器曾经生成过Visual Studio 9 2008的项目文件，但是从CMake 3.30开始，这个\
生成器就被删除了。  It is still possible
to build with the VS 9 2008 toolset by also installing VS 10 2010 and
VS 2015 (or above) and using the :generator:`Visual Studio 14 2015`
generator (or above) with :variable:`CMAKE_GENERATOR_TOOLSET` set to ``v90``,
or by using the :generator:`NMake Makefiles` generator.
