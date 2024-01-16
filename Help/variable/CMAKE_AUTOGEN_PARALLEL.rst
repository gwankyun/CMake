CMAKE_AUTOGEN_PARALLEL
----------------------

.. versionadded:: 3.11

使用\ :prop_tgt:`AUTOMOC`\ 和\ :prop_tgt:`AUTOUIC`\ 时启动的并行\ ``moc``\ 或\
``uic``\进程数。

This variable is used to initialize the :prop_tgt:`AUTOGEN_PARALLEL` property
on all the targets.  See that target property for additional information.

By default ``CMAKE_AUTOGEN_PARALLEL`` is unset.
