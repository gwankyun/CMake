CUDA_RUNTIME_LIBRARY
--------------------

.. versionadded:: 3.17

选择针对CUDA语言的编译器使用的CUDA运行时库。

The allowed case insensitive values are:

.. include:: CUDA_RUNTIME_LIBRARY-VALUES.txt

Contents of ``CUDA_RUNTIME_LIBRARY`` may use
:manual:`generator expressions <cmake-generator-expressions(7)>`.

If that property is not set then CMake uses an appropriate default
value based on the compiler to select the CUDA runtime library.

.. note::

  This property has effect only when the ``CUDA`` language is enabled. To
  control the CUDA runtime linking when only using the CUDA SDK with the
  ``C`` or ``C++`` language we recommend using the :module:`FindCUDAToolkit`
  module.
