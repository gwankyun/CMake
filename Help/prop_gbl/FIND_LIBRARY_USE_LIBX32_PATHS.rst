FIND_LIBRARY_USE_LIBX32_PATHS
-----------------------------

.. versionadded:: 3.9

:command:`find_library`\ 命令是否自动搜索\ ``libx32``\ 目录。

``FIND_LIBRARY_USE_LIBX32_PATHS`` is a boolean specifying whether the
:command:`find_library` command should automatically search the ``libx32``
variant of directories called ``lib`` in the search path when building
x32-abi binaries.

See also the :variable:`CMAKE_FIND_LIBRARY_CUSTOM_LIB_SUFFIX` variable.
