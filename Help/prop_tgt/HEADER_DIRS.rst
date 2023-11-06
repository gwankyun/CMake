HEADER_DIRS
-----------

.. versionadded:: 3.23

目标默认头文件集（即名称和类型为\ ``HEADERS``\ 的文件集）的基本目录列表，以分号分隔。该属\
性支持\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`。

This property is normally only set by :command:`target_sources(FILE_SET)`
rather than being manipulated directly.

See :prop_tgt:`HEADER_DIRS_<NAME>` for the list of base directories in
other header sets.
