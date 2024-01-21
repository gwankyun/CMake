CMAKE_<LANG>_LINKER_LAUNCHER
----------------------------

.. versionadded:: 3.21

:prop_tgt:`<LANG>_LINKER_LAUNCHER`\ 目标属性的默认值。该变量用于在创建每个目标时初始化\
其属性。只有当\ ``<LANG>``\ 是\ ``C``、\ ``CXX``、\ ``OBJC``\ 或\ ``OBJCXX``\ 时，\
才会这样做。

This variable is initialized to the :envvar:`CMAKE_<LANG>_LINKER_LAUNCHER`
environment variable if it is set.
