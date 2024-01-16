CMAKE_AUTOGEN_VERBOSE
---------------------

.. versionadded:: 3.13

设置\ :prop_tgt:`AUTOMOC`、\ :prop_tgt:`AUTOUIC`\ 和\ :prop_tgt:`AUTORCC`\ 的篇幅。\
正整数值或真布尔值允许\ ``AUTO*``\ 生成器输出额外的处理信息。

Setting ``CMAKE_AUTOGEN_VERBOSE`` has the same effect
as setting the ``VERBOSE`` environment variable during
generation (e.g. by calling ``make VERBOSE=1``).
The extra verbosity is limited to the ``AUTO*`` generators though.

By default ``CMAKE_AUTOGEN_VERBOSE`` is unset.
