FC
--

.. include:: ENV_VAR.txt

编译\ ``Fortran``\ 语言文件的首选可执行文件。只会被CMake在第一次配置时使用来决定\
``Fortran``\ 编译器，之后\ ``Fortran``\ 的值被存储在缓存中作为\
:variable:`CMAKE_Fortran_COMPILER <CMAKE_<LANG>_COMPILER>`。对于任何配置运行（包括\
第一次），如果定义了\ :variable:`CMAKE_Fortran_COMPILER <CMAKE_<LANG>_COMPILER>`\
变量，则环境变量将被忽略。

.. note::
  Options that are required to make the compiler work correctly can be included;
  they can not be changed.

.. code-block:: console

  $ export FC="custom-compiler --arg1 --arg2"
