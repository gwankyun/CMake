CMAKE_VS_NO_COMPILE_BATCHING
----------------------------

.. versionadded:: 3.24

使用\ :ref:`Visual Studio Generators`\ 时关闭编译批处理。

This variable is used to initialize the :prop_tgt:`VS_NO_COMPILE_BATCHING`
property on all targets when they are created.  See that target property for
additional information.

Example
^^^^^^^

This shows setting the property for the target ``foo`` using the variable.

.. code-block:: cmake

  set(CMAKE_VS_NO_COMPILE_BATCHING ON)
  add_library(foo SHARED foo.cpp)
