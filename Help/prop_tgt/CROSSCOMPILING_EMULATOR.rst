CROSSCOMPILING_EMULATOR
-----------------------

.. versionadded:: 3.3

使用给定的模拟器运行交叉编译时创建的可执行文件。该命令将作为前缀添加到构建的目标系统可执行文\
件的\ :command:`add_test`、\ :command:`add_custom_command`\ 和\
:command:`add_custom_target`\ 命令中。

.. versionadded:: 3.15
  If this property contains a :ref:`semicolon-separated list <CMake Language
  Lists>`, then the first value is the command and remaining values are its
  arguments.

.. versionadded:: 3.29
  Contents of ``CROSSCOMPILING_EMULATOR`` may use
  :manual:`generator expressions <cmake-generator-expressions(7)>`.

This property is initialized by the value of the
:variable:`CMAKE_CROSSCOMPILING_EMULATOR` variable if it is set when a target
is created.
