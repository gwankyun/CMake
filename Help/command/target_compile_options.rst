target_compile_options
----------------------

向目标添加编译选项。

.. code-block:: cmake

  target_compile_options(<target> [BEFORE]
    <INTERFACE|PUBLIC|PRIVATE> [items1...]
    [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])

向\ :prop_tgt:`COMPILE_OPTIONS`\ 或\ :prop_tgt:`INTERFACE_COMPILE_OPTIONS`\ 目标\
属性添加选项。这些选项在编译给定的\ ``<target>``\ 时使用，该\ ``<target>``\ 必须是由\
:command:`add_executable`\ 或\ :command:`add_library`\ 等命令创建的，并且不能是\
:ref:`别名目标 <Alias Targets>`。

.. note::

  链接目标时不使用这些选项。参见\ :command:`target_link_options`\ 命令。

参数
^^^^^^^^^

如果指定\ ``BEFORE``，则内容将被添加到属性的前面，而不是被添加到后面。参见策略\
:policy:`CMP0101`，它影响在某些情况下\ ``BEFORE``\ 是否会被忽略。

``INTERFACE``、\ ``PUBLIC``\ 和\ ``PRIVATE``\ 关键字用于指定下列参数的\
:ref:`作用域 <Target Command Scope>`。\ ``PRIVATE``\ 和\ ``PUBLIC``\ 项将填充
``<target>``\ 的\ :prop_tgt:`COMPILE_OPTIONS`\ 属性。\ ``PUBLIC``\ 和\ ``INTERFACE``\
项将填充\ ``<target>``\ 的\ :prop_tgt:`INTERFACE_COMPILE_OPTIONS`\ 属性。下列参数\
指定编译选项。重复调用相同的\ ``<target>``\ 将元素按照调用的顺序添加。

.. versionadded:: 3.11
  允许在\ :ref:`导入目标 <Imported Targets>`\ 上设置\ ``INTERFACE``\ 项。

.. |command_name| replace:: ``target_compile_options``
.. include:: GENEX_NOTE.txt

.. include:: OPTIONS_SHELL.txt

See Also
^^^^^^^^

* This command can be used to add any options. However, for adding
  preprocessor definitions and include directories it is recommended
  to use the more specific commands :command:`target_compile_definitions`
  and :command:`target_include_directories`.

* For directory-wide settings, there is the command :command:`add_compile_options`.

* For file-specific settings, there is the source file property :prop_sf:`COMPILE_OPTIONS`.

* This command adds compile options for all languages in a target.
  Use the :genex:`COMPILE_LANGUAGE` generator expression to specify
  per-language compile options.

* :command:`target_compile_features`
* :command:`target_link_libraries`
* :command:`target_link_directories`
* :command:`target_link_options`
* :command:`target_precompile_headers`
* :command:`target_sources`

* :variable:`CMAKE_<LANG>_FLAGS` and :variable:`CMAKE_<LANG>_FLAGS_<CONFIG>`
  add language-wide flags passed to all invocations of the compiler.
  This includes invocations that drive compiling and those that drive linking.
