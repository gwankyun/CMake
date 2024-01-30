CMAKE_<LANG>_LINKER_WRAPPER_FLAG_SEP
------------------------------------

.. versionadded:: 3.13

该变量与\ :variable:`CMAKE_<LANG>_LINKER_WRAPPER_FLAG`\ 变量一起使用，用于格式化链接\
选项中的\ ``LINKER:``\ 前缀（参见\ :command:`add_link_options`\ 和\
:command:`target_link_options`）。

When specified, arguments of the ``LINKER:`` prefix will be concatenated using
this value as separator.
