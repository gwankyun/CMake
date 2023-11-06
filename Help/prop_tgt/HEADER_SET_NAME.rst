HEADER_SET_<NAME>
-----------------

.. versionadded:: 3.23

目标的\ ``<NAME>``\ 头文件集中以分号分隔的文件列表，其集合类型为\ ``HEADERS``。如果任何\
路径是相对的，则相对于目标的源目录计算它们。该属性支持\
:manual:`生成器表达式 <cmake-generator-expressions(7)>`。

This property is normally only set by :command:`target_sources(FILE_SET)`
rather than being manipulated directly.

See :prop_tgt:`HEADER_SET` for the list of files in the default header set.
See :prop_tgt:`HEADER_SETS` for the file set names of all header sets.
