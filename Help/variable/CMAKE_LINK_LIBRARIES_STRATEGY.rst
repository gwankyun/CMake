CMAKE_LINK_LIBRARIES_STRATEGY
-----------------------------

.. versionadded:: 3.31

指定在链接器命令行上对目标的直接链接依赖进行排序的策略。

If set, this variable acts as the default value for the
:prop_tgt:`LINK_LIBRARIES_STRATEGY` target property when a target is created.
Set that property directly to specify a strategy for a single target.
