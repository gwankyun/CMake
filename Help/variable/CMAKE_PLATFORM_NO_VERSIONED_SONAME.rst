CMAKE_PLATFORM_NO_VERSIONED_SONAME
----------------------------------

.. versionadded:: 3.1

该变量用于全局控制是否应该将\ :prop_tgt:`VERSION`\ 和\ :prop_tgt:`SOVERSION`\ 目标\
属性用于共享库。当设置为true时，向每个共享库目标添加版本信息将被禁用。

By default this variable is set only on platforms where
CMake knows it is needed.   On other platforms, the
specified properties will be used for shared libraries.
