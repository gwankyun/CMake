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

1. `括号 <Parentheses_>`_。

2. 一元测试，例如：

  * `存在性检查`_ :cref:`COMMAND`、 :cref:`DEFINED`、
    :cref:`DIAGNOSTIC`、 :cref:`EXISTS`、 :cref:`POLICY`、 :cref:`TARGET` 和
    :cref:`TEST`。
  * `文件操作`_ :cref:`IS_READABLE`、 :cref:`IS_WRITABLE`、
    :cref:`IS_EXECUTABLE`、 :cref:`IS_DIRECTORY`、 :cref:`IS_SYMLINK` 和
    :cref:`IS_ABSOLUTE`。

3. 二元测试，例如\ `比较`_、\ `版本比较`_\ 和\ `路径比较`_\ 中所描述的，\
   以及 :cref:`IN_LIST` 和 :cref:`IS_NEWER_THAN`。

4. 一元逻辑运算符 :cref:`NOT`。

5. 二元逻辑运算符 :cref:`AND` 和 :cref:`OR`，从左到右计算，
   不进行短路求值。

基础表达式
"""""""""""""""""

.. signature:: if(<constant>)
  :target: constant

  当常量为\ ``1``、\ ``ON``、\ ``YES``、\ ``TRUE``、\ ``Y``\ 或非零数值（含浮点数）时，结果为真。
  常量为\ ``0``、\ ``OFF``、\ ``NO``、\ ``FALSE``、\ ``N``、\ ``IGNORE``、\ ``NOTFOUND``、空字符串，
  或以\ ``-NOTFOUND``\ 后缀结尾时，结果为假。
  具名布尔常量不区分大小写。若参数不属于上述特定常量，
  则将其视为变量或字符串（参见下文的\ `变量展开`_），并适用以下两种形式之一。

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

.. signature:: if()
  :target: empty

  如果未提供参数则为 False。

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

.. signature:: if(DIAGNOSTIC <category>)

  .. versionadded:: 4.4

  若给定名称是已有的诊断类别，则为真。

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
    检查文件可读性时推荐使用\ :command:`if(IS_READABLE)`。未来版本中\ ``if(EXISTS)``\
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
  :ref:`Regex Specification`。\
  ``()`` 分组将被捕获到 :variable:`CMAKE_MATCH_<n>` 变量中。

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

版本比较
"""""""""""""""""""

.. signature:: if(<variable|string> VERSION_LESS <variable|string>)
  :target: VERSION_LESS

  逐组件的整数版本号比较（版本格式为\ ``major[.minor[.patch[.tweak]]]``，省略的组件\
  被视为零）。任何非整数版本组件或版本组件的非整数尾部都会在该位置截断字符串。

.. signature:: if(<variable|string> VERSION_GREATER <variable|string>)
  :target: VERSION_GREATER

  逐组件的整数版本号比较（版本格式为\ ``major[.minor[.patch[.tweak]]]``，省略的组件被\
  视为零）。任何非整数版本组件或版本组件的非整数尾部都会在该位置截断字符串。

.. signature:: if(<variable|string> VERSION_EQUAL <variable|string>)
  :target: VERSION_EQUAL

  逐组件的整数版本号比较（版本格式为\ ``major[.minor[.patch[.tweak]]]``，省略的组件被视为\
  零）。任何非整数版本组件或版本组件的非整数尾部都会在该位置截断字符串。

.. signature:: if(<variable|string> VERSION_LESS_EQUAL <variable|string>)
  :target: VERSION_LESS_EQUAL

  .. versionadded:: 3.7

  逐组件的整数版本号比较（版本格式为\ ``major[.minor[.patch[.tweak]]]``，省略的组件被视为\
  零）。任何非整数版本组件或版本组件的非整数尾部都会在该位置截断字符串。

.. signature:: if(<variable|string> VERSION_GREATER_EQUAL <variable|string>)
  :target: VERSION_GREATER_EQUAL

  .. versionadded:: 3.7

  逐组件的整数版本号比较（版本格式为\ ``major[.minor[.patch[.tweak]]]``，省略的组件被视为\
  零）。任何非整数版本组件或版本组件的非整数尾部都会在该位置截断字符串

路径比较
""""""""""""""""

