CMAKE_AUTOMOC_DEPEND_FILTERS
----------------------------

.. versionadded:: 3.9

:variable:`CMAKE_AUTOMOC`\ 使用过滤器定义从源代码中提取文件名，作为\ ``moc``\ 文件的附加依赖项。

This variable is used to initialize the :prop_tgt:`AUTOMOC_DEPEND_FILTERS`
property on all the targets. See that target property for additional
information.

By default it is empty.
