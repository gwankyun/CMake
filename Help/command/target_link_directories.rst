target_link_directories
-----------------------

.. versionadded:: 3.13

向目标添加链接目录。

.. code-block:: cmake

  target_link_directories(<target> [BEFORE]
    <INTERFACE|PUBLIC|PRIVATE> [items1...]
    [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])

指定链接器在链接给定目标时搜索库的路径。每个项可以是绝对路径或相对路径，后者被解释为相对于当\
前源目录。这些项将被添加到link命令中。

命名的\ ``<target>``\ 必须是由\ :command:`add_executable`\ 或\ :command:`add_library`\
等命令创建的，并且不能是\ :ref:`别名目标 <Alias Targets>`。

``INTERFACE``、\ ``PUBLIC``\ 和\ ``PUBLIC``\ 关键字用于指定它们后面的项目的\
:ref:`范围 <Target Command Scope>`。\ ``PRIVATE``\ 和\ ``PUBLIC``\ 项将填充\
``<target>``\ 的\ :prop_tgt:`LINK_DIRECTORIES`\ 属性。\ ``PUBLIC``\ 和\
``INTERFACE``\ 项将填充\ ``<target>``\ 的\ :prop_tgt:`INTERFACE_LINK_DIRECTORIES`\
属性（\ :ref:`IMPORTED targets <Imported Targets>`\ 只支持\ ``INTERFACE``\ 项）。\
每个项目指定一个链接目录，如果有必要，将在将其添加到相关属性之前转换为绝对路径。重复调用相同的\
``<target>``\ 将元素按照调用的顺序添加。

如果指定了\ ``BEFORE``，内容将被添加到相关属性的前面，而不是被添加到后面。

.. |command_name| replace:: ``target_link_directories``
.. include:: GENEX_NOTE.txt

.. note::

  This command is rarely necessary and should be avoided where there are
  other choices.  Prefer to pass full absolute paths to libraries where
  possible, since this ensures the correct library will always be linked.
  The :command:`find_library` command provides the full path, which can
  generally be used directly in calls to :command:`target_link_libraries`.
  Situations where a library search path may be needed include:

  - Project generators like Xcode where the user can switch target
    architecture at build time, but a full path to a library cannot
    be used because it only provides one architecture (i.e. it is not
    a universal binary).
  - Libraries may themselves have other private library dependencies
    that expect to be found via ``RPATH`` mechanisms, but some linkers
    are not able to fully decode those paths (e.g. due to the presence
    of things like ``$ORIGIN``).

See Also
^^^^^^^^

* :command:`link_directories`
* :command:`target_compile_definitions`
* :command:`target_compile_features`
* :command:`target_compile_options`
* :command:`target_include_directories`
* :command:`target_link_libraries`
* :command:`target_link_options`
* :command:`target_precompile_headers`
* :command:`target_sources`
