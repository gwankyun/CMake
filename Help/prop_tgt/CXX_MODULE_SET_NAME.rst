CXX_MODULE_SET_<NAME>
---------------------

.. versionadded:: 3.28

目标的\ ``<NAME>``\ C++模块集中的文件列表，以分号分隔，该模块集的类型为\ ``CXX_MODULES``。\
如果任何路径是相对的，则相对于目标的源目录计算它们。该属性支持\
:manual:`生成器表达式 <cmake-generator-expressions(7)>`。

This property is normally only set by :command:`target_sources(FILE_SET)`
rather than being manipulated directly.

See :prop_tgt:`CXX_MODULE_SET` for the list of files in the default C++ module
set. See :prop_tgt:`CXX_MODULE_SETS` for the file set names of all C++ module
sets.
