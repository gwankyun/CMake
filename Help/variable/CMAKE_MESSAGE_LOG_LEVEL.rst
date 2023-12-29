CMAKE_MESSAGE_LOG_LEVEL
-----------------------

.. versionadded:: 3.17

设置后，此变量指定\ :command:`message`\ 命令使用的日志级别。有效值与\ :manual:`cmake(1)`\
程序的\ :option:`--log-level <cmake --log-level>`\ 命令行选项的有效值相同。如果设置了\
该变量并给出了\ :option:`--log-level <cmake --log-level>`\ 命令行选项，则命令行选项优先。

The main advantage to using this variable is to make a log level persist
between CMake runs.  Setting it as a cache variable will ensure that
subsequent CMake runs will continue to use the chosen log level.

Projects should not set this variable, it is intended for users so that
they may control the log level according to their own needs.

.. versionadded:: 3.25
  See the :command:`cmake_language`
  :ref:`cmake_language <query_message_log_level>` command for a way to query
  the current message logging level.
