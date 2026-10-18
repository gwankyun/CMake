CMAKE_<LANG>_COMPILER_LAUNCHER
------------------------------

.. versionadded:: 3.4

:prop_tgt:`<LANG>_COMPILER_LAUNCHER`\ 目标属性的默认值。该变量用于在创建每个目标时初始\
化其属性。只有当\ ``<LANG>``\ 是\ ``C``、\ ``CXX``、\ ``Fortran``、\ ``HIP``、\
``ISPC``、\ ``OBJC``、\ ``OBJCXX``、\ ``CUDA``\ 或 ``SYCL`` 时才会这样做。

.. versionchanged:: 4.5
  Added support for ``SYCL``.

  .. note::
    SYCL support is experimental and gated by ``CMAKE_EXPERIMENTAL_SYCL``.

This variable is initialized to the :envvar:`CMAKE_<LANG>_COMPILER_LAUNCHER`
environment variable if it is set.
