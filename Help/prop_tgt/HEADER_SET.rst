HEADER_SET
----------

.. versionadded:: 3.23

以分号分隔的目标默认头文件集列表（即名称和类型为\ ``HEADERS``\ 的文件集）。如果任何路径是\
相对的，则相对于目标的源目录计算它们。该属性支持\
:manual:`生成器表达式 <cmake-generator-expressions(7)>`。

This property is normally only set by :command:`target_sources(FILE_SET)`
rather than being manipulated directly.

See :prop_tgt:`HEADER_SET_<NAME>` for the list of files in other header sets.
