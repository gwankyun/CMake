AUTOGEN_COMMAND_LINE_LENGTH_MAX
-------------------------------

.. versionadded:: 3.29

autogen目标的命令行长度限制，即\ ``moc``\ 或\ ``uic``，触发在Windows上使用响应文件，\
而不是将所有参数传递给命令行。

- An empty (or unset) value sets the limit to 32000
- A positive non zero integer value sets the exact command line length
  limit.

By default ``AUTOGEN_COMMAND_LINE_LENGTH_MAX`` is initialized from
:variable:`CMAKE_AUTOGEN_COMMAND_LINE_LENGTH_MAX`.

See the :manual:`cmake-qt(7)` manual for more information on using CMake
with Qt.
