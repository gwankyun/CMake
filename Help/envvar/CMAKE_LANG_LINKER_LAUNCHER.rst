CMAKE_<LANG>_LINKER_LAUNCHER
----------------------------

.. versionadded:: 3.21

.. include:: ENV_VAR.txt

在链接指定语言的目标时使用的默认启动程序。只会被CMake用来初始化第一次配置时的变量。之后，它\
可以通过同名变量的缓存设置获得。对于任何配置运行（包括第一次），如果定义了\
:variable:`CMAKE_<LANG>_LINKER_LAUNCHER`\ 变量，则环境变量将被忽略。
