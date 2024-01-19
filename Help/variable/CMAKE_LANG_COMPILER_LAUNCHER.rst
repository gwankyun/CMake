CMAKE_<LANG>_COMPILER_LAUNCHER
------------------------------

.. versionadded:: 3.4

:prop_tgt:`<LANG>_COMPILER_LAUNCHER`\ 目标属性的默认值。该变量用于在创建每个目标时初始\
化其属性。只有当\ ``<LANG>``\ 是\ ``C``、\ ``CXX``、\ ``Fortran``、\ ``HIP``、\
``ISPC``、\ ``OBJC``、\ ``OBJCXX``\ 或\ ``CUDA``\ 时才会这样做。

This variable is initialized to the :envvar:`CMAKE_<LANG>_COMPILER_LAUNCHER`
environment variable if it is set.
