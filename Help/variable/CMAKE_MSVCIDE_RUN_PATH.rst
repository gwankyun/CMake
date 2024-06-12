CMAKE_MSVCIDE_RUN_PATH
----------------------

.. versionadded:: 3.10

在使用\ :generator:`Visual Studio 12 2013` （或更高版本）生成器时，在执行\
:command:`add_custom_command`\ 或\ :command:`add_custom_target`\ 时应该使用的额外\
PATH位置。这允许运行命令和使用IDE环境不知道的dll。

If not set explicitly the value is initialized by the ``CMAKE_MSVCIDE_RUN_PATH``
environment variable, if set, and otherwise left empty.
