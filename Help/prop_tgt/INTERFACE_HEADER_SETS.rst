INTERFACE_HEADER_SETS
---------------------

.. versionadded:: 3.23

目标的\ ``INTERFACE``\ 和\ ``PUBLIC``\ 头文件集的只读列表（即所有类型为\ ``HEADERS``\
的文件集）。这些头文件集中列出的文件可以用\ :command:`install(TARGETS)`\ 安装，用\
:command:`install(EXPORT)`\ 和\ :command:`export`\ 导出。

See Also
^^^^^^^^

Related properties:

* :prop_tgt:`INTERFACE_FILE_SETS_<TYPE>`
* :prop_tgt:`FILE_SETS_<TYPE>`
* :prop_tgt:`HEADER_SETS`

Related commands:

* :command:`target_sources` to define file sets of type ``HEADERS``
