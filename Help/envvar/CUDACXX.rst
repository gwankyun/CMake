CUDACXX
-------

.. versionadded:: 3.8

.. include:: ENV_VAR.txt

编译\ ``CUDA``\ 语言文件的首选可执行文件。将仅由CMake在第一次配置中使用，以确定\ ``CUDA``\
编译器，之后\ ``CUDA``\ 的值存储在缓存中作为\
:variable:`CMAKE_CUDA_COMPILER <CMAKE_<LANG>_COMPILER>`。对于任何配置运行（包括第一\
次），如果定义了\ :variable:`CMAKE_CUDA_COMPILER <CMAKE_<LANG>_COMPILER>`\ 变量，则\
环境变量将被忽略。

.. note::
  Options that are required to make the compiler work correctly can be included;
  they can not be changed.

.. code-block:: console

  $ export CUDACXX="custom-compiler --arg1 --arg2"
