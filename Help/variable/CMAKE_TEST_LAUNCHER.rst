CMAKE_TEST_LAUNCHER
-------------------

.. versionadded:: 3.29

这个变量用于在创建可执行目标时初始化它们的\ :prop_tgt:`TEST_LAUNCHER`\ 目标属性。它用于\
指定启动器，用于运行由\ :command:`add_test`\ 命令添加的运行可执行目标测试。

If this variable contains a :ref:`semicolon-separated list <CMake Language
Lists>`, then the first value is the command and remaining values are its
arguments.

This variable can be initialized via an
:envvar:`CMAKE_TEST_LAUNCHER` environment variable.
