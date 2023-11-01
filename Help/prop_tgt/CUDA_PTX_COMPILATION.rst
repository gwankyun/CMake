CUDA_PTX_COMPILATION
--------------------

.. versionadded:: 3.9

将CUDA源编译为\ ``.ptx``\ 文件，而不是\ :ref:`Object Libraries`\ 中的\ ``.obj``\ 文件。

For example:

.. code-block:: cmake

  add_library(myptx OBJECT a.cu b.cu)
  set_property(TARGET myptx PROPERTY CUDA_PTX_COMPILATION ON)
