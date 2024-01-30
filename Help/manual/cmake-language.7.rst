.. cmake-manual-description: CMake Language Reference

cmake-language(7)
*****************

.. only:: html

   .. contents::

结构
============

CMake输入文件以“CMake语言”写在名为\ ``CMakeLists.txt``\ 的源文件中，或者以\ ``.cmake``\
文件扩展名结尾。

项目中的CMake语言源文件被归类为：

* `目录文件`_ （``CMakeLists.txt``）
* `脚本文件`_ （``<script>.cmake``）
* `模块文件`_ （``<module>.cmake``）

目录文件
-----------

当CMake处理一个项目源码树时，入口点是顶层源目录中名为\ ``CMakeLists.txt``\ 的源文件。\
这个文件可以包含整个构建规范，也可以使用\ :command:`add_subdirectory`\ 命令向构建添加子目录。\
该命令添加的每个子目录还必须包含一个\ ``CMakeLists.txt``\ 文件，作为该目录的入口点。\
对于处理\ ``CMakeLists.txt``\ 文件的每个源目录，CMake在构建树中生成一个相应的目录，\
作为默认的工作目录和输出目录。

脚本文件
--------

一个单独的\ ``<script>.cmake``\ 源文件，可以通过使用带有\ :option:`-P <cmake -P>`\
选项的\ :manual:`cmake(1)`\ 命令行工具在\ *脚本模式*\ 下处理。脚本模式只是运行给定的\
CMake语言源文件中的命令，而不生成构建系统。它不允许定义构建目标或操作的CMake命令。

模块文件
--------

CMake语言代码在\ `目录文件`_\ 或\ `脚本文件`_\ 可以使用\ :command:`include`\ 命令加载\
包含上下文的范围内的\ ``<module>.cmake``\ 源文件。有关CMake发行版中包含的模块的文档，\
请参阅\ :manual:`cmake-modules(7)`\ 手册页。项目源码树还可以提供它们自己的模块，并在\
:variable:`CMAKE_MODULE_PATH`\ 变量中指定它们的位置。

语法
======

.. _`CMake Language Encoding`:

编码
--------

为了在所有支持的平台上实现最大的可移植性，CMake语言源文件可以用7位ASCII文本编写。\
换行符可以编码为\ ``\n``\ 或\ ``\r\n``，但在读取输入文件时将被转换为\ ``\n``。

注意，该实现是8位的，若系统API支持，源文件可以被编码为UTF-8。\
此外，CMake 3.2及以上版本支持Windows上UTF-8编码的源文件（使用UTF-16调用系统API）。\
此外，CMake 3.0及以上版本允许在源文件中使用开头的UTF-8\ `字节序标记`_。

.. _字节序标记: https://en.wikipedia.org/wiki/Byte_order_mark

源文件
------------

一个CMake源文件由0个或多个\ `命令调用`_\ 组成，命令调用由换行符、可选的空格和\ `注释`_\ 分隔：

.. raw:: latex

   \begin{small}

.. productionlist::
 file: `file_element`*
 file_element: `command_invocation` `line_ending` |
             : (`bracket_comment`|`space`)* `line_ending`
 line_ending: `line_comment`? `newline`
 space: <match '[ \t]+'>
 newline: <match '\n'>

.. raw:: latex

   \end{small}

请注意，任何不在\ `命令参数`_\ 或\ `括号注释`_\ 中的源文件行都可以以\ `行注释`_\ 结束。

.. _`Command Invocations`:

命令调用
-------------------

*命令调用*\ 是一个名称，后面跟着用空格分隔的圆括号括起来的参数：

.. raw:: latex

   \begin{small}

.. productionlist::
 command_invocation: `space`* `identifier` `space`* '(' `arguments` ')'
 identifier: <match '[A-Za-z_][A-Za-z0-9_]*'>
 arguments: `argument`? `separated_arguments`*
 separated_arguments: `separation`+ `argument`? |
                    : `separation`* '(' `arguments` ')'
 separation: `space` | `line_ending`

.. raw:: latex

   \end{small}

例如：

.. code-block:: cmake

 add_executable(hello world.c)

命令名不区分大小写。参数中嵌套的未加引号的圆括号必须匹配。每个\ ``(``\ 或\ ``)``\ 都作为\
`无引号参数`_\ 提供给命令调用。这可以在调用\ :command:`if`\ 命令来封装条件时使用。例如：

