add_compile_definitions
-----------------------

.. versionadded:: 3.12

将预处理器定义添加到源文件的编译中。

.. code-block:: cmake

  add_compile_definitions(<definition> ...)

将预处理器定义添加到编译器命令行。

预处理器定义被添加到当前\ ``CMakeLists``\ 文件的\ :prop_dir:`COMPILE_DEFINITIONS`\
目录属性中。它们还被添加到当前\ ``CMakeLists``\ 文件中每个目标的\
:prop_tgt:`COMPILE_DEFINITIONS`\ 目标属性中。

定义使用\ ``VAR``\ 或\ ``VAR=value``\ 语法指定。不支持函数式定义。CMake将自动为本机构建\
系统正确转义值（注意，CMake语言语法可能需要转义来指定某些值）。

.. versionadded:: 3.26
  元素前面的\ ``-D``\ 将被删除。

.. |command_name| replace:: ``add_compile_definitions``
.. include:: include/GENEX_NOTE.rst

另请参阅
^^^^^^^^

* :command:`target_compile_definitions`\ 命令用于添加特定于目标的定义。
