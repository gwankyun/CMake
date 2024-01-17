CMAKE_DLL_NAME_WITH_SOVERSION
-----------------------------

.. versionadded:: 3.27

该变量用于在Windows平台的共享库目标上初始化\ :prop_tgt:`DLL_NAME_WITH_SOVERSION`\ 属性，\
该属性在设置\ :variable:`WIN32`\ 变量时选择。

See this target property for additional information.

Please note that setting this variable has no effect if versioned filenames
are globally disabled with the :variable:`CMAKE_PLATFORM_NO_VERSIONED_SONAME`
variable.
