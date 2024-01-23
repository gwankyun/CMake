CMAKE_SHARED_LIBRARY_ENABLE_EXPORTS
-----------------------------------

.. versionadded:: 3.27

指定共享库是否生成导入文件。

This variable is used to initialize the :prop_tgt:`ENABLE_EXPORTS` target
property for shared library targets when they are created by calls to the
:command:`add_library` command.  See the property documentation for details.
