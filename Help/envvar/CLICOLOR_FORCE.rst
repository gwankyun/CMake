CLICOLOR_FORCE
--------------

.. versionadded:: 3.5

.. include:: include/ENV_VAR.rst

将其设置为除\ ``0``\ 之外的非空值，可告知命令行工具，即使未连接到终端也打印彩色消息。这是一般\
命令行工具中的一种\ `常见约定`_。

See also the :envvar:`NO_COLOR` and :envvar:`CLICOLOR` environment variables.
If :envvar:`NO_COLOR` is activated, it takes precedence over
:envvar:`!CLICOLOR_FORCE`.  Otherwise, if :envvar:`!CLICOLOR_FORCE` is
activated, it takes precedence over :envvar:`CLICOLOR`.

See the :variable:`CMAKE_COLOR_DIAGNOSTICS` variable to control
color in a generated build system.

.. _`常见约定`: https://web.archive.org/web/20250410160803/https://bixense.com/clicolors/
