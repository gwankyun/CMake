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

  这个命令很少需要，如果有其他选择，应该避免使用。在可能的情况下，最好将完整的绝对路径传递给库，\
  因为这可以确保始终链接正确的库。\ :command:`find_library`\ 命令提供了完整的路径，通常\
  可以在调用\ :command:`target_link_libraries`\ 时直接使用。可能需要库的搜索路径的情况包括：

  - 像Xcode这样的项目生成器，用户可以在构建时切换目标架构，但不能使用库的完整路径，因为它只\
    提供了一种架构（即它不是通用的二进制文件）。
  - 库本身可能有其他期望通过\ ``RPATH``\ 机制找到的私有库依赖项，但一些链接器无法完全解码\
    这些路径（例如，由于\ ``$ORIGIN``\ 之类的东西的存在）。

另请参阅
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
