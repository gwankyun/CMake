Fortran_BUILDING_INSTRINSIC_MODULES
-----------------------------------

.. versionadded:: 3.22

指示CMake Fortran预处理器目标正在为Fortran编译器构建Fortran的内在函数。

This property is off by default and should be turned only on projects
that build a Fortran compiler. It should not be turned on for projects
that use a Fortran compiler.

Turning this property on will correctly add dependencies for building
Fortran intrinsic modules whereas turning the property off will ignore
Fortran intrinsic modules in the dependency graph as they are supplied
by the compiler itself.
