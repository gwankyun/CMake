AIX_EXPORT_ALL_SYMBOLS
----------------------

.. versionadded:: 3.17

在AIX上，CMake通过设置\ :prop_tgt:`ENABLE_EXPORTS`\ 目标属性，自动从共享库和可执行文件\
导出所有符号。显式禁用此布尔属性以抑制该行为，并且默认情况下不导出符号。在这种情况下，预计该\
工程将使用其他手段来导出一些符号。

This property is initialized by the value of
the :variable:`CMAKE_AIX_EXPORT_ALL_SYMBOLS` variable if it is set
when a target is created.
