EXPORT_FIND_PACKAGE_NAME
------------------------

.. versionadded:: 3.29

在\ :command:`install(EXPORT)`\ 或\ :command:`export(EXPORT)`\ 中导出\
:command:`find_dependency`\ 调用时，控制与依赖目标关联的包名。这可以用来为CMake构建和\
导出的包分配包名，或者在创建目标的\ :command:`find_package`\ 调用中覆盖包。

This property is initialized by :variable:`CMAKE_EXPORT_FIND_PACKAGE_NAME`.
