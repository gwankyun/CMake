CMAKE_STAGING_PREFIX
--------------------

此变量可以设置为交叉编译时要安装到的路径。如果\ :variable:`CMAKE_SYSROOT`\ 中的路径是只\
读的，或者应该保持原始状态，这可能很有用。

The ``CMAKE_STAGING_PREFIX`` location is also used as a search prefix
by the ``find_*`` commands. This can be controlled by setting the
:variable:`CMAKE_FIND_NO_INSTALL_PREFIX` variable.

If any ``RPATH``/``RUNPATH`` entries passed to the linker contain the
``CMAKE_STAGING_PREFIX``, the matching path fragments are replaced
with the :variable:`CMAKE_INSTALL_PREFIX`.
