CMAKE_SYSROOT_COMPILE
---------------------

.. versionadded:: 3.9

编译源文件时，在\ ``--sysroot``\ 标志中传递给编译器的路径。这与\ :variable:`CMAKE_SYSROOT`\
相同，但仅用于编译源代码而不用于链接。

This variable may only be set in a toolchain file specified by
the :variable:`CMAKE_TOOLCHAIN_FILE` variable.
