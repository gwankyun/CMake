separate_arguments
------------------

将命令行参数解析为一个由分号分隔的列表。

.. code-block:: cmake

  separate_arguments(<variable> <mode> [PROGRAM [SEPARATE_ARGS]] <args>)

将一个由空格分隔的字符串\ ``<args>``\ 解析为一个项目列表，并将这个列表以分号分隔的标准形式\
存储在\ ``<variable>``\ 中。

此函数旨在解析命令行参数。整个命令行必须作为一个字符串传递给参数\ ``<args>``。

具体的解析规则取决于操作系统。这些规则由\ ``<mode>``\ 参数指定，该参数必须是以下关键字之一：

``UNIX_COMMAND``
  参数由未加引号的空白字符分隔。单引号和双引号对都会被正确处理。反斜杠用于转义下一个字符\
  （例如，\ ``\"``\ 表示\ ``"``\ ）；不存在特殊转义字符（例如，\ ``\n``\ 就是\ ``n``）。

``WINDOWS_COMMAND``
  Windows命令行的解析使用与运行时库在启动时构造argv相同的语法。它通过未加双引号的空白字符来\
  分隔参数。除非反斜杠位于双引号之前，否则它们是字面意义上的字符。详情请参阅MSDN文章\
  `解析C语言命令行参数`_。

``NATIVE_COMMAND``
  .. versionadded:: 3.9

  如果主机系统是Windows，则按照\ ``WINDOWS_COMMAND``\ 模式进行处理。否则，按照\
  ``UNIX_COMMAND``\ 模式进行处理。

``PROGRAM``
  .. versionadded:: 3.19

  假定\ ``<args>``\ 中的第一个条目是一个可执行文件，会在系统搜索路径中查找该文件，或者将其\
  作为完整路径保留。如果未找到该可执行文件，\ ``<variable>``\ 将为空。否则，\
  ``<variable>``\ 是一个包含两个元素的列表：

  0. 程序的绝对路径
  1. ``<args>``\ 中存在的任何命令行参数，以字符串形式呈现

  例如：

  .. code-block:: cmake

    separate_arguments (out UNIX_COMMAND PROGRAM "cc -c main.c")

  * 列表的第一个元素： ``/path/to/cc``
  * 列表的第二个元素： ``" -c main.c"``

``SEPARATE_ARGS``
  当指定了\ ``PROGRAM``\ 选项的这个子选项时，命令行参数也会被拆分，并存储在\ ``<variable>``\ 中。

  例如：

  .. code-block:: cmake

    separate_arguments (out UNIX_COMMAND PROGRAM SEPARATE_ARGS "cc -c main.c")

  ``out``\ 的内容将是： ``/path/to/cc;-c;main.c``

.. _`解析C语言命令行参数`: https://learn.microsoft.com/en-us/cpp/c-language/parsing-c-command-line-arguments

.. code-block:: cmake

  separate_arguments(<var>)

将\ ``<var>``\ 的值转换为以分号分隔的列表。所有空格都将被替换为‘;’。这有助于生成命令行。
