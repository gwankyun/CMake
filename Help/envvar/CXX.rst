CXX
---

.. include:: ENV_VAR.txt

编译\ ``CXX``\ 语言文件的首选可执行文件。只有CMake在第一次配置时使用它来确定\ ``CXX``\
编译器，之后\ ``CXX``\ 的值存储在缓存中为\
:variable:`CMAKE_CXX_COMPILER <CMAKE_<LANG>_COMPILER>`。对于任何配置运行（包括第一次），\
如果定义了\ :variable:`CMAKE_CXX_COMPILER <CMAKE_<LANG>_COMPILER>`\ 变量，则环境变\
量将被忽略。

.. note::
  Options that are required to make the compiler work correctly can be included;
  they can not be changed.

.. code-block:: console

  $ export CXX="custom-compiler --arg1 --arg2"
