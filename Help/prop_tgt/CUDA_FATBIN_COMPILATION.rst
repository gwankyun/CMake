CUDA_FATBIN_COMPILATION
-----------------------

.. versionadded:: 3.27

将CUDA源编译为\ ``.fatbin``\ 文件，而不是\ :ref:`Object Libraries`\ 中的\ ``.obj``\
文件。

For example:

.. code-block:: cmake

  add_library(myfbins OBJECT a.cu b.cu)
  set_property(TARGET myfbins PROPERTY CUDA_FATBIN_COMPILATION ON)
