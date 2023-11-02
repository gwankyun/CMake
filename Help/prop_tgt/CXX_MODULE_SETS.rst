CXX_MODULE_SETS
---------------

.. versionadded:: 3.28

目标的\ ``PRIVATE``\ 和\ ``PUBLIC`` C++模块集的只读列表（即所有类型为\ ``CXX_MODULES``\
的文件集）。出于IDE集成的目的，这些文件集中列出的文件被视为源文件。

C++ module sets may be defined using the :command:`target_sources` command
``FILE_SET`` option with type ``CXX_MODULES``.

See also :prop_tgt:`CXX_MODULE_SET_<NAME>`, :prop_tgt:`CXX_MODULE_SET` and
:prop_tgt:`INTERFACE_CXX_MODULE_SETS`.