.. code-block:: cmake

 if(FALSE AND (FALSE OR TRUE)) # evaluates to FALSE

.. note::
 3.0之前的CMake版本要求命令名标识符至少为2个字符。

 在2.8.12之前的版本，CMake静默地接受一个\ `无引号参数`_，或者紧接在\ `引号参数`_\ 后面的\
 `引号参数`_，不被任何空格分隔。为了兼容性，CMake 2.8.12及更高版本接受这样的代码，但会产生警告。

命令参数
-----------------

`命令调用`_\ 有三种参数：

.. raw:: latex

   \begin{small}

.. productionlist::
 argument: `bracket_argument` | `quoted_argument` | `unquoted_argument`

.. raw:: latex

   \end{small}

.. _`Bracket Argument`:

方括号参数
^^^^^^^^^^^^^^^^

受\ `Lua`_\ 长括号语法启发的 *括号参数*，将内容括在相同长度的开始和结束“括号”之间：

.. raw:: latex

   \begin{small}

.. productionlist::
 bracket_argument: `bracket_open` `bracket_content` `bracket_close`
 bracket_open: '[' '='* '['
 bracket_content: <any text not containing a `bracket_close` with
                :  the same number of '=' as the `bracket_open`>
 bracket_close: ']' '='* ']'

.. raw:: latex

   \end{small}

开括号写\ ``[``\ 后面跟着零或多个\ ``=``\ 后面再跟着\ ``[``。对应的闭括号是\ ``]``，后\
面跟着相同数量的\ ``=``，后面再跟着\ ``]``。括号不嵌套。总是可以为开括号和闭括号选择一个唯\
一的长度，以包含其他长度组合。

方括号参数内容包含开括号和闭括号之间的所有文本，除了可能存在的紧随着开括号的换行符之外皆被忽略。\
不会对包含的内容，如\ `转义序列`_\ 或\ `变量引用`_，执行计算。方括号参数总是作为一个参数提\
供给命令调用。

.. ATTENTION No code-block syntax highlighting in the following example
   (long string literal not supported by our cmake.py)

例如： ::

 message([=[
 This is the first line in a bracket argument with bracket length 1.
 No \-escape sequences or ${variable} references are evaluated.
 This is always one argument even though it contains a ; character.
 The text does not end on a closing bracket of length 0 like ]].
 It does end in a closing bracket of length 1.
 ]=])

.. note::
 3.0之前的CMake版本不支持方括号参数。它们将开括号解释为\ `无引号参数`_\ 的开始。

.. _`Lua`: https://www.lua.org/

.. _`Quoted Argument`:

引号参数
^^^^^^^^^^^^^^^

*引号参数* 将内容括在开双引号和闭双引号之间：

.. raw:: latex

   \begin{small}

.. productionlist::
 quoted_argument: '"' `quoted_element`* '"'
 quoted_element: <any character except '\' or '"'> |
                 : `escape_sequence` |
                 : `quoted_continuation`
 quoted_continuation: '\' `newline`

.. raw:: latex

   \end{small}

引号参数内容包括开引号和闭引号之间的所有文本。`转义序列`_\ 和\ `变量引用`_\ 都被求值。引用\
参数总是作为一个参数提供给命令调用。

