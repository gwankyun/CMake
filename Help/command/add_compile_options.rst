add_compile_options
-------------------

向源文件的编译添加选项。

.. code-block:: cmake

  add_compile_options(<option> ...)

向\ :prop_dir:`COMPILE_OPTIONS`\ 目录属性添加选项。当从当前目录及以下目录编译目标时，\
将使用这些选项。

.. note::

  链接时不使用这些选项。参见\ :command:`add_link_options`\ 命令。

参数
^^^^^^^^^

.. |command_name| replace:: ``add_compile_options``
.. include:: include/GENEX_NOTE.rst

.. include:: include/OPTIONS_SHELL.rst

示例
^^^^^^^

由于不同的编译器支持不同的选项，该命令的典型用法是在编译器特定的条件子句中：

.. code-block:: cmake

  if (MSVC)
      # warning level 4
      add_compile_options(/W4)
  else()
      # additional warnings
      add_compile_options(-Wall -Wextra -Wpedantic)
  endif()

要设置每种语言的选项，请使用\ :genex:`$<COMPILE_LANGUAGE>`\ 或\
:genex:`$<COMPILE_LANGUAGE:languages> <COMPILE_LANGUAGE:languages>`\ 生成器表达式。

另请参阅
^^^^^^^^

* 这个命令可以用来添加任何选项。但是，对于添加预处理器定义和包含目录，建议使用更具体的命令\
  :command:`add_compile_definitions`\ 和\ :command:`include_directories`。

* :command:`target_compile_options`\ 命令用于添加特定于目标的选项。

* 此命令为所有语言添加编译选项。使用\ :genex:`COMPILE_LANGUAGE`\ 生成器表达式指定每种语言\
  的编译选项。

* 源文件属性\ :prop_sf:`COMPILE_OPTIONS`\ 为一个源文件添加选项。

* :command:`add_link_options`\ 添加链接选项。

* :variable:`CMAKE_<LANG>_FLAGS`\ 和\ :variable:`CMAKE_<LANG>_FLAGS_<CONFIG>`\
  添加传递给编译器所有调用的语言范围内的标志。这包括驱动编译的调用和驱动链接的调用。
