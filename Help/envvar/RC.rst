RC
--

.. include:: ENV_VAR.txt

编译\ ``resource``\ 文件的首选可执行文件。将只被CMake在第一次配置时使用，以确定\
``resource``\ 编译器，之后\ ``RC``\ 的值存储在缓存中为\
:variable:`CMAKE_RC_COMPILER <CMAKE_<LANG>_COMPILER>`。对于任何配置运行（包括第一次\
），如果定义了\ :variable:`CMAKE_RC_COMPILER <CMAKE_<LANG>_COMPILER>`\ 变量，则环境\
变量将被忽略。

.. note::
  Options that are required to make the compiler work correctly can be included;
  they can not be changed.

.. code-block:: console

  $ export RC="custom-compiler --arg1 --arg2"
