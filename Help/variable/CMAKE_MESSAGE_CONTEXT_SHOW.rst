CMAKE_MESSAGE_CONTEXT_SHOW
--------------------------

.. versionadded:: 3.17

将该变量设置为true可以显示\ :command:`message`\ 命令记录的每行的上下文（有关如何指定上下\
文本身，请参阅\ :variable:`CMAKE_MESSAGE_CONTEXT`）。

This variable is an alternative to providing the ``--log-context`` option
on the :manual:`cmake <cmake(1)>` command line.  Whereas the command line
option will apply only to that one CMake run, setting
``CMAKE_MESSAGE_CONTEXT_SHOW`` to true as a cache variable will ensure that
subsequent CMake runs will continue to show the message context.

Projects should not set ``CMAKE_MESSAGE_CONTEXT_SHOW``.  It is intended for
users so that they may control whether or not to include context with messages.
