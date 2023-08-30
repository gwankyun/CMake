OBJC
----

.. versionadded:: 3.16.7

.. include:: ENV_VAR.txt

编译\ ``OBJC``\ 语言文件的首选可执行文件。将仅由CMake在第一次配置时使用，以确定\ ``OBJC``\
编译器，之后\ ``OBJC``\ 的值存储在缓存中为\
:variable:`CMAKE_OBJC_COMPILER <CMAKE_<LANG>_COMPILER>`。对于任何配置运行（包括第一\
次），如果定义了\ :variable:`CMAKE_OBJC_COMPILER <CMAKE_<LANG>_COMPILER>`\ 变量，则\
环境变量将被忽略。

If ``OBJC`` is not defined, the :envvar:`CC` environment variable will
be checked instead.
