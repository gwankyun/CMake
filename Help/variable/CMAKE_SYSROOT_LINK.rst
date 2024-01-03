CMAKE_SYSROOT_LINK
------------------

.. versionadded:: 3.9

链接时通过\ ``--sysroot``\ 标志传递给编译器的路径。这与\ :variable:`CMAKE_SYSROOT`\
相同，但仅用于链接而不用于编译源。

This variable may only be set in a toolchain file specified by
the :variable:`CMAKE_TOOLCHAIN_FILE` variable.
