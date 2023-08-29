ISPC
-------

.. versionadded:: 3.19

.. include:: ENV_VAR.txt

编译\ ``ISPC``\ 语言文件的首选可执行文件。只在CMake第一次配置时使用它来确定\ ``ISPC``\
编译器，之后\ ``ISPC``\ 的值存储在缓存中为\
:variable:`CMAKE_ISPC_COMPILER <CMAKE_<LANG>_COMPILER>`。对于任何配置运行（包括第一\
次），如果定义了\ :variable:`CMAKE_ISPC_COMPILER <CMAKE_<LANG>_COMPILER>`\ 变量，则\
环境变量将被忽略。
