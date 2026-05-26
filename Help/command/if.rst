if
--

有条件地执行一组命令。

概要
^^^^^^^^

.. code-block:: cmake

  if(<condition>)
    <commands>
  elseif(<condition>) # 可选块，可重复
    <commands>
  else()              # 可选块
    <commands>
  endif()

根据下方所述的\ :ref:`Condition syntax`\ 对\ ``if``\ 子句的\ ``condition``\ 参数进行求值。\
若结果为真，则执行\ ``if``\ 块中的\ ``commands``；
否则，将按相同方式处理可选的\ ``elseif``\ 块。
最终，若所有\ ``condition``\ 均为假，则执行可选\ ``else``\ 块中的\ ``commands``。

根据传统约定，:command:`else`\ 和\ :command:`endif`\ 命令允许接受一个可选的\ ``<condition>``\ 参数。
若使用，则必须为起始\ ``if``\ 命令参数的逐字重复。

.. _`Condition Syntax`:

条件语法
^^^^^^^^^^^^^^^^

适用于\ ``if``、\ ``elseif``\ 和\ :command:`while`\ 子句\ ``condition``\ 参数的语法规则如下。

复合条件的求值顺序按以下优先级进行：

1. `Parentheses`_。

2. 一元测试，包括\ `COMMAND`_、\ `POLICY`_、\ `TARGET`_、\ `TEST`_、
   `EXISTS`_、\ `IS_READABLE`_、\ `IS_WRITABLE`_、\ `IS_EXECUTABLE`_、
   `IS_DIRECTORY`_、\ `IS_SYMLINK`_、\ `IS_ABSOLUTE`_\ 以及\ `DEFINED`_。

3. 二元测试，包括\ `EQUAL`_、\ `LESS`_、\ `LESS_EQUAL`_、\ `GREATER`_、
   `GREATER_EQUAL`_、\ `STREQUAL`_、\ `STRLESS`_、\ `STRLESS_EQUAL`_、
   `STRGREATER`_、\ `STRGREATER_EQUAL`_、\ `VERSION_EQUAL`_、\ `VERSION_LESS`_、
   `VERSION_LESS_EQUAL`_、\ `VERSION_GREATER`_、\ `VERSION_GREATER_EQUAL`_、
   `PATH_EQUAL`_、\ `IN_LIST`_、\ `IS_NEWER_THAN`_\ 以及\ `MATCHES`_。

4. 一元逻辑运算符\ `NOT`_。

5. 二元逻辑运算符\ `AND`_\ 与\ `OR`_，从左到右依次求值，
   且无短路求值（short-circuit）行为。

基础表达式
"""""""""""""""""

.. signature:: if(<constant>)
  :target: constant

  当常量为\ ``1``、\ ``ON``、\ ``YES``、\ ``TRUE``、\ ``Y``\ 或非零数值（含浮点数）时，结果为真。
  常量为\ ``0``、\ ``OFF``、\ ``NO``、\ ``FALSE``、\ ``N``、\ ``IGNORE``、\ ``NOTFOUND``、空字符串，
  或以\ ``-NOTFOUND``\ 后缀结尾时，结果为假。
  具名布尔常量不区分大小写。若参数不属于上述特定常量，
  则将其视为变量或字符串（参见下文的\ `Variable Expansion`_），并适用以下两种形式之一。

.. signature:: if(<variable>)
  :target: variable

  当给定一个已定义为非假常量的变量时，结果为真。
  否则（包括变量未定义的情况）结果为假。
  注意：宏参数不属于变量范畴。
  :ref:`环境变量 <CMake Language Environment Variables>`\ 也无法通过此方式测试，
  例如\ ``if(ENV{some_var})``\ 将始终求值为假。

.. signature:: if(<string>)
  :target: string

  引号字符串通常求值为假，除非：

  * 字符串的值为真常量之一，或
  * 在CMake 4.0之前的版本中，策略\ :policy:`CMP0054`\ 未设置为\ ``NEW``，
    且字符串的值恰好是一个受\ :policy:`CMP0054`\ 行为影响的变量名。

逻辑运算符
"""""""""""""""

.. signature:: if(NOT <condition>)


  当条件不为真时，结果为真。

.. signature:: if(<cond1> AND <cond2>)
  :target: AND

  当两个条件各自求值均为真时，结果为真。

.. signature:: if(<cond1> OR <cond2>)
  :target: OR

  当任一条件求值为真时，结果为真。

.. signature:: if((condition) AND (condition OR (condition)))
  :target: parentheses

  括号内的条件优先求值，随后按其他示例中的方式处理剩余条件。
  嵌套括号时，最内层括号作为包含它们的条件的一部分优先求值。

