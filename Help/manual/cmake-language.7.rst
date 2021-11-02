.. cmake-manual-description: CMake Language Reference

cmake-language(7)
*****************

.. only:: html

   .. contents::

结构
============

CMake输入文件以“CMake语言”写在名为 ``CMakeLists.txt`` 的源文件中，或者以 ``.cmake`` 文件扩展名结尾。

项目中的CMake语言源文件被归类为：

* `目录文件`_ （``CMakeLists.txt``）
* `脚本文件`_ （``<script>.cmake``）
* `模块文件`_ （``<module>.cmake``）

目录文件
-----------

当CMake处理一个项目源码树时，入口点是顶层源目录中名为 ``CMakeLists.txt`` 的源文件。这个文件可以包含整个构建规范，也可以使用 :command:`add_subdirectory` 命令向构建添加子目录。该命令添加的每个子目录还必须包含一个 ``CMakeLists.txt`` 文件，作为该目录的入口点。对于处理 ``CMakeLists.txt`` 文件的每个源目录，CMake在构建树中生成一个相应的目录，作为默认的工作目录和输出目录。

脚本文件
--------

一个单独的 ``<script>.cmake`` 源文件，可以通过使用带有 ``-P`` 选项的 :manual:`cmake(1)` 命令行工具在 *脚本模式* 下处理。脚本模式只是运行给定的CMake语言源文件中的命令，而不生成构建系统。它不允许定义构建目标或操作的CMake命令。

模块文件
--------

CMake语言代码在 `目录文件`_ 或 `脚本文件`_ 可以使用 :command:`include` 命令加载包含上下文的范围内的 ``<module>.cmake`` 源文件。有关CMake发行版中包含的模块的文档，请参阅 :manual:`cmake-modules(7)` 手册页。项目源码树还可以提供它们自己的模块，并在 :variable:`CMAKE_MODULE_PATH` 变量中指定它们的位置。

语法
======

.. _`CMake Language Encoding`:

编码
--------

为了在所有支持的平台上实现最大的可移植性，CMake语言源文件可以用7位ASCII文本编写。换行符可以编码为 ``\n`` 或 ``\r\n``，但在读取输入文件时将被转换为 ``\n``。

注意，该实现是8位的，若系统API支持，源文件可以被编码为UTF-8。此外，CMake 3.2及以上版本支持Windows上UTF-8编码的源文件（使用UTF-16调用系统API）。此外，CMake 3.0及以上版本允许在源文件中使用开头的UTF-8 `字节序标记`_。

.. _`字节序标记`: http://en.wikipedia.org/wiki/Byte_order_mark

源文件
------------

一个CMake源文件由0个或多个 `命令调用`_ 组成，命令调用由换行符、可选的空格和 `注释`_ 分隔：

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

请注意，任何不在 `命令参数`_ 或 `括号注释`_ 中的源文件行都可以以 `行注释`_ 结束。

.. _`Command Invocations`:

命令调用
-------------------

*命令调用* 是一个名称，后面跟着用空格分隔的圆括号括起来的参数：

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

命令名不区分大小写。参数中嵌套的未加引号的圆括号必须匹配。每个 ``(`` 或 ``)`` 都作为 `无引号参数`_ 提供给命令调用。这可以在调用 :command:`if` 命令来封装条件时使用。例如：

.. code-block:: cmake

 if(FALSE AND (FALSE OR TRUE)) # evaluates to FALSE

.. note::
 3.0之前的CMake版本要求命令名标识符至少为2个字符。

 在2.8.12之前的版本，CMake静默地接受一个 `无引号参数`_，或者紧接在 `引号参数`_ 后面的 `引号参数`_，不被任何空格分隔。为了兼容性，CMake 2.8.12及更高版本接受这样的代码，但会产生警告。

命令参数
-----------------

`命令调用`_ 有三种参数：

.. raw:: latex

   \begin{small}

.. productionlist::
 argument: `bracket_argument` | `quoted_argument` | `unquoted_argument`

.. raw:: latex

   \end{small}

.. _`Bracket Argument`:

方括号参数
^^^^^^^^^^^^^^^^

