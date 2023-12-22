CMAKE_ADD_CUSTOM_COMMAND_DEPENDS_EXPLICIT_ONLY
----------------------------------------------

.. versionadded:: 3.27

:command:`add_custom_command`\ 中是否默认启用\ ``DEPENDS_EXPLICIT_ONLY``\ 选项。

This variable affects the default behavior of the :command:`add_custom_command`
command.  Setting this variable to ``ON`` is equivalent to using the
``DEPENDS_EXPLICIT_ONLY`` option in all uses of that command.

See also :variable:`CMAKE_OPTIMIZE_DEPENDENCIES`.
