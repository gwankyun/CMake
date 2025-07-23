NO_COLOR
--------

.. versionadded:: 4.1

.. include:: include/ENV_VAR.rst

设置为非空值（但不是\ ``0``），以此告知命令行工具即便连接到终端也不要打印带颜色的消息。\
这是各类命令行工具普遍遵循的一种\ `通用惯例`_。

See also the :envvar:`CLICOLOR_FORCE` and :envvar:`CLICOLOR` environment
variables.  If :envvar:`!NO_COLOR` is activated, it takes precedence
over both of them.

See the :variable:`CMAKE_COLOR_DIAGNOSTICS` variable to control
color in a generated build system.

.. _`通用惯例`: https://web.archive.org/web/20250410160803/https://bixense.com/clicolors/
