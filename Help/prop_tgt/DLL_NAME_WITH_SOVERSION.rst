DLL_NAME_WITH_SOVERSION
-----------------------

.. versionadded:: 3.27

该属性控制是否将\ :prop_tgt:`SOVERSION`\ 目标属性添加到为Windows平台生成的DLL文件名中，\
该属性在设置\ :variable:`WIN32`\ 变量时选择。

The value of the listed property is appended to the
basename of the runtime component of the shared library
target as ``-<SOVERSION>``.

Please note that setting this property has no effect
if versioned filenames are globally disabled with the
:variable:`CMAKE_PLATFORM_NO_VERSIONED_SONAME` variable.
