CUDA_OPTIX_COMPILATION
----------------------

.. versionadded:: 3.27

将CUDA源编译为\ ``.optixir``\ 文件，而不是\ :ref:`Object Libraries`\ 中的\ ``.obj``\
文件。

For example:

.. code-block:: cmake

  add_library(myoptix OBJECT a.cu b.cu)
  set_property(TARGET myoptix PROPERTY CUDA_OPTIX_COMPILATION ON)
