CMAKE_<LANG>_LINKER_LAUNCHER
----------------------------

.. versionadded:: 3.21

:prop_tgt:`<LANG>_LINKER_LAUNCHER`\ 目标属性的默认值。此变量用于在每个目标创建时\
初始化该属性。仅当\ ``<LANG>``\ 为以下之一时才会执行此操作：

* ``C``

* ``CXX``

* ``CUDA``

  .. versionadded:: 4.1

* ``OBJC``

* ``OBJCXX``

* ``Fortran``

  .. versionadded:: 4.1

* ``HIP``

  .. versionadded:: 4.1

This variable is initialized to the :envvar:`CMAKE_<LANG>_LINKER_LAUNCHER`
environment variable if it is set.
