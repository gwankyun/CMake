CMAKE_EXECUTABLE_ENABLE_EXPORTS
-------------------------------

.. versionadded:: 3.27

指定可执行文件是否为可加载模块导出符号。

This variable is used to initialize the :prop_tgt:`ENABLE_EXPORTS` target
property for executable targets when they are created by calls to the
:command:`add_executable` command.  See the property documentation for details.

This variable supersede the :variable:`CMAKE_ENABLE_EXPORTS` variable.
