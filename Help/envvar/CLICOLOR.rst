CLICOLOR
--------

.. versionadded:: 3.21

.. include:: include/ENV_VAR.rst

将其设置为\ ``0``\ 可告知命令行工具，即使连接到终端也不要打印彩色消息。这是一般命令行工具中\
的一种\ `常见约定`_。

See also the :envvar:`NO_COLOR` and :envvar:`CLICOLOR_FORCE` environment
variables.  If either of them is activated, it takes precedence over
:envvar:`!CLICOLOR`.

See the :variable:`CMAKE_COLOR_DIAGNOSTICS` variable to control
color in a generated build system.

.. _`常见约定`: https://web.archive.org/web/20250410160803/https://bixense.com/clicolors/
