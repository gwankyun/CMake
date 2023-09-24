FIND_LIBRARY_USE_LIB32_PATHS
----------------------------

.. versionadded:: 3.7

是否使用\ :command:`find_library`\ 命令自动搜索\ ``lib32``\ 目录。

``FIND_LIBRARY_USE_LIB32_PATHS`` is a boolean specifying whether the
:command:`find_library` command should automatically search the ``lib32``
variant of directories called ``lib`` in the search path when building 32-bit
binaries.

See also the :variable:`CMAKE_FIND_LIBRARY_CUSTOM_LIB_SUFFIX` variable.