.. ATTENTION No code-block syntax highlighting in the following example
   (escape \" not supported by our cmake.py)

例如：

.. code-block:: cmake

  message("This is a quoted argument containing multiple lines.
  This is always one argument even though it contains a ; character.
  Both \\-escape sequences and ${variable} references are evaluated.
  The text does not end on an escaped double-quote like \".
  It does end in an unescaped double quote.
  ")

.. ATTENTION No code-block syntax highlighting in the following example
   (for conformity with the two above examples)

以奇数个反斜杠结尾的任何行上的最后一个\ ``\``\ 将被视为行延续，并与紧接其后的换行符一起被\
忽略。例如：

.. code-block:: cmake

  message("\
  This is the first line of a quoted argument. \
  In fact it is the only line but since it is long \
  the source code uses line continuation.\
  ")

.. note::
 3.0之前的CMake版本不支持\ ``\``\ 延续。它们报告用引号括起来的参数错误，这些参数包含以奇数\
 ``\``\ 字符结尾的行。

.. _`Unquoted Argument`:

无引号参数
^^^^^^^^^^^^^^^^^

*无引号参数*\ 没有被引号语法括起来。它不能包含任何空格、``(``、``)``、\ ``#``、\ ``"``\
和\ ``\``，除非用反斜杠转义：

.. raw:: latex

   \begin{small}

.. productionlist::
 unquoted_argument: `unquoted_element`+ | `unquoted_legacy`
 unquoted_element: <any character except whitespace or one of '()#"\'> |
                 : `escape_sequence`
 unquoted_legacy: <see note in text>

.. raw:: latex

   \end{small}

无引号参数内容包含的连续块中的所有文本，允许转义字符。`转义序列`_\ 和\ `变量引用`_\ 都会被求值。\
结果值的划分方式与\ `列表`_\ 划分元素的方式相同。每个非空元素都作为参数提供给命令调用。\
因此，一个无引号参数可以作为零个或多个参数提供给命令调用。

例如：

.. code-block:: cmake

 foreach(arg
     NoSpace
     Escaped\ Space
     This;Divides;Into;Five;Arguments
     Escaped\;Semicolon
     )
   message("${arg}")
 endforeach()

.. note::
 为了支持遗留的CMake代码，无引号参数还可能包含双引号字符串（\ ``"..."``，可能包含水平空格）\
 和make风格的变量引用（\ ``$(MAKEVAR)``）。

 未转义的双引号必须保证配对，不能出现在无引号参数的开头，并被视为内容的一部分。例如，无引号参数\
 ``-Da="b c"``、\ ``-Da=$(v)``\ 和\ ``a" "b"c"d``\ 都是按字面意思解释的。它们可以写成\
 引号参数\ ``"-Da=\"b c\""``、\ ``"-Da=$(v)"``、和\ ``"a\" \"b\"c\"d"``。

 Make风格引用字面上被视为内容的一部分，而不进行变量展开。\
 它们被视为单个参数的一部分（而不是作为单独的\ ``$``、\ ``(``、\ ``MAKEVAR``\ 和\ ``)``\ 参数）。

 上面的“unquoted_legacy”形式代表了这种参数。我们不建议在新代码中使用遗留的无引号参数。\
 相反，应该使用\ `引号参数`_\  或\ `方括号参数`_\ 来表示内容。

.. _`Escape Sequences`:

转义序列
----------------

所谓\ *转义序列*\ 指的是一个\ ``\``\ 后面跟着一个字符：

.. raw:: latex

   \begin{small}

.. productionlist::
 escape_sequence: `escape_identity` | `escape_encoded` | `escape_semicolon`
 escape_identity: '\' <match '[^A-Za-z0-9;]'>
 escape_encoded: '\t' | '\r' | '\n'
 escape_semicolon: '\;'

.. raw:: latex

   \end{small}

后面跟着非字母数字字符的\ ``\``\ 只会对字面字符进行编码，而不会将其解释为语法。\ ``\t``、\
``\r``\ 或\ ``\n``\ 分别编码制表符、回车符或换行符。一个\ ``\;``\ 在任何\ `变量引用`_\
之外编码自身，但也可以在\ `无引号参数`_\ 中使用\ ``;``\ 而不需要分割它的值。\ `变量引用`_\
中的\ ``\;``\ 编码为\ ``;``\ 字符。(请参阅策略\ :policy:`CMP0053`\ 文档了解历史考虑。)

.. _`Variable References`:

变量引用
-------------------

*变量引用*\ 的格式为\ ``${<variable>}``，在\ `引号参数`_\ 或\ `无引号参数`_\ 中求值。\
变量引用将被指定变量或缓存项的值替换，如果两者都没有设置，则用空字符串替换。变量引用可以嵌套\
并由内而外求值，例如\ ``${outer_${inner_variable}_variable}``。

字面值变量引用可以由字母数字、``/_.+-``\ 和\ `转义序列`_\ 组成。嵌套引用可用于计算任意名称\
的变量。请参阅策略\ :policy:`CMP0053`\ 文档了解历史考虑因素以及为什么\ ``$``\ 在技术上允\
许，却不鼓励使用的原因。

`变量`_\ 章节记录了变量名的作用域以及变量的值是如何设置的。

*环境变量引用*\ 的格式为\ ``$ENV{<variable>}``。有关更多信息，请参阅\ `环境变量`_\ 一节。

*缓存变量引用*\ 格式为\ ``$CACHE{<variable>}``，并被指定的缓存条目的值替换，而不检查同名\
的普通变量。如果缓存条目不存在，则将其替换为空字符串。有关更多信息，请参阅\ :variable:`CACHE`。

:command:`if`\ 命令有一个特殊的条件语法，它允许以\ ``<variable>``\ 缩写格式引用变量代替\
``${<variable>}``。但是，环境变量总是需要引用为\ ``$ENV{<variable>}``。

注释
--------

注释以\ ``#``\ 字符开始，不包含在\ `方括号参数`_、`引号参数`_\ 或者由\ ``\``\ 转义作为\
`无引号参数`_\ 的一部分。注释有两种类型：\ `括号注释`_\ 和\ `行注释`_。

.. _`Bracket Comment`:

括号注释
^^^^^^^^^^^^^^^

紧跟在\ ``#``\ 后面的\ :token:`bracket_open`\ 会形成一个由整个括号框组成的\ *括号注释*：

.. raw:: latex

   \begin{small}

.. productionlist::
 bracket_comment: '#' `bracket_argument`

.. raw:: latex

   \end{small}

例如：

::

 #[[This is a bracket comment.
 It runs until the close bracket.]]
 message("First Argument\n" #[[Bracket Comment]] "Second Argument")

.. note::
 3.0之前的CMake版本不支持括号注释。他们将开头\ ``#``\ 解释为\ `行注释`_\ 的开始。

.. _`Line Comment`:

行注释
^^^^^^^^^^^^

紧跟在\ :token:`bracket_open`\ 后面的\ ``#``\ 会形成一个\ *行注释*，它会一直运行到行尾：

.. raw:: latex

   \begin{small}

.. productionlist::
 line_comment: '#' <any text not starting in a `bracket_open`
             :      and not containing a `newline`>

.. raw:: latex

   \end{small}

例如：

.. code-block:: cmake

 # This is a line comment.
 message("First Argument\n" # This is a line comment :)
         "Second Argument") # This is a line comment.

控制结构
==================

条件块
------------------

:command:`if`/:command:`elseif`/:command:`else`/:command:`endif`\ 命令分隔条件执行\
的代码块。

循环
-----

:command:`foreach`/:command:`endforeach`\ 和\ :command:`while`/:command:`endwhile`\
命令分隔要在循环中执行的代码块。在这些块中，:command:`break`\ 命令可用于提前终止循环，而\
:command:`continue`\ 命令可用于立即开始下一次迭代。

命令定义
-------------------

:command:`macro`/:command:`endmacro`\ 和\ :command:`function`/:command:`endfunction`\
命令将代码块分隔开来，以便以后作为命令调用。

.. _`CMake Language Variables`:

变量
=========

变量是CMake语言中基本的存储单元。它们的值总是字符串类型的，尽管有些命令可能会将字符串解释为\
其他类型的值。\ :command:`set`\ 和\ :command:`unset`\ 命令显式地设置或取消变量的设置，\
但其他命令也具有修改变量的语义。变量名是区分大小写的，可以包含几乎任何文本，但我们建议只使用\
字母数字字符加上\ ``_``\ 和\ ``-``\ 组成的名称。

变量具有动态作用域。每个变量“set”或“unset”都在当前作用域中创建一个绑定：

块作用域
 :command:`block`\ 命令可以为变量绑定创建一个新的作用域。 

函数作用域
 由\ :command:`function`\ 命令创建的\ `命令定义`_，当调用这些命令时，这些命令将在新的变\
 量绑定范围内处理记录的命令。变量“set”或“unset”在此作用域中绑定，对当前函数及其内嵌调用可见，\
 但在函数返回后不可见。

目录作用域
 源码树中的每个\ `目录文件`_\ 都有自己的变量绑定。\
 在处理目录的\ ``CMakeLists.txt``\ 文件之前，CMake复制当前父目录中定义的所有可能存在的变\
 量绑定，以初始化新的目录作用域。当使用\ :option:`cmake -P`\ 处理CMake\ `脚本文件`_\ 时，\
 会将变量绑定在一个“目录”范围内。

 不在函数调用内的变量“set”或“unset”绑定到当前目录作用域。

持久缓存
 CMake存储一组单独的“缓存”变量或“缓存条目”，它们的值在项目构建树的多次运行中保持不变。\
 缓存条目有一个独立的绑定范围，只有通过显式请求才能修改，比如通过\ :command:`set`\ 和\
 :command:`unset`\ 命令的\ ``CACHE``\ 选项。

当计算\ `变量引用`_\ 时，CMake首先在可能存在的函数调用堆栈中搜索绑定，然后返回到可能存在的\
当前目录定义域内的绑定。如果找到了“set”绑定，则使用其值。如果找到了“unset”绑定，或者没有找\
到绑定，CMake就会搜索一个缓存条目。如果找到缓存条目，则使用其值。否则，变量引用计算为空字符串。\
``$CACHE{VAR}``\ 语法可以用来直接查找缓存条目。

:manual:`cmake-variables(7)`\ 手册记录了许多由CMake提供的变量，或者由项目代码设置的对\
CMake有意义的变量。

.. include:: ID_RESERVE.txt

.. _`CMake Language Environment Variables`:

环境变量
=====================

环境变量与普通\ `变量`_\ 相似，但有以下不同之处：

作用域
 环境变量在CMake进程中具有全局作用域。绝对不会缓存它们。

引用
 `变量引用`_\ 的格式为\ ``$ENV{<variable>}``，使用\ :variable:`ENV`\ 操作符。

初始化
 CMake环境变量的初始值是调用进程时的初始值。可以使用\ :command:`set`\ 和\ :command:`unset`\
 命令更改值。这些命令只影响CMake进程的运行，不会影响整个系统环境。更改的值不会写回调用进程，\
 后续的构建或测试流程也不会看到它们。
 
 参见\ :option:`cmake -E env <cmake-E env>`\ 命令行工具在修改后的环境运行命令。

检查
 查看\ :option:`cmake -E environment <cmake-E environment>`\ 命令行工具以显示当前所\
 有环境变量。

:manual:`cmake-env-variables(7)`\ 手册记录了对CMake有特殊意义的环境变量。

.. _`CMake Language Lists`:

列表
=====

尽管CMake中的所有值都存储为字符串，但字符串在某些上下文中可能被视为列表，例如在\ `无引号参数`_\
的求值过程中。在这种上下文中，字符串被拆分成\ ``;``\ 分割的列表，它们不跟在不同数量的\ ``[``\
和\ ``]``\ 字符之后，且不直接跟在\ ``\``\ 字符前面。序列\ ``\;``\ 不参与，但在生成的元素\
中会被替换成\ ``;``。

列表通过用\ ``;``\ 分隔的字符串来表示。例如，:command:`set`\ 命令将多个值以列表的形式存储\
到目标变量中：

.. code-block:: cmake

 set(srcs a.c b.c c.c) # sets "srcs" to "a.c;b.c;c.c"

列表适用于简单的用例，如源文件列表，不应用于复杂的数据处理任务。大多数构造列表的命令不会转义\
列表元素中的\ ``;``\ 字符，从而展平嵌套的列表：

.. code-block:: cmake

 set(x a "b;c") # sets "x" to "a;b;c", not "a;b\;c"

通常，列表不支持包含元素\ ``;``\ 字符。为避免出现问题，请考虑以下建议：

*  许多CMake命令、变量和属性的接口都接受分号分隔的列表。\
   避免将包含分号元素的列表传递给这些接口，除非它们表明了对分号的直接支持，或者以某种方式转\
   义或编码分号。

* 当构造一个列表时，用一个不使用的占位符替换元素中的\ ``;``。然后代替\ ``;``\ 用于处理列表\
  元素时的占位符。例如，下面的代码使用\ ``|``\ 代替\ ``;``\ 字符：

  .. code-block:: cmake

    set(mylist a "b|c")
    foreach(entry IN LISTS mylist)
      string(REPLACE "|" ";" entry "${entry}")
      # use "${entry}" normally
    endforeach()

  :module:`ExternalProject`\ 模块的\ ``LIST_SEPARATOR``\ 选项就是使用这种方法构建的\
  接口的一个例子。

* 在\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 列表中，使用\
  :genex:`$<SEMICOLON>`\ 生成器表达式。

* 在命令调用中，尽可能使用\ `引号参数`_\ 语法。被调用的命令将接收保留分号的参数内容。\
  `无引号参数`_\ 将用分号分隔。

* 在\ :command:`function`\ 实现中，避免使用\ ``ARGV``\ 和\ ``ARGN``，它们不能区分值中\
  的分号和分隔值。相反，最好使用命名位置参数和\ ``ARGC``\ 及\ ``ARGV#``\ 变量。当使用\
  :command:`cmake_parse_arguments`\ 解析参数时，最好使用它的\ ``PARSE_ARGV``\ 签名，\
  它使用\ ``ARGV#``\ 变量。

  注意，这种方法不适用于\ :command:`macro`\ 实现，因为它们引用的参数是占位符，而不是实际变量。
