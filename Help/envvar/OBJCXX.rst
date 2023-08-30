OBJCXX
------

.. versionadded:: 3.16.7

.. include:: ENV_VAR.txt

编译\ ``OBJCXX``\ 语言文件的首选可执行文件。将仅由CMake在第一次配置时使用，以确定\
``OBJCXX``\ 编译器，之后\ ``OBJCXX``\ 的值存储在缓存中为\
:variable:`CMAKE_OBJCXX_COMPILER <CMAKE_<LANG>_COMPILER>`。对于任何配置运行（包括第\
一次），如果定义了\ :variable:`CMAKE_OBJCXX_COMPILER <CMAKE_<LANG>_COMPILER>`\ 变量，\
则环境变量将被忽略。

If ``OBJCXX`` is not defined, the :envvar:`CXX` environment variable will
be checked instead.