存在性检查
""""""""""""""""

.. signature:: if(COMMAND <command-name>)

  当给定名称是可被调用的命令、宏或函数时，结果为真。

.. signature:: if(POLICY <policy-id>)

  当给定名称是存在的策略（格式为\ ``CMP<NNNN>``\ ）时，结果为真。

.. signature:: if(TARGET <target-name>)

  当给定名称是由\ :command:`add_executable`、\ :command:`add_library`\ 或\ 
  :command:`add_custom_target`\ 命令（已在任意目录中调用）创建的逻辑目标名时，结果为真。

.. signature:: if(TEST <test-name>)

  .. versionadded:: 3.3

  当给定名称是由\ :command:`add_test`\ 命令创建的测试名时，结果为真。

.. signature:: if(DEFINED <name>|CACHE{<name>}|ENV{<name>})

  当给定\ ``<name>``\ 的变量、缓存变量或环境变量已定义时，结果为真。\
  变量值不影响判断结果。需注意以下限制：

  * 宏参数不属于变量范畴。
  * 无法直接测试\ ``<name>``\ 是否为非缓存变量。表达式\ ``if(DEFINED someName)``\ 在\
    缓存或非缓存变量\ ``someName``\ 存在时均返回真。\
    相比之下，表达式\ ``if(DEFINED CACHE{someName})``\ 仅在缓存变量\ ``someName``\ 存在时返回真。\
    若需确认非缓存变量是否存在，需同时测试两个表达式：\
    ``if(DEFINED someName AND NOT DEFINED CACHE{someName})``。

 .. versionadded:: 3.14
  新增对\ ``CACHE{<名称>}``\ 变量的支持。

.. signature:: if(<variable|string> IN_LIST <variable>)
  :target: IN_LIST

  .. versionadded:: 3.3

  当给定元素包含于指定的列表变量中时，结果为真。

文件操作
"""""""""""""""

.. signature:: if(EXISTS <path-to-file-or-directory>)

  当指定文件或目录存在且可读时，结果为真。仅对显式完整路径行为有明确定义（开头的\
  ``~/``\ 不会扩展为家目录，将被视为相对路径）。解析符号链接，即当指定文件/目录为\
  符号链接时，若其目标存在则返回真。

  当给定路径为空字符串时，结果为假。

  .. note::
    检查文件可读性时推荐使用\ ``if(IS_READABLE)``。未来版本中\ ``if(EXISTS)``\
    可能仅检查文件存在性。

.. signature:: if(IS_READABLE <path-to-file-or-directory>)

  .. versionadded:: 3.29

  当指定文件或目录可读时，结果为真。仅对显式完整路径行为有明确定义（开头的\
  ``~/``\ 不会扩展为家目录，将被视为相对路径）。解析符号链接，即当指定\
  文件/目录为符号链接时，若其目标可读则返回真。

  当给定路径为空字符串时，结果为假。

.. signature:: if(IS_WRITABLE <path-to-file-or-directory>)

  .. versionadded:: 3.29

  当指定文件或目录可写时，结果为真。仅对显式完整路径行为有明确定义（开头的\ ``~/``\
  不会扩展为家目录，将被视为相对路径）。解析符号链接，即当指定文件/目录为符号链接时，\
  若其目标可写则返回真。

  当给定路径为空字符串时，结果为假。

.. signature:: if(IS_EXECUTABLE <path-to-file-or-directory>)

  .. versionadded:: 3.29

  当指定文件或目录可执行时，结果为真。仅对显式完整路径行为有明确定义（开头的\ ``~/``\
  不会扩展为家目录，将被视为相对路径）。解析符号链接，即当指定文件/目录为符号链接时，\
  若其目标可执行则返回真。

  当给定路径为空字符串时，结果为假。

.. signature:: if(<file1> IS_NEWER_THAN <file2>)
  :target: IS_NEWER_THAN

  当\ ``file1``\ 比\ ``file2``\ 更新，或其中一个文件不存在时，结果为真。\
  仅对完整路径行为有明确定义。若文件时间戳完全相同，\ ``IS_NEWER_THAN``\ 比较仍返回真，\
  以确保在时间戳相等时依赖的构建操作仍能执行。这包括为两个参数传入相同文件名的情况。

.. signature:: if(IS_DIRECTORY <path>)

  当\ ``path``\ 是目录时，结果为真。仅对完整路径行为有明确定义。

  当给定路径为空字符串时，结果为假。

.. signature:: if(IS_SYMLINK <path>)

  当给定路径是符号链接时，结果为真。仅对完整路径行为有明确定义。

