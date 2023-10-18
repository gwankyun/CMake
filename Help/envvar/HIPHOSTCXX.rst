HIPHOSTCXX
-----------

.. versionadded:: 3.28

.. include:: ENV_VAR.txt

使用NVIDIA CUDA编译器编译\ ``HIP``\ 语言文件时，编译主机代码的首选可执行文件。只有CMake\
在第一次配置时使用它来确定\ ``HIP``\ 主机编译器，之后\ ``HIPHOSTCXX``\ 的值存储在缓存中\
为\ :variable:`CMAKE_HIP_HOST_COMPILER <CMAKE_<LANG>_HOST_COMPILER>`。

This environment variable is primarily meant for use with projects that
enable ``HIP`` as a first-class language.

.. note::

  Ignored when using :ref:`Visual Studio Generators`.
