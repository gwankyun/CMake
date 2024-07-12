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

另请参阅
^^^^^^^^

* 这个命令可以用来添加任何选项。但是，对于添加预处理器定义和包含目录，建议使用更具体的命令\
  :command:`target_compile_definitions`\ 和\ :command:`target_include_directories`。

* 对于目录范围的设置，可以使用\ :command:`add_compile_options`\ 命令。

* 对于特定于文件的设置，有一个源文件属性\ :prop_sf:`COMPILE_OPTIONS`。

* 此命令为目标中所有语言添加编译选项。使用\ :genex:`COMPILE_LANGUAGE`\ 生成器表达式指定\
  每种语言的编译选项。

* :command:`target_compile_features`
* :command:`target_link_libraries`
* :command:`target_link_directories`
* :command:`target_link_options`
* :command:`target_precompile_headers`
* :command:`target_sources`

* :variable:`CMAKE_<LANG>_FLAGS`\ 和\ :variable:`CMAKE_<LANG>_FLAGS_<CONFIG>`\
  添加传递给编译器所有调用的语言范围内的标志。这包括驱动编译的调用和驱动链接的调用。