.. signature:: if(IS_ABSOLUTE <path>)

  当给定路径是绝对路径时，结果为真。注意以下特殊情况：

  * 空\ ``path``\ 求值为假。
  * 在Windows主机上，任何以盘符和冒号（如\ ``C:``）、正斜杠或反斜杠开头的\ ``path``\
    均求值为真。这意味着类似\ ``C:no\base\dir``\ 的路径也会求值为真，尽管其非盘符部分\
    为相对路径。
  * 非Windows主机上，任何以波浪号（\ ``~``\ ）开头的\ ``path``\ 求值为真。

比较
"""""""""""

.. signature:: if(<variable|string> MATCHES <regex>)
  :target: MATCHES

  如果给定的字符串或变量的值与给定的正则表达式匹配，则为真。正则表达式的格式参见\
  :ref:`Regex Specification`。

  .. versionadded:: 2.6
   ``()``\ 分组捕获的结果保存在\ :variable:`CMAKE_MATCH_<n>`\ 变量中。

.. signature:: if(<variable|string> LESS <variable|string>)
  :target: LESS

  如果给定的字符串或变量的值能够解析为实数（类似于C语言的\ ``double``\ 类型），\
  并且小于右侧的值，则为真。

.. signature:: if(<variable|string> GREATER <variable|string>)
  :target: GREATER

  如果给定的字符串或变量的值能够解析为实数（类似于C语言的\ ``double``\ 类型），\
  并且大于右侧的值，则为真。

.. signature:: if(<variable|string> EQUAL <variable|string>)
  :target: EQUAL

  如果给定的字符串或变量的值能够解析为实数（类似于C语言的\ ``double``\ 类型），\
  并且等于右侧的值，则为真。

.. signature:: if(<variable|string> LESS_EQUAL <variable|string>)
  :target: LESS_EQUAL

  .. versionadded:: 3.7

  如果给定的字符串或变量的值能够解析为实数（类似于C语言的\ ``double``\ 类型），\
  并且小于或等于右侧的值，则为真。

.. signature:: if(<variable|string> GREATER_EQUAL <variable|string>)
  :target: GREATER_EQUAL

  .. versionadded:: 3.7

  如果给定的字符串或变量的值能够解析为实数（类似于C语言的\ ``double``\ 类型），
  并且大于或等于右侧的值，则为真。

.. signature:: if(<variable|string> STRLESS <variable|string>)
  :target: STRLESS

  如果给定的字符串或变量的值按字典序小于右侧的字符串或变量的值，则为真。

.. signature:: if(<variable|string> STRGREATER <variable|string>)
  :target: STRGREATER

  如果给定的字符串或变量的值按字典序大于右侧的字符串或变量的值，则为真。

.. signature:: if(<variable|string> STREQUAL <variable|string>)
  :target: STREQUAL

  如果给定的字符串或变量的值按字典序等于右侧的字符串或变量的值，则为真。

.. signature:: if(<variable|string> STRLESS_EQUAL <variable|string>)
  :target: STRLESS_EQUAL

  .. versionadded:: 3.7

  如果给定的字符串或变量的值按字典序小于或等于右侧的字符串或变量的值，则为真。

.. signature:: if(<variable|string> STRGREATER_EQUAL <variable|string>)
  :target: STRGREATER_EQUAL

  .. versionadded:: 3.7

  如果给定的字符串或变量的值按字典序大于或等于右侧的字符串或变量的值，则为真。

Version Comparisons
"""""""""""""""""""

.. signature:: if(<variable|string> VERSION_LESS <variable|string>)
  :target: VERSION_LESS

  Component-wise integer version number comparison (version format is
  ``major[.minor[.patch[.tweak]]]``, omitted components are treated as zero).
  Any non-integer version component or non-integer trailing part of a version
  component effectively truncates the string at that point.

.. signature:: if(<variable|string> VERSION_GREATER <variable|string>)
  :target: VERSION_GREATER

  Component-wise integer version number comparison (version format is
  ``major[.minor[.patch[.tweak]]]``, omitted components are treated as zero).
  Any non-integer version component or non-integer trailing part of a version
  component effectively truncates the string at that point.

.. signature:: if(<variable|string> VERSION_EQUAL <variable|string>)
  :target: VERSION_EQUAL

  Component-wise integer version number comparison (version format is
  ``major[.minor[.patch[.tweak]]]``, omitted components are treated as zero).
  Any non-integer version component or non-integer trailing part of a version
  component effectively truncates the string at that point.

.. signature:: if(<variable|string> VERSION_LESS_EQUAL <variable|string>)
  :target: VERSION_LESS_EQUAL

  .. versionadded:: 3.7

  Component-wise integer version number comparison (version format is
  ``major[.minor[.patch[.tweak]]]``, omitted components are treated as zero).
  Any non-integer version component or non-integer trailing part of a version
  component effectively truncates the string at that point.

.. signature:: if(<variable|string> VERSION_GREATER_EQUAL <variable|string>)
  :target: VERSION_GREATER_EQUAL

  .. versionadded:: 3.7

  Component-wise integer version number comparison (version format is
  ``major[.minor[.patch[.tweak]]]``, omitted components are treated as zero).
  Any non-integer version component or non-integer trailing part of a version
  component effectively truncates the string at that point.

Path Comparisons
""""""""""""""""

