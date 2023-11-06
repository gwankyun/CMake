GHS_NO_SOURCE_GROUP_FILE
------------------------

.. versionadded:: 3.14

``ON``\ /\ ``OFF``\ 布尔值，用于控制目标的项目文件是单个文件还是多个文件。

The default behavior or when the property is ``OFF`` is to generate a project
file for the target and then a sub-project file for each source group.

When this property is ``ON`` or if :variable:`CMAKE_GHS_NO_SOURCE_GROUP_FILE`
is ``ON`` then only a single project file is generated for the target.

Supported on :generator:`Green Hills MULTI`.
