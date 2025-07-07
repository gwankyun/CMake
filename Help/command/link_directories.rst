link_directories
----------------

添加链接器查找库的目录。

.. code-block:: cmake

  link_directories([AFTER|BEFORE] directory1 [directory2 ...])

添加链接器应该搜索库的路径。\
传递给此命令的相对路径将被解释为相对于当前源目录，请参阅\ :policy:`CMP0015`。

此命令仅适用于在其调用之后创建的目标。

.. versionadded:: 3.13
  这些目录会被添加到当前\ ``CMakeLists.txt``\ 文件的\ :prop_dir:`LINK_DIRECTORIES`\
  目录属性中，并根据需要将相对路径转换为绝对路径。有关定义构建系统属性的更多信息，请参阅\
  :manual:`cmake-buildsystem(7)`\ 手册。

.. versionadded:: 3.13
  默认情况下，指定的目录会追加到当前的目录列表中。可以通过将\
  :variable:`CMAKE_LINK_DIRECTORIES_BEFORE`\ 设置为\ ``ON``\ 来改变这一默认行为。\
  通过显式地使用\ ``AFTER``\ 或\ ``BEFORE``，你可以选择追加或前置操作，而不受默认设置的影响。

.. versionadded:: 3.13
  ``link_directories``\ 的参数可以使用语法为“$<...>”的“生成器表达式”。有关可用表达式的\
  详细信息，请参阅\ :manual:`cmake-generator-expressions(7)`\ 手册。

.. note::

  此命令很少有必要使用，只要有其他选择就应避免使用。在可能的情况下，最好传递库的完整绝对路径，\
  因为这样能确保始终链接到正确的库。\
  :command:`find_library`\ 命令可以提供完整路径，该路径通常可直接用于\
  :command:`target_link_libraries`\ 调用。\
  可能需要指定库搜索路径的情况包括：

  - 像\ :generator:`Xcode`\ 这样的项目生成器，用户可以在构建时切换目标架构，但不能使用库的完整路径，因为该路\
    径仅适用于一种架构（即它不是通用二进制文件）。
  - 库本身可能存在其他私有库依赖项，这些依赖项期望通过\ ``RPATH``\ 机制来查找，但一些链接器\
    无法完全解析这些路径（例如，由于存在像\ ``$ORIGIN``\ 这样的内容）。

  如果必须提供库搜索路径，那么应尽可能使用\ :command:`target_link_directories`\ 命令而非\
  ``link_directories()``，以将影响范围限制在特定目标上。这个针对特定目标的命令还可以控制\
  搜索目录如何传播到其他依赖目标。

另外参阅
^^^^^^^^

* :command:`target_link_directories`
* :command:`target_link_libraries`
