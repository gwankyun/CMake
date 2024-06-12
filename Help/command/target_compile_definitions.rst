target_compile_definitions
--------------------------

向目标添加编译定义。

.. code-block:: cmake

  target_compile_definitions(<target>
    <INTERFACE|PUBLIC|PRIVATE> [items1...]
    [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])

指定编译给定\ ``<target>``\ 时要使用的编译定义。命名的\ ``<target>``\ 必须是由\
:command:`add_executable`\ 或\ :command:`add_library`\ 等命令创建的，并且不能是\
:ref:`别名目标 <Alias Targets>`。

``INTERFACE``、\ ``PUBLIC``\ 和\ ``PRIVATE``\ 关键字用于指定下列参数的\
:ref:`作用域 <Target Command Scope>`。\ ``PRIVATE``\ 和\ ``PUBLIC``\ 项将填充\
``<target>``\ 的\ :prop_tgt:`COMPILE_DEFINITIONS`\ 属性。\ ``PUBLIC``\ 和\
``INTERFACE``\ 项将填充\ ``<target>``\ 的\ :prop_tgt:`INTERFACE_COMPILE_DEFINITIONS`\
属性。下列参数指定编译定义。重复调用相同的\ ``<target>``\ 将元素按照调用的顺序添加。

.. versionadded:: 3.11
  允许在\ :ref:`导入目标 <Imported Targets>`\ 上设置\ ``INTERFACE``\ 项。

.. |command_name| replace:: ``target_compile_definitions``
.. include:: GENEX_NOTE.txt

元素前面的\ ``-D``\ 将被删除。空项被忽略。例如，以下代码都是等价的：

.. code-block:: cmake

  target_compile_definitions(foo PUBLIC FOO)
  target_compile_definitions(foo PUBLIC -DFOO)  # -D removed
  target_compile_definitions(foo PUBLIC "" FOO) # "" ignored
  target_compile_definitions(foo PUBLIC -D FOO) # -D becomes "", then ignored

定义可以有可选的值：

.. code-block:: cmake

  target_compile_definitions(foo PUBLIC FOO=1)

请注意，许多编译器将\ ``-DFOO``\ 视为\ ``-DFOO=1``，但其他工具可能不能在所有情况下识别这\
一点（例如IntelliSense）。

另请参阅
^^^^^^^^

* :command:`add_compile_definitions`
* :command:`target_compile_features`
* :command:`target_compile_options`
* :command:`target_include_directories`
* :command:`target_link_libraries`
* :command:`target_link_directories`
* :command:`target_link_options`
* :command:`target_precompile_headers`
* :command:`target_sources`
