CMAKE_CUDA_RUNTIME_LIBRARY
--------------------------

.. versionadded:: 3.17

选择编译和链接CUDA时使用的CUDA运行库。该变量用于在创建所有目标时初始化\
:prop_tgt:`CUDA_RUNTIME_LIBRARY`\ 属性。

The allowed case insensitive values are:

.. include:: ../prop_tgt/CUDA_RUNTIME_LIBRARY-VALUES.txt

Contents of ``CMAKE_CUDA_RUNTIME_LIBRARY`` may use
:manual:`generator expressions <cmake-generator-expressions(7)>`.

If this variable is not set then the :prop_tgt:`CUDA_RUNTIME_LIBRARY` target
property will not be set automatically.  If that property is not set then
CMake uses an appropriate default value based on the compiler to select the
CUDA runtime library.

.. note::

  This property has effect only when the ``CUDA`` language is enabled. To
  control the CUDA runtime linking when only using the CUDA SDK with the
  ``C`` or ``C++`` language we recommend using the :module:`FindCUDAToolkit`
  module.
