TEST_LAUNCHER
-------------

.. versionadded:: 3.29

使用给定的启动器来运行可执行文件。该命令将作为前缀添加到用于构建目标系统可执行文件的\
:command:`add_test`\ 命令中，并打算在主机上运行。

It effectively acts as a run script for tests in a similar way
to how :variable:`CMAKE_<LANG>_COMPILER_LAUNCHER` works for compilation.

If this property contains a :ref:`semicolon-separated list <CMake Language
Lists>`, then the first value is the command and remaining values are its
arguments.

Contents of ``TEST_LAUNCHER`` may use
:manual:`generator expressions <cmake-generator-expressions(7)>`.

This property is initialized by the value of the
:variable:`CMAKE_TEST_LAUNCHER` variable if it is set when a target
is created.
