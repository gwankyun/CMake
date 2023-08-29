HIPCXX
------

.. versionadded:: 3.21

.. include:: ENV_VAR.txt

编译\ ``HIP``\ 语言文件的首选可执行文件。只有CMake在第一次配置时使用它来确定\ ``HIP``\
编译器，之后\ ``HIP``\ 的值存储在缓存中为\
:variable:`CMAKE_HIP_COMPILER <CMAKE_<LANG>_COMPILER>`。对于任何配置运行（包括第一\
次），如果定义了\ :variable:`CMAKE_HIP_COMPILER <CMAKE_<LANG>_COMPILER>`\ 变量，则\
环境变量将被忽略。
