HEADER_DIRS_<NAME>
------------------

.. versionadded:: 3.23

目标的\ ``<NAME>``\ 头文件集的基本目录列表，以分号分隔，其集类型为\ ``HEADERS``。该属性\
支持\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`。

This property is normally only set by :command:`target_sources(FILE_SET)`
rather than being manipulated directly.

See :prop_tgt:`HEADER_DIRS` for the list of base directories in the
default header set. See :prop_tgt:`HEADER_SETS` for the file set names of all
header sets.
