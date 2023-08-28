LDFLAGS
-------

.. include:: ENV_VAR.txt

将只被CMake在第一次配置时使用，以确定默认的链接器标志，之后\ ``LDFLAGS``\ 的值存储在缓存\
中为\ :variable:`CMAKE_EXE_LINKER_FLAGS_INIT`、\
:variable:`CMAKE_SHARED_LINKER_FLAGS_INIT`\ 和\
:variable:`CMAKE_MODULE_LINKER_FLAGS_INIT`。对于任何配置运行（包括第一次），如果定义\
了等价的\ ``CMAKE_<TYPE>_LINKER_FLAGS_INIT``\ 变量，则环境变量将被忽略。
