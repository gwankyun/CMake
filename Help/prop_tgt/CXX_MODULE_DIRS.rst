CXX_MODULE_DIRS
---------------

.. versionadded:: 3.28

目标默认C++模块集（即名称和类型为\ ``CXX_MODULES``\ 的文件集）的基本目录列表，以分号分隔。\
该属性支持\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`。

This property is normally only set by :command:`target_sources(FILE_SET)`
rather than being manipulated directly.

See :prop_tgt:`CXX_MODULE_DIRS_<NAME>` for the list of base directories in
other C++ module sets.
