INTERFACE_HEADER_SETS
---------------------

.. versionadded:: 3.23

目标的\ ``INTERFACE``\ 和\ ``PUBLIC``\ 头文件集的只读列表（即所有类型为\ ``HEADERS``\
的文件集）。这些头文件集中列出的文件可以用\ :command:`install(TARGETS)`\ 安装，用\
:command:`install(EXPORT)`\ 和\ :command:`export`\ 导出。

Header sets may be defined using the :command:`target_sources` command
``FILE_SET`` option with type ``HEADERS``.

See also :prop_tgt:`HEADER_SETS`.
