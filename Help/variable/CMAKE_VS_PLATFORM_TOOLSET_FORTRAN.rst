CMAKE_VS_PLATFORM_TOOLSET_FORTRAN
---------------------------------

.. versionadded:: 3.29

Visual Studio项目使用的Fortran编译器。

:ref:`Visual Studio Generators` support selecting among Fortran compilers
whose Visual Studio Integration is installed.  The compiler may be specified
by a field in :variable:`CMAKE_GENERATOR_TOOLSET` of the form ``fortran=...``.
CMake provides the selected Fortran compiler in this variable.
The value may be empty if the field was not specified.
