CMAKE_<LANG>_ANDROID_TOOLCHAIN_MACHINE
--------------------------------------

.. versionadded:: 3.7.1

当\ :ref:`Cross Compiling for Android`\ 时，这个变量包含工具链binutils的机器名（例如\
``gcc -dumpmachine``）。二进制程序的名称上通常有一个\ ``<machine>-``\ 前缀。

See also :variable:`CMAKE_<LANG>_ANDROID_TOOLCHAIN_PREFIX`
and :variable:`CMAKE_<LANG>_ANDROID_TOOLCHAIN_SUFFIX`.
