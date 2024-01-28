CMAKE_<LANG>_ANDROID_TOOLCHAIN_PREFIX
-------------------------------------

.. versionadded:: 3.7

当\ :ref:`Cross Compiling for Android`\ 时，这个变量包含绝对值路径前缀工具链GNU编译器\
和它的二进制程序。

See also :variable:`CMAKE_<LANG>_ANDROID_TOOLCHAIN_SUFFIX`
and :variable:`CMAKE_<LANG>_ANDROID_TOOLCHAIN_MACHINE`.

For example, the path to the linker is::

  ${CMAKE_CXX_ANDROID_TOOLCHAIN_PREFIX}ld${CMAKE_CXX_ANDROID_TOOLCHAIN_SUFFIX}