受 `Lua`_ 长括号语法启发的 *括号参数*，将内容括在相同长度的开始和结束“括号”之间：

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

开括号写 ``[`` 后面跟着零或多个 ``=`` 后面再跟着 ``[``。对应的闭括号是 ``]``，后面跟着相同数量的 ``=``，后面再跟着 ``]``。括号不嵌套。总是可以为开括号和闭括号选择一个唯一的长度，以包含其他长度组合。

方括号参数内容包含开括号和闭括号之间的所有文本，除了可能存在的紧随着开括号的换行符之外皆被忽略。不会对包含的内容，如 `转义序列`_ 或 `变量引用`_，执行计算。方括号参数总是作为一个参数提供给命令调用。

.. No code-block syntax highlighting in the following example
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
 3.0之前的CMake版本不支持方括号参数。它们将左括号解释为 `无引号参数`_ 的开始。

.. _`Lua`: http://www.lua.org/

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

引号参数内容包括开引号和闭引号之间的所有文本。`转义序列`_ 和 `变量引用`_ 都被求值。引用参数总是作为一个参数提供给命令调用。

.. No code-block syntax highlighting in the following example
   (escape \" not supported by our cmake.py)

例如：

.. code-block:: cmake

  message("This is a quoted argument containing multiple lines.
  This is always one argument even though it contains a ; character.
  Both \\-escape sequences and ${variable} references are evaluated.
  The text does not end on an escaped double-quote like \".
  It does end in an unescaped double quote.
  ")

.. No code-block syntax highlighting in the following example
   (for conformity with the two above examples)

以奇数个反斜杠结尾的任何行上的最后一个 ``\`` 将被视为行延续，并与紧接其后的换行符一起被忽略。例如：

.. code-block:: cmake

  message("\
  This is the first line of a quoted argument. \
  In fact it is the only line but since it is long \
  the source code uses line continuation.\
  ")

.. note::
 3.0之前的CMake版本不支持 ``\`` 延续。它们报告用引号括起来的参数错误，这些参数包含以奇数 ``\`` 字符结尾的行。

.. _`Unquoted Argument`:

无引号参数
^^^^^^^^^^^^^^^^^

An *unquoted argument* is not enclosed by any quoting syntax.
It may not contain any whitespace, ``(``, ``)``, ``#``, ``"``, or ``\``
except when escaped by a backslash:

.. raw:: latex

   \begin{small}

.. productionlist::
 unquoted_argument: `unquoted_element`+ | `unquoted_legacy`
 unquoted_element: <any character except whitespace or one of '()#"\'> |
                 : `escape_sequence`
 unquoted_legacy: <see note in text>

.. raw:: latex

   \end{small}

Unquoted argument content consists of all text in a contiguous block
of allowed or escaped characters.  Both `Escape Sequences`_ and
`Variable References`_ are evaluated.  The resulting value is divided
in the same way `列表`_ divide into elements.  Each non-empty element
is given to the command invocation as an argument.  Therefore an
unquoted argument may be given to a command invocation as zero or
more arguments.

For example:

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
 To support legacy CMake code, unquoted arguments may also contain
 double-quoted strings (``"..."``, possibly enclosing horizontal
 whitespace), and make-style variable references (``$(MAKEVAR)``).

 Unescaped double-quotes must balance, may not appear at the
 beginning of an unquoted argument, and are treated as part of the
 content.  For example, the unquoted arguments ``-Da="b c"``,
 ``-Da=$(v)``, and ``a" "b"c"d`` are each interpreted literally.
 They may instead be written as quoted arguments ``"-Da=\"b c\""``,
 ``"-Da=$(v)"``, and ``"a\" \"b\"c\"d"``, respectively.

 Make-style references are treated literally as part of the content
 and do not undergo variable expansion.  They are treated as part
 of a single argument (rather than as separate ``$``, ``(``,
 ``MAKEVAR``, and ``)`` arguments).

 The above "unquoted_legacy" production represents such arguments.
 We do not recommend using legacy unquoted arguments in new code.
 Instead use a `Quoted Argument`_ or a `Bracket Argument`_ to
 represent the content.

.. _`Escape Sequences`:

转义序列
----------------

An *escape sequence* is a ``\`` followed by one character:

.. raw:: latex

   \begin{small}

.. productionlist::
 escape_sequence: `escape_identity` | `escape_encoded` | `escape_semicolon`
 escape_identity: '\' <match '[^A-Za-z0-9;]'>
 escape_encoded: '\t' | '\r' | '\n'
 escape_semicolon: '\;'

.. raw:: latex

   \end{small}

A ``\`` followed by a non-alphanumeric character simply encodes the literal
character without interpreting it as syntax.  A ``\t``, ``\r``, or ``\n``
encodes a tab, carriage return, or newline character, respectively. A ``\;``
outside of any `变量引用`_  encodes itself but may be used in an
`Unquoted Argument`_ to encode the ``;`` without dividing the argument
value on it.  A ``\;`` inside `Variable References`_ encodes the literal
``;`` character.  (See also policy :policy:`CMP0053` documentation for
historical considerations.)

.. _`Variable References`:

变量引用
-------------------

A *variable reference* has the form ``${<variable>}`` and is
evaluated inside a `Quoted Argument`_ or an `Unquoted Argument`_.
A variable reference is replaced by the value of the variable,
or by the empty string if the variable is not set.
Variable references can nest and are evaluated from the
inside out, e.g. ``${outer_${inner_variable}_variable}``.

Literal variable references may consist of alphanumeric characters,
the characters ``/_.+-``, and `Escape Sequences`_.  Nested references
may be used to evaluate variables of any name.  See also policy
:policy:`CMP0053` documentation for historical considerations and reasons why
the ``$`` is also technically permitted but is discouraged.

The `变量`_ section documents the scope of variable names
and how their values are set.

An *environment variable reference* has the form ``$ENV{<variable>}``.
See the `环境变量`_ section for more information.

A *cache variable reference* has the form ``$CACHE{<variable>}``.
See :variable:`CACHE` for more information.

The :command:`if` command has a special condition syntax that
allows for variable references in the short form ``<variable>``
instead of ``${<variable>}``.
However, environment and cache variables always need to be
referenced as ``$ENV{<variable>}`` or ``$CACHE{<variable>}``.

注释
--------

A comment starts with a ``#`` character that is not inside a
`Bracket Argument`_, `Quoted Argument`_, or escaped with ``\``
as part of an `Unquoted Argument`_.  There are two types of
comments: a `Bracket Comment`_ and a `Line Comment`_.

.. _`Bracket Comment`:

括号注释
^^^^^^^^^^^^^^^

A ``#`` immediately followed by a :token:`bracket_open` forms a
*bracket comment* consisting of the entire bracket enclosure:

.. raw:: latex

   \begin{small}

.. productionlist::
 bracket_comment: '#' `bracket_argument`

.. raw:: latex

   \end{small}

For example:

::

 #[[This is a bracket comment.
 It runs until the close bracket.]]
 message("First Argument\n" #[[Bracket Comment]] "Second Argument")

.. note::
 CMake versions prior to 3.0 do not support bracket comments.
 They interpret the opening ``#`` as the start of a `Line Comment`_.

.. _`Line Comment`:

行注释
^^^^^^^^^^^^

A ``#`` not immediately followed by a :token:`bracket_open` forms a
*line comment* that runs until the end of the line:

.. raw:: latex

   \begin{small}

.. productionlist::
 line_comment: '#' <any text not starting in a `bracket_open`
             :      and not containing a `newline`>

.. raw:: latex

   \end{small}

For example:

.. code-block:: cmake

 # This is a line comment.
 message("First Argument\n" # This is a line comment :)
         "Second Argument") # This is a line comment.

控制结构
==================

条件块
------------------

The :command:`if`/:command:`elseif`/:command:`else`/:command:`endif`
commands delimit code blocks to be executed conditionally.

循环
-----

The :command:`foreach`/:command:`endforeach` and
:command:`while`/:command:`endwhile` commands delimit code
blocks to be executed in a loop.  Inside such blocks the
:command:`break` command may be used to terminate the loop
early whereas the :command:`continue` command may be used
to start with the next iteration immediately.

命令定义
-------------------

The :command:`macro`/:command:`endmacro`, and
:command:`function`/:command:`endfunction` commands delimit
code blocks to be recorded for later invocation as commands.

.. _`CMake Language Variables`:

变量
=========

Variables are the basic unit of storage in the CMake Language.
Their values are always of string type, though some commands may
interpret the strings as values of other types.
The :command:`set` and :command:`unset` commands explicitly
set or unset a variable, but other commands have semantics
that modify variables as well.
Variable names are case-sensitive and may consist of almost
any text, but we recommend sticking to names consisting only
of alphanumeric characters plus ``_`` and ``-``.

Variables have dynamic scope.  Each variable "set" or "unset"
creates a binding in the current scope:

Function Scope
 `命令定义`_ created by the :command:`function` command
 create commands that, when invoked, process the recorded commands
 in a new variable binding scope.  A variable "set" or "unset"
 binds in this scope and is visible for the current function and
 any nested calls within it, but not after the function returns.

Directory Scope
 Each of the `目录文件`_ in a source tree has its own variable
 bindings.  Before processing the ``CMakeLists.txt`` file for a
 directory, CMake copies all variable bindings currently defined
 in the parent directory, if any, to initialize the new directory
 scope.  CMake `脚本文件`_, when processed with ``cmake -P``, bind
 variables in one "directory" scope.

 A variable "set" or "unset" not inside a function call binds
 to the current directory scope.

Persistent Cache
 CMake stores a separate set of "cache" variables, or "cache entries",
 whose values persist across multiple runs within a project build
 tree.  Cache entries have an isolated binding scope modified only
 by explicit request, such as by the ``CACHE`` option of the
 :command:`set` and :command:`unset` commands.

When evaluating `Variable References`_, CMake first searches the
function call stack, if any, for a binding and then falls back
to the binding in the current directory scope, if any.  If a
"set" binding is found, its value is used.  If an "unset" binding
is found, or no binding is found, CMake then searches for a
cache entry.  If a cache entry is found, its value is used.
Otherwise, the variable reference evaluates to an empty string.
The ``$CACHE{VAR}`` syntax can be used to do direct cache entry
lookups.

The :manual:`cmake-variables(7)` manual documents the many variables
that are provided by CMake or have meaning to CMake when set
by project code.

.. include:: ID_RESERVE.txt

.. _`CMake Language Environment Variables`:

环境变量
=====================

Environment Variables are like ordinary `变量`_, with the
following differences:

Scope
 Environment variables have global scope in a CMake process.
 They are never cached.

References
 `Variable References`_ have the form ``$ENV{<variable>}``.

Initialization
 Initial values of the CMake environment variables are those of
 the calling process.
 Values can be changed using the :command:`set` and :command:`unset`
 commands.
 These commands only affect the running CMake process,
 not the system environment at large.
 Changed values are not written back to the calling process,
 and they are not seen by subsequent build or test processes.

The :manual:`cmake-env-variables(7)` manual documents environment
variables that have special meaning to CMake.

.. _`CMake Language Lists`:

列表
=====

Although all values in CMake are stored as strings, a string
may be treated as a list in certain contexts, such as during
evaluation of an `Unquoted Argument`_.  In such contexts, a string
is divided into list elements by splitting on ``;`` characters not
following an unequal number of ``[`` and ``]`` characters and not
immediately preceded by a ``\``.  The sequence ``\;`` does not
divide a value but is replaced by ``;`` in the resulting element.

A list of elements is represented as a string by concatenating
the elements separated by ``;``.  For example, the :command:`set`
command stores multiple values into the destination variable
as a list:

.. code-block:: cmake

 set(srcs a.c b.c c.c) # sets "srcs" to "a.c;b.c;c.c"

Lists are meant for simple use cases such as a list of source
files and should not be used for complex data processing tasks.
Most commands that construct lists do not escape ``;`` characters
in list elements, thus flattening nested lists:

.. code-block:: cmake

 set(x a "b;c") # sets "x" to "a;b;c", not "a;b\;c"
