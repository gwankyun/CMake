HEADER_SETS
-----------

.. versionadded:: 3.23

目标的\ ``PRIVATE``\ 和\ ``PUBLIC``\ 头集的只读列表（即所有类型为\ ``HEADERS``\ 的文\
件集）。出于IDE集成的目的，这些文件集中列出的文件被视为源文件。这些文件的\
:prop_sf:`HEADER_FILE_ONLY`\ 属性也被设置为\ ``TRUE``。

Header sets may be defined using the :command:`target_sources` command
``FILE_SET`` option with type ``HEADERS``.

See also :prop_tgt:`HEADER_SET_<NAME>`, :prop_tgt:`HEADER_SET` and
:prop_tgt:`INTERFACE_HEADER_SETS`.
