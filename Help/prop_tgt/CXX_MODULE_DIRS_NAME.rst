CXX_MODULE_DIRS_<NAME>
----------------------

.. versionadded:: 3.28

目标的\ ``<NAME>`` C++模块集的基本目录列表，以分号分隔，该模块集的类型为\ ``CXX_MODULES``。\
该属性支持\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`。

This property is normally only set by :command:`target_sources(FILE_SET)`
rather than being manipulated directly.

See :prop_tgt:`CXX_MODULE_DIRS` for the list of base directories in the
default C++ module set. See :prop_tgt:`CXX_MODULE_SETS` for the file set names
of all C++ module sets.
