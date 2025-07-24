CMAKE_<LANG>_LINK_DEF_FILE_FLAG
-------------------------------

.. versionadded:: 4.1

用于为指定语言\ ``<LANG>``\ 的工具链创建dll时指定\ ``.def``\ 文件的链接器标志。

CMake sets this variable automatically during toolchain inspection by
calls to the :command:`project` or :command:`enable_language` commands.

If the :variable:`!CMAKE_<LANG>_LINK_DEF_FILE_FLAG` variable
is defined, it takes precedence over the language-agnostic
:variable:`CMAKE_LINK_DEF_FILE_FLAG` variable.
