CMAKE_<LANG>_ARCHIVER_WRAPPER_FLAG_SEP
--------------------------------------

.. versionadded:: 4.0

此变量与\ :variable:`CMAKE_<LANG>_ARCHIVER_WRAPPER_FLAG`\ 变量配合使用，用于格式化\
静态库选项中的\ ``ARCHIVER:``\ 前缀（参见\ :prop_tgt:`STATIC_LIBRARY_OPTIONS`）。

When specified, arguments of the ``ARCHIVER:`` prefix will be concatenated
using this value as separator.
