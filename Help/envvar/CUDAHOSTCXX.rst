CUDAHOSTCXX
-----------

.. versionadded:: 3.8

.. include:: ENV_VAR.txt

编译\ ``CUDA``\ 语言文件时编译主机代码的首选可执行文件。将仅由CMake在第一次配置中使用，以\
确定\ ``CUDA``\ 主机编译器，之后\ ``CUDAHOSTCXX``\ 的值存储在缓存中为\
:variable:`CMAKE_CUDA_HOST_COMPILER`。此环境变量优先于\
:variable:`CMAKE_CUDA_HOST_COMPILER`。

This environment variable is primarily meant for use with projects that
enable ``CUDA`` as a first-class language.

.. note::

  Ignored when using :ref:`Visual Studio Generators`.

.. versionadded:: 3.13
  The :module:`FindCUDA`
  module will use this variable to initialize its ``CUDA_HOST_COMPILER`` setting.