.. signature:: if(<variable|string> PATH_EQUAL <variable|string>)
  :target: PATH_EQUAL

  .. versionadded:: 3.24

  按字典序逐组件比较两个CMake路径，不访问文件系统。只有当两个路径的每个组件都匹配时，\
  两个路径才比较相等。多个路径分隔符会被有效地合并为单个分隔符，但请注意反斜杠不会转换为\
  正斜杠。不执行其他\ :ref:`路径规范化 <Normalization>`。尾部斜杠会被保留，因此\ ``/a/b``\
  和\ ``/a/b/``\ 不相等。

  由于对多个路径分隔符的处理，逐组件比较优于基于字符串的比较。在以下示例中，使用\
  ``PATH_EQUAL``\ 时表达式求值为真，但使用\ ``STREQUAL``\ 时为假：

  .. code-block:: cmake

    # 比较为真
    if ("/a//b/c" PATH_EQUAL "/a/b/c")
       ...
    endif()

    # 比较为假
    if ("/a//b/c" STREQUAL "/a/b/c")
       ...
    endif()

  详见\ :command:`cmake_path(COMPARE)`。

变量展开
^^^^^^^^^^^^^^^^^^

if命令编写于CMake历史的早期，早于\ ``${}``\ 变量求值语法。为了方便起见，它会对\
其参数所命名的变量进行求值，如上述签名所示。请注意，使用\ ``${}``\ 的常规变量求\
值发生在if命令接收参数之前。因此，类似以下的代码：

.. code-block:: cmake

 set(var1 OFF)
 set(var2 "var1")
 if(${var2})

在if命令看来是：

.. code-block:: cmake

  if(var1)

并根据上文文档中的\ ``if(<variable>)``\ 情况进行求值。结果是\ ``OFF``，即为假。\
但是，如果我们从示例中删除\ ``${}``，那么该命令看到的是：

.. code-block:: cmake

  if(var2)

这是真，因为\ ``var2``\ 被定义为\ ``var1``，而不是一个假常量。

当上述文档的条件语法接受\ ``<variable|string>``\ 时，自动求值也适用于其他情况：

* 首先检查\  :cref:`MATCHES`\ 的左操作数是否为已定义的变量。如果是，则使用该变量的值，\
  否则使用原始值。

* 如果\ :cref:`MATCHES`\ 缺少左操作数，则返回假而不报错。

* :cref:`LESS`、\ :cref:`GREATER`、\ :cref:`EQUAL`、\ :cref:`LESS_EQUAL`\ 和\ :cref:`GREATER_EQUAL`\ 的左右\
  操作数会分别测试是否为已定义的变量。如果是，则使用其定义的值，否则使用原始值。

* :cref:`STRLESS`、\ :cref:`STRGREATER`、\ :cref:`STREQUAL`、\ :cref:`STRLESS_EQUAL`\ 和\ :cref:`STRGREATER_EQUAL`\
  的左右操作数会分别测试是否为已定义的变量。如果是，则使用其定义的值，否则使用原始值。

* :cref:`VERSION_LESS`、\ :cref:`VERSION_GREATER`、\ :cref:`VERSION_EQUAL`、\ :cref:`VERSION_LESS_EQUAL`\
  和\ :cref:`VERSION_GREATER_EQUAL`\ 的左右操作数会分别测试是否为已定义的变量。如果是，则使用其定义的值，\
  否则使用原始值。

* 首先测试\ :cref:`IN_LIST`\ 的左操作数是否为已定义的变量。如果是，则使用该变量的值，否则使用原始值。

* 测试\ :cref:`NOT`\ 的右操作数是否为布尔常量。如果是，则使用该值，否则假定其为变量并进行解引用。

* :cref:`AND`\ 和\ :cref:`OR`\ 的左右操作数会分别测试是否为布尔常量。如果是，则直接使用，否则假定其为\
  变量并进行解引用。

.. versionchanged:: 3.1
  为了防止歧义，可以在\ :ref:`Quoted Argument`\ 或\ :ref:`Bracket Argument`\
  中指定潜在的变量名或关键字名。带引号或括号的变量或关键字将被解释为字符串，而不会\
  被解引用或解释。参见策略\ :policy:`CMP0054`。

对于环境或缓存\ :ref:`Variable References`，不存在自动求值。在上述文档的条件语法接受\
``<variable|string>``\ 的任何地方，它们的值必须引用为\ ``$ENV{<name>}``\ 或\
``$CACHE{<name>}``。

参见
^^^^^^^^

* :command:`else`
* :command:`elseif`
* :command:`endif`
