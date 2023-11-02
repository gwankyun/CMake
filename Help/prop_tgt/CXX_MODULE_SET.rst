CXX_MODULE_SET
--------------

.. versionadded:: 3.28

目标默认C++模块集（即名称和类型为\ ``CXX_MODULES``\ 的文件集）中以分号分隔的文件列表。如\
果任何路径是相对的，则相对于目标的源目录计算它们。该属性支持\
:manual:`生成器表达式 <cmake-generator-expressions(7)>`。

This property is normally only set by :command:`target_sources(FILE_SET)`
rather than being manipulated directly.

See :prop_tgt:`CXX_MODULE_SET_<NAME>` for the list of files in other C++
module sets.
