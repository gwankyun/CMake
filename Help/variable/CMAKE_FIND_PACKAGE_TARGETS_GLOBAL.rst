CMAKE_FIND_PACKAGE_TARGETS_GLOBAL
---------------------------------

.. versionadded:: 3.24

设置为\ ``TRUE``\ 将\ :command:`find_package`\ 发现的所有\ :prop_tgt:`IMPORTED`\
目标提升到\ ``GLOBAL``\ 作用域。


Setting this to ``TRUE`` is akin to specifying ``GLOBAL``
as an argument to :command:`find_package`.
Default value is ``OFF``.
