CMAKE_CROSSCOMPILING_EMULATOR
-----------------------------

.. versionadded:: 3.3

这个变量只在\ :variable:`CMAKE_CROSSCOMPILING`\ 开启时使用。它应该指向主机系统上的一个\
命令，该命令可以运行为目标系统构建的可执行文件。

.. versionadded:: 3.15
  If this variable contains a :ref:`semicolon-separated list <CMake Language
  Lists>`, then the first value is the command and remaining values are its
  arguments.

.. versionadded:: 3.28
  This variable can be initialized via an
  :envvar:`CMAKE_CROSSCOMPILING_EMULATOR` environment variable.

The command will be used to run :command:`try_run` generated executables,
which avoids manual population of the ``TryRunResults.cmake`` file.

This variable is also used as the default value for the
:prop_tgt:`CROSSCOMPILING_EMULATOR` target property of executables.  However,
while :manual:`generator expressions <cmake-generator-expressions(7)>` are
supported by the target property (since CMake 3.29), they are *not* supported
by this variable's :command:`try_run` functionality.
