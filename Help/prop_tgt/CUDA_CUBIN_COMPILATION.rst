CUDA_CUBIN_COMPILATION
----------------------

.. versionadded:: 3.27

将CUDA源编译为\ ``.cubin``\ 文件，而不是\ :ref:`Object Libraries`\ 中的\ ``.obj``\
文件。

For example:

.. code-block:: cmake

  add_library(mycubin OBJECT a.cu b.cu)
  set_property(TARGET mycubin PROPERTY CUDA_CUBIN_COMPILATION ON)