.. signature:: if(<variable|string> PATH_EQUAL <variable|string>)
  :target: PATH_EQUAL

  .. versionadded:: 3.24

  Lexicographically compares two CMake paths component-by-component without
  accessing the filesystem. Only if every component of both paths match will
  the two paths compare equal.  Multiple path separators are effectively
  collapsed into a single separator, but note that backslashes are not
  converted to forward slashes.
  No other :ref:`path normalization <Normalization>` is performed.
  Trailing slashes are preserved, thus ``/a/b`` and ``/a/b/`` are not equal.

  Component-wise comparison is superior to string-based comparison due to the
  handling of multiple path separators.  In the following example, the
  expression evaluates to true using ``PATH_EQUAL``, but false with
  ``STREQUAL``:

  .. code-block:: cmake

    # comparison is TRUE
    if ("/a//b/c" PATH_EQUAL "/a/b/c")
       ...
    endif()

    # comparison is FALSE
    if ("/a//b/c" STREQUAL "/a/b/c")
       ...
    endif()

  See :ref:`cmake_path(COMPARE) <Path Comparison>` for more details.

Variable Expansion
^^^^^^^^^^^^^^^^^^

The if command was written very early in CMake's history, predating
the ``${}`` variable evaluation syntax, and for convenience evaluates
variables named by its arguments as shown in the above signatures.
Note that normal variable evaluation with ``${}`` applies before the if
command even receives the arguments.  Therefore code like

.. code-block:: cmake

 set(var1 OFF)
 set(var2 "var1")
 if(${var2})

appears to the if command as

.. code-block:: cmake

  if(var1)

and is evaluated according to the ``if(<variable>)`` case documented
above.  The result is ``OFF`` which is false.  However, if we remove the
``${}`` from the example then the command sees

.. code-block:: cmake

  if(var2)

which is true because ``var2`` is defined to ``var1`` which is not a false
constant.

Automatic evaluation applies in the other cases whenever the
above-documented condition syntax accepts ``<variable|string>``:

* The left hand argument to `MATCHES`_ is first checked to see if it is
  a defined variable.  If so, the variable's value is used, otherwise the
  original value is used.

* If the left hand argument to `MATCHES`_ is missing it returns false
  without error

* Both left and right hand arguments to `LESS`_, `GREATER`_, `EQUAL`_,
  `LESS_EQUAL`_, and `GREATER_EQUAL`_, are independently tested to see if
  they are defined variables.  If so, their defined values are used otherwise
  the original value is used.

* Both left and right hand arguments to `STRLESS`_, `STRGREATER`_,
  `STREQUAL`_, `STRLESS_EQUAL`_, and `STRGREATER_EQUAL`_ are independently
  tested to see if they are defined variables.  If so, their defined values are
  used otherwise the original value is used.

* Both left and right hand arguments to `VERSION_LESS`_,
  `VERSION_GREATER`_, `VERSION_EQUAL`_, `VERSION_LESS_EQUAL`_, and
  `VERSION_GREATER_EQUAL`_ are independently tested to see if they are defined
  variables.  If so, their defined values are used otherwise the original value
  is used.

* The left hand argument to `IN_LIST`_ is tested to see if it is a defined
  variable.  If so, the variable's value is used, otherwise the original
  value is used.

* The right hand argument to `NOT`_ is tested to see if it is a boolean
  constant.  If so, the value is used, otherwise it is assumed to be a
  variable and it is dereferenced.

* The left and right hand arguments to `AND`_ and `OR`_ are independently
  tested to see if they are boolean constants.  If so, they are used as
  such, otherwise they are assumed to be variables and are dereferenced.

.. versionchanged:: 3.1
  To prevent ambiguity, potential variable or keyword names can be
  specified in a :ref:`Quoted Argument` or a :ref:`Bracket Argument`.
  A quoted or bracketed variable or keyword will be interpreted as a
  string and not dereferenced or interpreted.
  See policy :policy:`CMP0054`.

There is no automatic evaluation for environment or cache
:ref:`Variable References`.  Their values must be referenced as
``$ENV{<name>}`` or ``$CACHE{<name>}`` wherever the above-documented
condition syntax accepts ``<variable|string>``.

See also
^^^^^^^^

* :command:`else`
* :command:`elseif`
* :command:`endif`
