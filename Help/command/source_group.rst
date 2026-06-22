source_group
------------

在IDE中定义一个源码分组。有两个不同的签名来创建源码分组。

.. code-block:: cmake

  source_group(<name> [FILES <src>...] [REGULAR_EXPRESSION <regex>])
  source_group(TREE <root> [PREFIX <prefix>] [FILES <src>...])

定义一个组，项目文件中的源文件将被放入该组中。这旨在为Visual Studio设置文件选项卡。\
该组的作用域为调用此命令的目录，并且适用于在该目录中创建的目标中的源文件。

选项如下：

``TREE``
 .. versionadded:: 3.8

 CMake将根据\ ``<src>``\ 文件的路径自动检测需要创建的源文件组，以使源文件组的结构与项目中\
 实际的文件和目录结构相似。\ ``<src>``\ 文件的路径将被截取为相对于\ ``<root>``\ 的路径。\
 如果\ ``src``\ 中的路径不是以\ ``root``\ 开头，该命令将失败。

``PREFIX``
 .. versionadded:: 3.8

 直接位于\ ``<root>``\ 路径下的源文件组和文件将被放置在\ ``<prefix>``\ 源文件组中。

``FILES``
 任何显式指定的源文件都将被放入名为\ ``<name>``\ 的组中。相对路径是相对于当前源目录来解释的。

 .. versionadded:: 4.3
   ``FILES`` 的参数可以使用\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`。

``REGULAR_EXPRESSION``
 任何文件名与正则表达式匹配的源文件都将被放入名为\ ``<name>``\ 的组中。

如果一个源文件匹配多个组，若有使用\ ``FILES``\ 显式列出该文件的组，则优先选择\ *最后一个*\
这样的组。如果没有组显式列出该文件，则优先选择正则表达式匹配该文件的\ *最后一个*\ 组。

组的名称\ ``<name>``\ 和前缀参数\ ``<prefix>``\ 可以包含正斜杠或反斜杠，以指定子组。\
反斜杠需要进行适当的转义：

.. code-block:: cmake

  source_group(base/subdir ...)
  source_group(outer\\inner ...)
  source_group(TREE <root> PREFIX sources\\inc ...)

.. versionadded:: 3.18
  允许使用正斜杠（\ ``/``\ ）来指定子组。

为了实现向后兼容，提供了以下简写形式：

.. code-block:: cmake

  source_group(<name> <regex>)

相当于

.. code-block:: cmake

  source_group(<name> REGULAR_EXPRESSION <regex>)
