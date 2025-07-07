include_directories
-------------------

将包括目录添加到构建中。

.. code-block:: cmake

  include_directories([AFTER|BEFORE] [SYSTEM] dir1 [dir2 ...])

将给定的目录添加到编译器用于搜索包含文件的目录列表中。相对路径会被解释为相对于当前源目录的路径。

包含目录会被添加到当前\ ``CMakeLists``\ 文件的\ :prop_dir:`INCLUDE_DIRECTORIES`\
目录属性中。它们还会被添加到当前\ ``CMakeLists``\ 文件中每个目标的\
:prop_tgt:`INCLUDE_DIRECTORIES`\ 目标属性中。生成器会使用这些目标属性的值。

默认情况下，指定的目录会被追加到当前的目录列表中。可以通过将\
:variable:`CMAKE_INCLUDE_DIRECTORIES_BEFORE`\ 设置为\ ``ON``\ 来改变这一默认行为。\
通过显式地使用\ ``AFTER``\ 或\ ``BEFORE``，你可以选择追加或前置操作，而不受默认行为的影响。

如果指定了\ ``SYSTEM``\ 选项，编译器会被告知这些目录在某些平台上是系统包含目录。设置此选项\
可能会产生一些效果，例如编译器跳过警告，或者在依赖计算中不考虑这些固定安装的系统文件——\
具体请参阅编译器文档。

.. |command_name| replace:: ``include_directories``
.. include:: include/GENEX_NOTE.rst

.. note::

  建议使用\ :command:`target_include_directories`\ 命令为单个目标添加包含目录，并可选择\
  将这些目录传播/导出给依赖项。

另请参阅
^^^^^^^^

* :command:`target_include_directories`
