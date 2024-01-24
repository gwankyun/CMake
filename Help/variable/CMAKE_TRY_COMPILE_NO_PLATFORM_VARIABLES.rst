CMAKE_TRY_COMPILE_NO_PLATFORM_VARIABLES
---------------------------------------

.. versionadded:: 3.24

设置为true值，告诉\ :command:`try_compile`\ 命令不要将任何平台变量传播到测试项目中。

The :command:`try_compile` command normally passes some CMake variables
that configure the platform and toolchain behavior into test projects.
See policy :policy:`CMP0137`.  This variable may be set to disable
that behavior.
