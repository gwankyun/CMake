include_guard
-------------

.. versionadded:: 3.10

为CMake正在处理的文件提交包含保护。

.. code-block:: cmake

  include_guard([DIRECTORY|GLOBAL])

为当前的CMake文件设置包含保护（请参阅\ :variable:`CMAKE_CURRENT_LIST_FILE`\ 变量文档）。

如果当前文件已经在适用的作用域（见下文）中被处理过，CMake将在\ ``include_guard``\ 命令处\
结束对当前文件的处理。这提供了类似于源文件头中常用的包含保护或\ ``#pragma once``\ 指令的功能。\
如果当前文件先前已经在适用的作用域中被处理过，其效果就如同调用了\ :command:`return`\ 命令一样。\
请勿在当前文件中定义的函数内部调用此命令。

可以提供一个可选参数来指定保护的作用域。\
该选项可能的值如下：

``DIRECTORY``
  包含保护适用于当前目录及其子目录。在这个目录作用域内，该文件只会被包含一次，但可能会被此目录\
  之外的其他文件再次包含（例如，父目录，或者不是通过当前文件或其子文件中的\
  :command:`add_subdirectory`\ 或\ :command:`include`\ 命令引入的其他目录）。

``GLOBAL``
  包含保护在整个构建过程中全局生效。无论在何种作用域下，当前文件都只会被包含一次。

如果不提供任何参数，\ ``include_guard``\ 的作用域与变量相同，\
这意味着包含保护的效果会被最近的函数作用域隔离；若不存在内部函数作用域，则会被当前目录隔离。\
在这种情况下，该命令的行为与以下代码相同：

.. code-block:: cmake

  if(__CURRENT_FILE_VAR__)
    return()
  endif()
  set(__CURRENT_FILE_VAR__ TRUE)
