CMAKE_<LANG>_COMPILER_LAUNCHER
------------------------------

.. versionadded:: 3.17

.. include:: ENV_VAR.txt

为指定语言使用的默认编译器启动器。只会被CMake用来初始化第一次配置时的变量。之后，它可以通过\
同名变量的缓存设置获得。对于任何配置运行（包括第一次），如果定义了\
:variable:`CMAKE_<LANG>_COMPILER_LAUNCHER`\ 变量，则环境变量将被忽略。
