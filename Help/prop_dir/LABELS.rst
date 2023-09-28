LABELS
------

.. versionadded:: 3.10

指定与目录及其所有子目录关联的文本标签列表。这相当于在当前目录和子目录中的所有目标和测试上设置\
:prop_tgt:`LABELS`\ 目标属性和\ :prop_test:`LABELS`\ 测试属性。注意：启动器必须启用以\
向目标传播标签。

The :variable:`CMAKE_DIRECTORY_LABELS` variable can be used to initialize this
property.

The list is reported in dashboard submissions.
