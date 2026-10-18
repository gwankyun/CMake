Visual Studio 14 2015
---------------------

Removed.  This once generated Visual Studio 14 2015 project files, but
the generator has been removed since CMake 4.5.  It is still possible
to build with the VS 14 2015 toolset by also installing VS 2017 (or above)
and using the :generator:`Visual Studio 15 2017` (or above) generator with
:variable:`CMAKE_GENERATOR_TOOLSET` set to ``v140``,
or by using the :generator:`NMake Makefiles` generator.
