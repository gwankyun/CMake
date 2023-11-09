INTERFACE_CXX_MODULE_SETS
-------------------------

.. versionadded:: 3.28

目标的\ ``PUBLIC`` C++模块集的只读列表（即所有类型为\ ``CXX_MODULES``\ 的文件集）。这些\
C++模块集中列出的文件可以用\ :command:`install(TARGETS)`\ 安装，用\
:command:`install(EXPORT)`\ 和\ :command:`export`\ 导出。

C++ module sets may be defined using the :command:`target_sources` command
``FILE_SET`` option with type ``CXX_MODULES``.

See also :prop_tgt:`CXX_MODULE_SETS`.
