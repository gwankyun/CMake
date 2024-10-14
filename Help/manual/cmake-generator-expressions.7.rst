.. cmake-manual-description: CMake Generator Expressions

cmake-generator-expressions(7)
******************************

.. only:: html

   .. contents::

引言
============

生成器表达式在生成构建系统期间进行计算，以生成特定于每个构建配置的信息。它们的形式是\ ``$<...>``。例如：

.. code-block:: cmake

  target_include_directories(tgt PRIVATE /opt/include/$<CXX_COMPILER_ID>)

这将扩展到\ ``/opt/include/GNU``、\ ``/opt/include/Clang``\ 等，这取决于所使用的C++编译器。

生成器表达式可以在许多目标属性的上下文中使用，如\ :prop_tgt:`LINK_LIBRARIES`、\
:prop_tgt:`INCLUDE_DIRECTORIES`、:prop_tgt:`COMPILE_DEFINITIONS`\ 等。\
它们也可以在使用命令填充这些属性时使用，例如\ :command:`target_link_libraries`、\
:command:`target_include_directories`、:command:`target_compile_definitions`\ 等。\
它们支持条件链接、编译时使用的条件定义、条件包含目录等等。条件可能基于构建配置、目标属性、\
平台信息或任何其他可查询信息。

生成器表达式可以嵌套：

.. code-block:: cmake

  target_compile_definitions(tgt PRIVATE
    $<$<VERSION_LESS:$<CXX_COMPILER_VERSION>,4.2.0>:OLD_COMPILER>
  )

如果\ :variable:`CMAKE_CXX_COMPILER_VERSION <CMAKE_<LANG>_COMPILER_VERSION>`\
小于4.2.0，则上述内容将扩展为\ ``OLD_COMPILER``。

空格和引号
======================

生成器表达式通常在命令参数之后进行解析。如果生成器表达式包含空格、新行、分号或其他可能被解释\
为命令参数分隔符的字符，则整个表达式在传递给命令时应该用引号括起来。如果不这样做，可能会导致\
表达式被拆分，并且可能不再将其识别为生成器表达式。

当使用\ :command:`add_custom_command`\ 或\ :command:`add_custom_target`\ 时，\
使用\ ``VERBATIM``\ 和\ ``COMMAND_EXPAND_LISTS``\ 选项来获得健壮的参数分割和引用。

.. code-block:: cmake

  # WRONG: Embedded space will be treated as an argument separator.
  # This ends up not being seen as a generator expression at all.
  add_custom_target(run_some_tool
    COMMAND some_tool -I$<JOIN:$<TARGET_PROPERTY:tgt,INCLUDE_DIRECTORIES>, -I>
    VERBATIM
  )

.. code-block:: cmake

  # Better, but still not robust. Quotes prevent the space from splitting the
  # expression. However, the tool will receive the expanded value as a single
  # argument.
  add_custom_target(run_some_tool
    COMMAND some_tool "-I$<JOIN:$<TARGET_PROPERTY:tgt,INCLUDE_DIRECTORIES>, -I>"
    VERBATIM
  )

.. code-block:: cmake

  # Nearly correct. Using a semicolon to separate arguments and adding the
  # COMMAND_EXPAND_LISTS option means that paths with spaces will be handled
  # correctly. Quoting the whole expression ensures it is seen as a generator
  # expression. But if the target property is empty, we will get a bare -I
  # with nothing after it.
  add_custom_target(run_some_tool
    COMMAND some_tool "-I$<JOIN:$<TARGET_PROPERTY:tgt,INCLUDE_DIRECTORIES>,;-I>"
    COMMAND_EXPAND_LISTS
    VERBATIM
  )

使用变量构建更复杂的生成器表达式也是减少错误和提高可读性的好方法。上面的例子可以进一步改进如下：

.. code-block:: cmake

  # The $<BOOL:...> check prevents adding anything if the property is empty,
  # assuming the property value cannot be one of CMake's false constants.
  set(prop "$<TARGET_PROPERTY:tgt,INCLUDE_DIRECTORIES>")
  add_custom_target(run_some_tool
    COMMAND some_tool "$<$<BOOL:${prop}>:-I$<JOIN:${prop},;-I>>"
    COMMAND_EXPAND_LISTS
    VERBATIM
  )

最后，上面的例子可以用一种更简单和健壮的方式来表达，使用一个替代生成器表达式：

.. code-block:: cmake

  add_custom_target(run_some_tool
    COMMAND some_tool "$<LIST:TRANSFORM,$<TARGET_PROPERTY:tgt,INCLUDE_DIRECTORIES>,PREPEND,-I>"
    COMMAND_EXPAND_LISTS
    VERBATIM
  )

一个常见的错误是尝试用缩进将生成器表达式分割到多行：

.. code-block:: cmake

  # WRONG: New lines and spaces all treated as argument separators, so the
  # generator expression is split and not recognized correctly.
  target_compile_definitions(tgt PRIVATE
    $<$<AND:
        $<CXX_COMPILER_ID:GNU>,
        $<VERSION_GREATER_EQUAL:$<CXX_COMPILER_VERSION>,5>
      >:HAVE_5_OR_LATER>
  )

同样，使用名称选择良好的辅助变量来构建可读的表达式：

.. code-block:: cmake

  set(is_gnu "$<CXX_COMPILER_ID:GNU>")
  set(v5_or_later "$<VERSION_GREATER_EQUAL:$<CXX_COMPILER_VERSION>,5>")
  set(meet_requirements "$<AND:${is_gnu},${v5_or_later}>")
  target_compile_definitions(tgt PRIVATE
    "$<${meet_requirements}:HAVE_5_OR_LATER>"
  )

调试
=========

由于生成器表达式是在生成构建系统时计算的，而不是在处理\ ``CMakeLists.txt``\ 文件时计算的，\
因此不可能使用\ :command:`message()`\ 命令检查它们的结果。生成调试消息的一种可能的方法是\
添加一个自定义目标：

.. code-block:: cmake

  add_custom_target(genexdebug COMMAND ${CMAKE_COMMAND} -E echo "$<...>")

运行\ :program:`cmake`\ 之后，你可以构建\ ``genexdebug``\ 目标以打印\ ``$<...>``\
表达式（即执行命令\ :option:`cmake --build ... --target genexdebug <cmake--build --target>`）。

另一种方法是使用\ :command:`file(GENERATE)`\ 将调试消息写入文件：

.. code-block:: cmake

  file(GENERATE OUTPUT filename CONTENT "$<...>")

生成器表达式参考
==============================

.. note::

  这个参考偏离了大多数CMake文档，因为它省略了尖括号\ ``<...>``\ 围绕占位符，\ 如\
  ``condition``、\ ``string``、\ ``target``\ 等。这是为了防止那些占位符被错误地解释\
  为生成器表达式。

.. _`Conditional Generator Expressions`:

条件表达式
-----------------------

生成器表达式的一个基本类别与条件逻辑有关。支持两种形式的条件生成器表达式：

.. genex:: $<condition:true_string>

  如果\ ``condition``\ 为\ ``1``，则返回\ ``true_string``；如果\ ``condition``\ 为\
  ``0``，则返回空字符串。\ ``condition``\ 的任何其他值都会导致错误。

.. genex:: $<IF:condition,true_string,false_string>

  .. versionadded:: 3.8

  如果\ ``condition``\ 为\ ``1``，则返回\ ``true_string``；如果\ ``condition``\ 为\
  ``0``，则返回\ ``false_string``。\ ``condition``\ 的任何其他值都会导致错误。

  .. versionadded:: 3.28

    这个生成器表达式会短路，当\ ``condition``\ 为\ ``1``\ 时，\ ``false_string``\ 中\
    的生成器表达式不会求值，当\ ``condition``\ 为\ ``0``\ 时，\ ``true_string``\ 中\
    的生成器表达式不会求值。

通常，\ ``condition``\ 本身就是一个生成器表达式。例如，当使用\ ``Debug``\ 配置时，\
下面的表达式展开为\ ``DEBUG_MODE``，对于所有其他配置则为空字符串：

.. code-block:: cmake

  $<$<CONFIG:Debug>:DEBUG_MODE>

除\ ``1``\ 或\ ``0``\ 之外的类似布尔的\ ``condition``\ 值可以用\ ``$<BOOL:...>``\
生成器表达式包裹来处理：

.. genex:: $<BOOL:string>

  将\ ``string``\ 转换为\ ``0``\ 或\ ``1``。如果以下任意一个为真，则计算为\ ``0``：

  * ``string``\ 是空的，
  * ``string``\ 不区分大小写，等价为\ ``0``、``FALSE``、``OFF``、``N``、``NO``、\
    ``IGNORE``\ 或\ ``NOTFOUND``，或
  * ``string``\ 以\ ``-NOTFOUND``\ 后缀结束（区分大小写）。

  否则等于\ ``1``。

当CMake变量提供\ ``condition``\ 时，通常使用\ ``$<BOOL:...>``\ 生成器表达式：

.. code-block:: cmake

  $<$<BOOL:${HAVE_SOME_FEATURE}>:-DENABLE_SOME_FEATURE>


.. _`Boolean Generator Expressions`:

逻辑运算符
-----------------

支持常见的布尔逻辑运算符：

.. genex:: $<AND:conditions>

  其中\ ``conditions``\ 是一个以逗号分隔的布尔表达式列表，所有这些表达式的值必须为\ ``1``\
  或\ ``0``。如果所有条件都为\ ``1``，则整个表达式的值为\ ``1``。如果任何条件为\ ``0``，\
  整个表达式的计算结果为\ ``0``。

.. genex:: $<OR:conditions>

  其中\ ``conditions``\ 是逗号分隔的布尔表达式列表。所有这些都必须等于\ ``1``\ 或\ ``0``。\
  如果至少有一个条件为\ ``1``，则整个表达式的值为\ ``1``。如果所有条件的值为\ ``0``，\
  则整个表达式的值为\ ``0``。

.. genex:: $<NOT:condition>

  ``condition`` must be ``0`` or ``1``.  The result of the expression is
  ``0`` if ``condition`` is ``1``, else ``1``.

.. versionadded:: 3.28

  逻辑运算符会发生短路，一旦确定了返回值，就不会对参数列表中的生成器表达式进行求值。

.. _`Comparison Expressions`:

主要比较表达式
------------------------------

CMake支持各种生成器表达式进行比较。本节将介绍主要的和最广泛使用的比较类型。\
其他更具体的比较类型将在后面单独的部分中进行说明。

字符串比较
^^^^^^^^^^^^^^^^^^

.. genex:: $<STREQUAL:string1,string2>

  如果\ ``string1``\ 和\ ``string2``\ 相等，则为\ ``1``，否则为\ ``0``。比较是区分大\
  小写的。要进行不区分大小写的比较，请与\
  :ref:`字符串转换生成器表达式 <String Transforming Generator Expressions>`\ 结合使\
  用。例如，如果\ ``${foo}``\ 是\ ``BAR``、\ ``Bar``、\ ``bar``\ 等中的任意一个，则下\
  面的计算结果为\ ``1``。

  .. code-block:: cmake

    $<STREQUAL:$<UPPER_CASE:${foo}>,BAR>

.. genex:: $<EQUAL:value1,value2>

  如果\ ``value1``\ 和\ ``value2``\ 在数值上相等则为\ ``1``，否则为\ ``0``。

版本比较
^^^^^^^^^^^^^^^^^^^

.. genex:: $<VERSION_LESS:v1,v2>

  如果\ ``v1``\ 小于\ ``v2``，则为\ ``1``，否则为\ ``0``。

.. genex:: $<VERSION_GREATER:v1,v2>

  如果\ ``v1``\ 大于\ ``v2``\ 则为\ ``1``，否则为\ ``0``。

.. genex:: $<VERSION_EQUAL:v1,v2>

  如果\ ``v1``\ 和\ ``v2``\ 是同一个版本，则为\ ``1``，否则为\ ``0``。

.. genex:: $<VERSION_LESS_EQUAL:v1,v2>

  .. versionadded:: 3.7

  如果\ ``v1``\ 是小于等于\ ``v2``\ 的版本，则为\ ``1``，否则为\ ``0``。

.. genex:: $<VERSION_GREATER_EQUAL:v1,v2>

  .. versionadded:: 3.7

  如果\ ``v1``\ 是大于等于\ ``v2``\ 的版本，则为\ ``1``，否则为\ ``0``。

.. _`String Transforming Generator Expressions`:

字符串转换
----------------------

.. genex:: $<LOWER_CASE:string>

  转换为小写的\ ``string``\ 内容。

.. genex:: $<UPPER_CASE:string>

  转换为大写的\ ``string``\ 内容。

.. genex:: $<MAKE_C_IDENTIFIER:...>

  ``...``\ 的内容转换为C标识符。转换遵循与\ :command:`string(MAKE_C_IDENTIFIER)`\
  相同的行为。

列表表达式
----------------

本节中的大多数表达式都与\ :command:`list`\ 命令密切相关，提供相同的功能，但采用生成器表达\
式的形式。

在以下每个与列表相关的生成器表达式中，如果生成器表达式希望在\ ``list``\ 后提供某些内容，则该\
``list``\ 不得包含任何逗号。例如，表达式\ ``$<LIST:FIND,list,value>``\ 在\ ``list``\
后面需要一个\ ``value``。由于使用逗号分隔\ ``list``\ 和\ ``value``，因此列表本身不能包\
含逗号。此限制不适用于\ :command:`list`\ 命令，它仅特定于列表处理生成器表达式。

.. _GenEx List Comparisons:

列表比较
^^^^^^^^^^^^^^^^

.. genex:: $<IN_LIST:string,list>

  .. versionadded:: 3.12

  如果\ ``string``\ 是分号分隔\ ``list``\ 中的项，则为\ ``1``，否则为\ ``0``。\
  它使用区分大小写的比较。

.. _GenEx List Queries:

列表查询
^^^^^^^^^^^^

.. genex:: $<LIST:LENGTH,list>

  .. versionadded:: 3.27

  返回\ ``list``\ 项数

.. genex:: $<LIST:GET,list,index,...>

  .. versionadded:: 3.27

  返回列表中由索引指定的项\ ``list``。

.. genex:: $<LIST:SUBLIST,list,begin,length>

  .. versionadded:: 3.27

  返回给定\ ``list``\ 的子列表。如果\ ``length``\ 为0，则返回空列表。如果\ ``length``\
  为-1或列表小于\ ``begin + length``，则返回从\ ``begin``\ 开始的列表的其余项。

.. genex:: $<LIST:FIND,list,value>

  .. versionadded:: 3.27

  ``list``\ 中具有指定\ ``value``\ 的第一个项的索引，如果\ ``value``\ 不在\ ``list``\
  中，则为-1。

.. _GenEx List Transformations:

列表转换
^^^^^^^^^^^^^^^^^^^^

.. _GenEx LIST-JOIN:

.. genex:: $<LIST:JOIN,list,glue>

  .. versionadded:: 3.27

  将\ ``list``\ 转换为单个字符串，并在每个项之间插入\ ``glue``\ 字符串的内容。这在概念上与\
  :genex:`$<JOIN:list,glue>`\ 操作相同，但是两者对于空项的行为不同。\
  ``$<LIST:JOIN,list,glue>``\ 保留所有空项，而\ :genex:`$<JOIN:list,glue>`\ 从列表\
  中删除所有空项。

.. genex:: $<LIST:APPEND,list,item,...>

  .. versionadded:: 3.27

  附加所有\ ``item``\ 的\ ``list``。多个项之间应该用逗号分隔。

.. genex:: $<LIST:PREPEND,list,item,...>

  .. versionadded:: 3.27

  在\ ``list``\ 的开头插入每个\ ``item``。如果有多个项，则应以逗号分隔，并保留前置项的顺序。

.. genex:: $<LIST:INSERT,list,index,item,...>

  .. versionadded:: 3.27

  在指定索引处插入\ ``item``\ （或多个项）的\ ``list``。多个项之间应该用逗号分隔。

  指定超出范围的\ ``index``\ 是错误的。有效的索引范围是0到N，其中N是列表的长度，包括列表的\
  长度。空列表的长度为0。

.. genex:: $<LIST:POP_BACK,list>

  .. versionadded:: 3.27

  返回一个删除最后一个项的\ ``list``。

.. genex:: $<LIST:POP_FRONT,list>

  .. versionadded:: 3.27

  返回删除第一个项的\ ``list``。

.. genex:: $<LIST:REMOVE_ITEM,list,value,...>

  .. versionadded:: 3.27

  删除给定\ ``value``\ （或多个值）的所有实例的\ ``list``。如果给出了多个值，它们之间应\
  该用逗号分隔。

.. genex:: $<LIST:REMOVE_AT,list,index,...>

  .. versionadded:: 3.27

  返回一个\ ``list``，其中给定\ ``index``\ 处的所有值都已删除。

.. _GenEx LIST-REMOVE_DUPLICATES:

.. genex:: $<LIST:REMOVE_DUPLICATES,list>

  .. versionadded:: 3.27

  返回删除重复项的\ ``list``。保留条目的相对顺序，但如果遇到重复项，则只保留第一个实例。结\
  果与\ :genex:`$<REMOVE_DUPLICATES:list>`\ 相同。

.. _GenEx LIST-FILTER:

.. genex:: $<LIST:FILTER,list,INCLUDE|EXCLUDE,regex>

  .. versionadded:: 3.27

  ``list``\ 中匹配（\ ``INCLUDE``\ ）或不匹配（\ ``EXCLUDE``\ ）正则表达式\ ``regex``\
  的项的列表。结果与\ :genex:`$<FILTER:list,INCLUDE|EXCLUDE,regex>`\ 相同。

.. genex:: $<LIST:TRANSFORM,list,ACTION[,SELECTOR]>

  .. versionadded:: 3.27

  通过对\ ``list``\ 中的所有项应用\ ``ACTION``\ 或指定一个\ ``SELECTOR``，返回转换后的列表。

  .. note::

    ``TRANSFORM``\ 子命令不改变列表中元素的数量。如果指定了\ ``SELECTOR``，则只有一些项\
    会被更改，其他项将保持与转换前相同。

  ``ACTION``\ 指定应用于列表项的操作。操作具有与\ :command:`list(TRANSFORM)`\ 命令完\
  全相同的语义。\ ``ACTION``\ 必须是以下选项之一：

    :command:`APPEND <list(TRANSFORM_APPEND)>`, :command:`PREPEND <list(TRANSFORM_APPEND)>`
      将指定的值追加到列表的每个项。

      .. code-block:: cmake

        $<LIST:TRANSFORM,list,(APPEND|PREPEND),value[,SELECTOR]>

    :command:`TOLOWER <list(TRANSFORM_TOLOWER)>`, :command:`TOUPPER <list(TRANSFORM_TOLOWER)>`
      将列表中的每个项转换为大小写字符。

      .. code-block:: cmake

        $<LIST:TRANSFORM,list,(TOLOWER|TOUPPER)[,SELECTOR]>

    :command:`STRIP <list(TRANSFORM_STRIP)>`
      从列表的每个项中删除前导和尾随空格。

      .. code-block:: cmake

        $<LIST:TRANSFORM,list,STRIP[,SELECTOR]>

    :command:`REPLACE <list(TRANSFORM_REPLACE)>`:
      尽可能多地匹配正则表达式，并用替换表达式替换列表中每个项的匹配项。

      .. code-block:: cmake

        $<LIST:TRANSFORM,list,REPLACE,regular_expression,replace_expression[,SELECTOR]>

  ``SELECTOR``\ 决定列表中的哪些项将被转换。一次只能指定一种类型的选择器。当给定时，\
  ``SELECTOR``\ 必须是下列之一：

    ``AT``
      指定索引列表。

      .. code-block:: cmake

        $<LIST:TRANSFORM,list,ACTION,AT,index[,index...]>

    ``FOR``
      指定一个范围，并使用可选的增量来迭代该范围。

      .. code-block:: cmake

        $<LIST:TRANSFORM,list,ACTION,FOR,start,stop[,step]>

    ``REGEX``
      指定正则表达式。只有匹配正则表达式的项才会被转换。

      .. code-block:: cmake

        $<LIST:TRANSFORM,list,ACTION,REGEX,regular_expression>

.. genex:: $<JOIN:list,glue>

  用插入在每个项目之间的\ ``glue``\ 字符串内容连接\ ``list``。这在概念上与\
  :ref:`$\<LIST:JOIN,list,glue\> <GenEx LIST-JOIN>`\ 操作相同，但是两者对于空项的行\
  为不同。\ :ref:`$\<LIST:JOIN,list,glue\> <GenEx LIST-JOIN>`\ 保留所有空项，而\
  ``$<JOIN,list,glue>``\ 从列表中删除所有空项。

.. genex:: $<REMOVE_DUPLICATES:list>

  .. versionadded:: 3.15

  删除给定\ ``list``\ 中的重复项。保留项的相对顺序，并且如果遇到重复项，则只保留第一个实例。\
  结果与\ :ref:`$\<LIST:REMOVE_DUPLICATES,list\> <GenEx LIST-REMOVE_DUPLICATES>`\
  相同。

.. genex:: $<FILTER:list,INCLUDE|EXCLUDE,regex>

  .. versionadded:: 3.15

  从\ ``list``\ 中包含或删除与正则表达式\ ``regex``\ 匹配的项。结果与\
  :ref:`$\<LIST:FILTER,list,INCLUDE|EXCLUDE,regex\> <GenEx LIST-FILTER>`\ 相同。

.. _GenEx List Ordering:

列表排序
^^^^^^^^^^^^^

.. genex:: $<LIST:REVERSE,list>

  .. versionadded:: 3.27

  返回项以相反顺序排列的\ ``list``。

.. genex:: $<LIST:SORT,list[,(COMPARE:option|CASE:option|ORDER:option)]...>

  .. versionadded:: 3.27

  返回按指定选项排序的\ ``list``。

  使用\ ``COMPARE``\ 选项之一来选择排序的比较方法：

    ``STRING``
      按字母顺序对字符串列表进行排序。如果没有给出\ ``COMPARE``\ 选项，这是默认行为。

    ``FILE_BASENAME``
      按基本名称对文件路径名列表进行排序。

    ``NATURAL``
      使用自然顺序对字符串列表进行排序（请参阅\ ``strverscmp(3)``\ 的手册页），以便将连\
      续数字作为整数进行比较。例如，如果选择了\ ``NATURAL``\ 比较，下面的列表\
      ``10.0 1.1 2.1 8.0 2.0 3.1``\ 将被排序为\ ``1.1 10.0 2.0 2.1 3.1 8.0``，而\
      如果选择了\ ``STRING``\ 比较，它将被排序为\ ``1.1 10.0 2.0 2.1 3.1 8.0``。

  使用\ ``CASE``\ 选项之一来选择区分大小写或不区分大小写的排序模式：

    ``SENSITIVE``
      列表项以区分大小写的方式排序。如果没有给出\ ``CASE``\ 选项，这是默认行为。

    ``INSENSITIVE``
      列表项的排序不区分大小写。仅大小写不同的项的顺序未指定。

  要控制排序顺序，可以给出\ ``ORDER``\ 选项之一：

    ``ASCENDING``
      按升序对列表进行排序。这是未给出\ ``ORDER``\ 选项时的默认行为。

    ``DESCENDING``
      按降序对列表进行排序。

  可以按任意顺序指定各种选项，但多次指定相同的选项是错误的。

  .. code-block:: cmake

    $<LIST:SORT,list,CASE:SENSITIVE,COMPARE:STRING,ORDER:DESCENDING>

路径表达式
----------------

本节中的大多数表达式都与\ :command:`cmake_path`\ 命令密切相关，提供相同的功能，\
但是是以生成器表达式的形式。

对于本节中的所有生成器表达式，路径都应该是cmake样式的格式。:ref:`$\<PATH:CMAKE_PATH\> <GenEx PATH-CMAKE_PATH>`\
生成器表达式可用于将本机路径转换为cmake样式的路径。

.. _GenEx Path Comparisons:

路径比较
^^^^^^^^^^^^^^^^

.. genex:: $<PATH_EQUAL:path1,path2>

  .. versionadded:: 3.24

  比较两个路径的词法表示。在任何路径上都不执行归一化。如果路径相等则返回\ ``1``，否则返回\ ``0``。

  有关更多细节，请参阅\ :ref:`cmake_path(COMPARE) <Path COMPARE>`。

.. _GenEx Path Queries:

路径查询
^^^^^^^^^^^^

这些表达式提供了等同于\ :command:`cmake_path`\ 命令的\ :ref:`Query <Path Query>`\
选项的生成时功能。所有路径都应该是cmake样式的格式。

.. genex:: $<PATH:HAS_*,path>

  .. versionadded:: 3.24

  如果存在特定的路径组件，则返回\ ``1``，否则返回\ ``0``。有关每个路径组件的含义，\
  请参阅\ :ref:`Path Structure And Terminology`。

  ::

    $<PATH:HAS_ROOT_NAME,path>
    $<PATH:HAS_ROOT_DIRECTORY,path>
    $<PATH:HAS_ROOT_PATH,path>
    $<PATH:HAS_FILENAME,path>
    $<PATH:HAS_EXTENSION,path>
    $<PATH:HAS_STEM,path>
    $<PATH:HAS_RELATIVE_PART,path>
    $<PATH:HAS_PARENT_PATH,path>

  注意以下特殊情况：

  * 对于\ ``HAS_ROOT_PATH``，只有当\ ``root-name``\ 或\ ``root-directory``\
    中至少有一个非空时，才会返回true结果。

  * 对于\ ``HAS_PARENT_PATH``，根目录也被认为有一个父目录，即它本身。\
    除非路径仅由\ :ref:`filename <FILENAME_DEF>`\ 组成，否则结果为真。

.. genex:: $<PATH:IS_ABSOLUTE,path>

  .. versionadded:: 3.24

  如果路径是\ :ref:`absolute <IS_ABSOLUTE>`\ 路径则返回\ ``1``，否则返回\ ``0``。

.. genex:: $<PATH:IS_RELATIVE,path>

  .. versionadded:: 3.24

  这将返回与\ ``IS_ABSOLUTE``\ 相反的结果。

.. genex:: $<PATH:IS_PREFIX[,NORMALIZE],path,input>

  .. versionadded:: 3.24

  如果\ ``path``\ 是\ ``input``\ 的前缀，则返回\ ``1``，否则返回\ ``0``。

  当指定\ ``NORMALIZE``\ 选项时，\ ``path``\ 和\ ``input``\ 在检查之前被\
  :ref:`normalized <Normalization>`。

.. _GenEx Path Decomposition:

路径分解
^^^^^^^^^^^^^^^^^^

这些表达式提供了等同于\ :command:`cmake_path`\ 命令的\ :ref:`Decomposition <Path Decomposition>`\
选项的生成时功能。所有路径都应该是cmake样式的格式。

.. genex:: $<PATH:GET_*,...>

  .. versionadded:: 3.24

  以下操作从路径中检索不同的组件或组件组。有关每个路径组件的含义，请参阅\ :ref:`Path Structure And Terminology`。

  .. versionchanged:: 3.27
    现在所有的操作都接受一个路径列表作为参数。当指定了路径列表时，该操作将应用于每个路径。

  ::

    $<PATH:GET_ROOT_NAME,path...>
    $<PATH:GET_ROOT_DIRECTORY,path...>
    $<PATH:GET_ROOT_PATH,path...>
    $<PATH:GET_FILENAME,path...>
    $<PATH:GET_EXTENSION[,LAST_ONLY],path...>
    $<PATH:GET_STEM[,LAST_ONLY],path...>
    $<PATH:GET_RELATIVE_PART,path...>
    $<PATH:GET_PARENT_PATH,path...>

  如果请求的组件不在路径中，则返回空字符串。

.. _GenEx Path Transformations:

路径转换
^^^^^^^^^^^^^^^^^^^^

这些表达式提供了等同于\ :command:`cmake_path`\ 命令的\ :ref:`Modification <Path Modification>`\
和\ :ref:`Generation <Path Generation>`\ 选项的生成时功能。所有路径都应该是cmake样式的格式。

.. versionchanged:: 3.27
  现在所有的操作都接受一个路径列表作为参数。当指定了路径列表时，该操作将应用于每个路径。


.. _GenEx PATH-CMAKE_PATH:

.. genex:: $<PATH:CMAKE_PATH[,NORMALIZE],path...>

  .. versionadded:: 3.24

  返回\ ``path``。如果\ ``path``\ 是原生路径，它将转换为带有正斜杠（\ ``/``\ ）的cmake\
  样式的路径。在Windows上，长文件名标记会被考虑在内。

  当指定\ ``NORMALIZE``\ 选项时，转换后将对路径进行\ :ref:`normalized
  <Normalization>`。

.. genex:: $<PATH:APPEND,path...,input,...>

  .. versionadded:: 3.24

  返回以\ ``/``\ 作为\ ``directory-separator``\ 附加到\ ``path``\ 的所有\ ``input``\
  参数。根据\ ``input``\ 的不同，\ ``path``\ 的值可能会被丢弃。

  请参阅\ :ref:`cmake_path(APPEND) <APPEND>`\ 了解更多详细信息。

.. genex:: $<PATH:REMOVE_FILENAME,path...>

  .. versionadded:: 3.24

  返回删除了文件名组件（由\ ``$<PATH:GET_FILENAME>``\ 返回）的\ ``path``。删除之后，\
  任何尾随的\ ``directory-separator``\ （如果存在的话）都将保持不变。

  参见\ :ref:`cmake_path(REMOVE_FILENAME) <REMOVE_FILENAME>`\ 了解更多细节。

.. genex:: $<PATH:REPLACE_FILENAME,path...,input>

  .. versionadded:: 3.24

  返回\ ``path``，其中文件组件被\ ``input``\ 替换。如果\ ``path``\ 没有文件名组件\
  （例如\ ``$<PATH:HAS_FILENAME>``\ 返回\ ``0``），\ ``path``\ 不变。

  参见\ :ref:`cmake_path(REPLACE_FILENAME) <REPLACE_FILENAME>`\ 了解更多细节。

.. genex:: $<PATH:REMOVE_EXTENSION[,LAST_ONLY],path...>

  .. versionadded:: 3.24

  返回已删除\ :ref:`extension <EXTENSION_DEF>`\ 的\ ``path``，如果有的话。

  有关详细信息，请参阅\ :ref:`cmake_path(REMOVE_EXTENSION) <REMOVE_EXTENSION>`。

.. genex:: $<PATH:REPLACE_EXTENSION[,LAST_ONLY],path...,input>

  .. versionadded:: 3.24

  返回\ ``path``，其中\ :ref:`extension <EXTENSION_DEF>`\ 替换为\ ``input``，\
  如果有的话。

  详细信息请参见\ :ref:`cmake_path(REPLACE_EXTENSION) <REPLACE_EXTENSION>`。

.. genex:: $<PATH:NORMAL_PATH,path...>

  .. versionadded:: 3.24

  返回根据\ :ref:`Normalization`\ 中描述的步骤归一化的\ ``path``。

.. genex:: $<PATH:RELATIVE_PATH,path...,base_directory>

  .. versionadded:: 3.24

  返回\ ``path``，修改后使其相对于\ ``base_directory``\ 参数。

  有关更多细节，请参阅\ :ref:`cmake_path(RELATIVE_PATH) <cmake_path-RELATIVE_PATH>`。

.. genex:: $<PATH:ABSOLUTE_PATH[,NORMALIZE],path...,base_directory>

  .. versionadded:: 3.24

  返回绝对\ ``path``。如果\ ``path``\ 是一个相对路径（\ ``$<PATH:IS_RELATIVE>``\ 返回\
  ``1``），它将相对于\ ``base_directory``\ 参数指定的给定基目录进行计算。

  当指定\ ``NORMALIZE``\ 选项时，在路径计算之后对路径进行\ :ref:`normalized <Normalization>`。

  有关详细信息，请参阅\ :ref:`cmake_path(ABSOLUTE_PATH) <ABSOLUTE_PATH>`。

Shell路径
^^^^^^^^^^^

.. genex:: $<SHELL_PATH:...>

  .. versionadded:: 3.4

  ``...``\ 的内容转换为shell路径样式。例如，Windows shell中将斜杠转换为反斜杠，\
  MSYS shell将盘符转换为posix路径。\ ``...``\ 必须为绝对路径。

  .. versionadded:: 3.14
    ``...``\ 可以是一个以\ :ref:`以分号分隔的列表 <CMake Language Lists>`，\
    在这种情况下，每个路径都被单独转换，并且使用shell路径分隔符（\ ``:``\ 之于POSIX及\
    ``;``\ 之于Windows）。在CMake源代码中，请务必将包含此genex的参数括在双引号中，\
    以确保参数不被\ ``;``\ 隔开。

配置表达式
-------------------------

.. genex:: $<CONFIG>

  配置名称。使用此表达式代替已弃用的\ :genex:`CONFIGURATION`\ 生成器表达式。

.. genex:: $<CONFIG:cfgs>

  如果config是逗号分隔的列表\ ``cfgs``\ 中的任何一项，则为\ ``1``，否则为\ ``0``。\
  这是一个不区分大小写的比较。当在\ :prop_tgt:`IMPORTED`\ 目标的属性上计算\
  :prop_tgt:`MAP_IMPORTED_CONFIG_<CONFIG>`\ 中的映射时，此表达式也会考虑它。

  .. versionchanged:: 3.19
    可以为\ ``cfgs``\ 指定多种配置。CMake 3.18和更早的版本只接受单一配置。

.. genex:: $<OUTPUT_CONFIG:...>

  .. versionadded:: 3.20

  仅在\ :command:`add_custom_command`\ 和\ :command:`add_custom_target`\ 中作为参\
  数中的最外层生成器表达式有效。对于\ :generator:`Ninja Multi-Config`\ 生成器，生成器表\
  达式在\ ``...``\ 使用自定义命令的“输出配置”进行计算。使用其他生成器，\ ``...``\ 正常计算。

.. genex:: $<COMMAND_CONFIG:...>

  .. versionadded:: 3.20

  仅在\ :command:`add_custom_command`\ 和\ :command:`add_custom_target`\ 中作为参\
  数中的最外层生成器表达式有效。对于\ :generator:`Ninja Multi-Config`\ 生成器，生成器表\
  达式在\ ``...``\ 使用自定义命令的“命令配置”进行计算。使用其他生成器，\ ``...``\ 正常计算。

工具链和语言表达式
----------------------------------

平台
^^^^^^^^

.. genex:: $<PLATFORM_ID>

  当前系统的CMake平台标识。参考\ :variable:`CMAKE_SYSTEM_NAME`\ 变量。

.. genex:: $<PLATFORM_ID:platform_ids>

  如果CMake的平台id与逗号分隔的\ ``platform_ids``\ 列表中的任何一个项匹配，则为\ ``1``，\
  否则为\ ``0``。另请参阅\ :variable:`CMAKE_SYSTEM_NAME`\ 变量。

编译器版本
^^^^^^^^^^^^^^^^

另请参阅\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量，该变量与本小节中的表达式密切相关。

.. genex:: $<C_COMPILER_VERSION>

  使用的C编译器版本。

.. genex:: $<C_COMPILER_VERSION:version>

  如果C编译器的版本与\ ``version``\ 匹配，则为\ ``1``，否则为\ ``0``。

.. genex:: $<CXX_COMPILER_VERSION>

  使用的CXX编译器的版本。

.. genex:: $<CXX_COMPILER_VERSION:version>

  如果C++编译器的版本与\ ``version``\ 匹配，则为\ ``1``，否则为\ ``0``。

.. genex:: $<CUDA_COMPILER_VERSION>

  .. versionadded:: 3.15

  使用的CUDA编译器的版本。

.. genex:: $<CUDA_COMPILER_VERSION:version>

  .. versionadded:: 3.15

  如果C++编译器的版本与\ ``version``\ 匹配，则为\ ``1``，否则为\ ``0``。

.. genex:: $<OBJC_COMPILER_VERSION>

  .. versionadded:: 3.16

  使用的Objective-C编译器的版本。

.. genex:: $<OBJC_COMPILER_VERSION:version>

  .. versionadded:: 3.16

  如果Objective-C编译器的版本与\ ``version``\ 匹配，则为\ ``1``，否则为\ ``0``。

.. genex:: $<OBJCXX_COMPILER_VERSION>

  .. versionadded:: 3.16

  使用的Objective-C++编译器的版本。

.. genex:: $<OBJCXX_COMPILER_VERSION:version>

  .. versionadded:: 3.16

  如果Objective-C++编译器的版本与\ ``version``\ 匹配，则为\ ``1``，否则为\ ``0``。

.. genex:: $<Fortran_COMPILER_VERSION>

  使用的Fortran编译器的版本。

.. genex:: $<Fortran_COMPILER_VERSION:version>

  如果Fortran编译器的版本与\ ``version``\ 匹配，则为\ ``1``，否则为\ ``0``。

.. genex:: $<HIP_COMPILER_VERSION>

  .. versionadded:: 3.21

  使用的HIP编译器的版本。

.. genex:: $<HIP_COMPILER_VERSION:version>

  .. versionadded:: 3.21

  如果HIP编译器的版本与\ ``version``\ 匹配，则为\ ``1``，否则为\ ``0``。

.. genex:: $<ISPC_COMPILER_VERSION>

  .. versionadded:: 3.19

  使用的ISPC编译器的版本。

.. genex:: $<ISPC_COMPILER_VERSION:version>

  .. versionadded:: 3.19

  如果ISPC编译器的版本与\ ``version``\ 匹配，则为\ ``1``，否则为\ ``0``。

编译语言、ID和前端变体
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

另请参阅\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 和\
:variable:`CMAKE_<LANG>_COMPILER_FRONTEND_VARIANT`\ 变量，它们与本节中的大多数表达式\
密切相关。

.. genex:: $<C_COMPILER_ID>

  CMake使用的C编译器的id。

.. genex:: $<C_COMPILER_ID:compiler_ids>

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的C编译器id与\ ``compiler_ids``\
  中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

  .. versionchanged:: 3.15
    可以指定多个\ ``compiler_ids``。CMake 3.14和更早的版本只接受一个编译器ID。

.. genex:: $<CXX_COMPILER_ID>

  CMake使用的C++编译器的id。

.. genex:: $<CXX_COMPILER_ID:compiler_ids>

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的C++编译器id与\ ``compiler_ids``\
  中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

  .. versionchanged:: 3.15
    可以指定多个\ ``compiler_ids``。CMake 3.14和更早的版本只接受一个编译器ID。

.. genex:: $<CUDA_COMPILER_ID>

  .. versionadded:: 3.15

  CMake使用的CUDA编译器的id。

.. genex:: $<CUDA_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.15

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的CUDA编译器id与\ ``compiler_ids``\
  中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

.. genex:: $<OBJC_COMPILER_ID>

  .. versionadded:: 3.16

  CMake使用的Objective-C编译器的id。

.. genex:: $<OBJC_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.16

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的Objective-C编译器id与\
  ``compiler_ids``\ 中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

.. genex:: $<OBJCXX_COMPILER_ID>

  .. versionadded:: 3.16

  CMake使用的Objective-C++编译器的id。

.. genex:: $<OBJCXX_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.16

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的Objective-C++编译器id与\
  ``compiler_ids``\ 中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

.. genex:: $<Fortran_COMPILER_ID>

  CMake使用的Fortran编译器的id。

.. genex:: $<Fortran_COMPILER_ID:compiler_ids>

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的Fortran编译器id与\
  ``compiler_ids``\ 中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

  .. versionchanged:: 3.15
    可以指定多个\ ``compiler_ids``。CMake 3.14和更早的版本只接受一个编译器ID。

.. genex:: $<HIP_COMPILER_ID>

  .. versionadded:: 3.21

  CMake使用的HIP编译器的id。

.. genex:: $<HIP_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.21

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的HIP编译器id与\
  ``compiler_ids``\ 中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

.. genex:: $<ISPC_COMPILER_ID>

  .. versionadded:: 3.19

  CMake使用的ISPC编译器的id。

.. genex:: $<ISPC_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.19

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的ISPC编译器id与\
  ``compiler_ids``\ 中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

.. genex:: $<C_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake编译器使用的C编译器前端变体。

.. genex:: $<C_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果C编译器的CMake编译器前端版本匹配\
  ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。

.. genex:: $<CXX_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake编译器使用的C++编译器前端变体。

.. genex:: $<CXX_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的C++编译器前端版本匹配\
  ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。

.. genex:: $<CUDA_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake使用的CUDA编译器的编译器id。

.. genex:: $<CUDA_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CUDA编译器的CMake编译器前端变体匹配\
  ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。

.. genex:: $<OBJC_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake使用的Objective-C编译器前端变种。

.. genex:: $<OBJC_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake编译器前端版本的Objective-C\
  编译器匹配\ ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。

.. genex:: $<OBJCXX_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake使用的Objective-C++编译器前端变种。

.. genex:: $<OBJCXX_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake编译器前端版本的Objective-C++\
  编译器匹配\ ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。

.. genex:: $<Fortran_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake使用的Fortran编译器id。

.. genex:: $<Fortran_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake编译器前端版本的Fortran编译器\
  匹配\ ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。

.. genex:: $<HIP_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake使用的HIP编译器id。

.. genex:: $<HIP_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake编译器前端版本的HIP编译器匹配\
  ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。

.. genex:: $<ISPC_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake使用的ISPC编译器id。

.. genex:: $<ISPC_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake编译器前端版本的ISPC编译器匹配\
  ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。

.. genex:: $<COMPILE_LANGUAGE>

  .. versionadded:: 3.3

  计算编译选项时源文件的编译语言。关于生成器表达式的可移植性，请参阅\
  :ref:`相关的布尔表达式 <Boolean COMPILE_LANGUAGE Generator Expression>`\
  ``$<COMPILE_LANGUAGE:language>``。

.. _`Boolean COMPILE_LANGUAGE Generator Expression`:

.. genex:: $<COMPILE_LANGUAGE:languages>

  .. versionadded:: 3.3

  .. versionchanged:: 3.15
    可以为\ ``languages``\ 指定多种语言。CMake 3.14及更早版本只接受单一语言。

  当用于编译单元的语言与\ ``languages``\ 中任何以逗号分隔的条目匹配时，则为\ ``1``，\
  否则为\ ``0``。此表达式可用于指定编译选项、编译定义，并在目标中包含特定语言的源文件的目录。\
  例如：

  .. code-block:: cmake

    add_executable(myapp main.cpp foo.c bar.cpp zot.cu)
    target_compile_options(myapp
      PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
    )
    target_compile_definitions(myapp
      PRIVATE $<$<COMPILE_LANGUAGE:CXX>:COMPILING_CXX>
              $<$<COMPILE_LANGUAGE:CUDA>:COMPILING_CUDA>
    )
    target_include_directories(myapp
      PRIVATE $<$<COMPILE_LANGUAGE:CXX,CUDA>:/opt/foo/headers>
    )

  这指定了仅用于C++的（编译器id检查省略）\ ``-fno-exceptions``\ 编译选项、\
  ``COMPILING_CXX``\ 编译定义和\ ``cxx_headers``\ 包含目录。它还为CUDA指定了\
  ``COMPILING_CUDA``\ 编译定义。

  注意，在\ :ref:`Visual Studio Generators`\ 和\ :generator:`Xcode`\ 中，\
  没有办法表示目标范围的编译定义，也没有办法分别包含\ ``C``\ 和\ ``CXX``\ 语言的目录。而且，\
  使用\ :ref:`Visual Studio Generators`，无法分别为\ ``C``\ 语言和\ ``CXX``\ 语言表\
  示目标范围的标志。在这些生成器下，C和C++源的表达式如果有任何C++源，将使用\ ``CXX``\ 求值，\
  否则使用\ ``C``\ 求值。一个解决方法是为每种源文件语言创建单独的库：

  .. code-block:: cmake

    add_library(myapp_c foo.c)
    add_library(myapp_cxx bar.cpp)
    target_compile_options(myapp_cxx PUBLIC -fno-exceptions)
    add_executable(myapp main.cpp)
    target_link_libraries(myapp myapp_c myapp_cxx)

.. genex:: $<COMPILE_LANG_AND_ID:language,compiler_ids>

  .. versionadded:: 3.15

  当编译单元使用的语言与\ ``language``\ 匹配，且\ ``language``\ 编译器的CMake的编译器id与\
  ``compiler_ids``\ 中任何一个以逗号分隔的条目匹配时，则为\ ``1``，否则为\ ``0``。这个表达式是\
  ``$<COMPILE_LANGUAGE:language>``\ 和\ ``$<LANG_COMPILER_ID:compiler_ids>``\
  组合的简写形式。此表达式可用于指定编译选项、编译定义，及目标中特定语言的源文件和编译\
  器组合的包含目录。例如：

  .. code-block:: cmake

    add_executable(myapp main.cpp foo.c bar.cpp zot.cu)
    target_compile_definitions(myapp
      PRIVATE $<$<COMPILE_LANG_AND_ID:CXX,AppleClang,Clang>:COMPILING_CXX_WITH_CLANG>
              $<$<COMPILE_LANG_AND_ID:CXX,Intel>:COMPILING_CXX_WITH_INTEL>
              $<$<COMPILE_LANG_AND_ID:C,Clang>:COMPILING_C_WITH_CLANG>
    )

  这指定了基于编译器id和编译语言的不同编译定义的使用。当Clang是CXX编译器时，这个例子将有一个\
  ``COMPILING_CXX_WITH_CLANG``\ 编译定义，当Intel是CXX编译器时，这个例子将有一个\
  ``COMPILING_CXX_WITH_INTEL``\ 编译定义。同样，当C编译器是Clang时，它只能看到\
  ``COMPILING_C_WITH_CLANG``\ 定义。

  如果没有\ ``COMPILE_LANG_AND_ID``\ 生成器表达式，相同的逻辑将表示为：

  .. code-block:: cmake

    target_compile_definitions(myapp
      PRIVATE $<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CXX_COMPILER_ID:AppleClang,Clang>>:COMPILING_CXX_WITH_CLANG>
              $<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CXX_COMPILER_ID:Intel>>:COMPILING_CXX_WITH_INTEL>
              $<$<AND:$<COMPILE_LANGUAGE:C>,$<C_COMPILER_ID:Clang>>:COMPILING_C_WITH_CLANG>
    )

编译特性
^^^^^^^^^^^^^^^^

.. genex:: $<COMPILE_FEATURES:features>

  .. versionadded:: 3.1

  其中\ ``features``\ 是一个逗号分隔的列表。如果'head'目标的所有\ ``features``\ 都可用，\
  则返回\ ``1``，否则返回\ ``0``。如果在计算目标的链接实现时使用此表达式，并且如果任何依赖\
  项传递性地增加了'head'目标所需的\ :prop_tgt:`C_STANDARD`\ 或\ :prop_tgt:`CXX_STANDARD`，\
  则会报告错误。有关编译特性的信息和支持的编译器列表，请参阅\ :manual:`cmake-compile-features(7)`\
  手册。

编译环境
^^^^^^^^^^^^^^^

.. genex:: $<COMPILE_ONLY:...>

  .. versionadded:: 3.27

  当收集\ :ref:`可传递的编译属性 <Transitive Compile Properties>`\ 时，\ ``...``\
  的内容，否则为空字符串。这用于\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 和\
  :prop_tgt:`LINK_LIBRARIES`\ 目标属性，通常通过\ :command:`target_link_libraries`\
  命令填充。提供编译使用需求，而不需要任何链接需求。

  用例包括仅头文件的使用，其中所有的使用都已知没有链接需求（例如，全\ ``inline``\ 或C++模板库）。

  注意，要正确计算这个表达式，需要将策略\ :policy:`CMP0099`\ 设置为\ `NEW`。

链接器语言和ID
^^^^^^^^^^^^^^^^^^^^^^

.. genex:: $<LINK_LANGUAGE>

  .. versionadded:: 3.18

  计算链接选项时，目标的链接语言。请参阅\ :ref:`相关的布尔表达式
  <Boolean LINK_LANGUAGE Generator Expression>` ``$<LINK_LANGUAGE:languages>``，\
  以了解该生成器表达式的可移植性。

  .. note::

    链接库属性不支持此生成器表达式，以避免由于这些属性的双重求值而产生的副作用。


.. _`Boolean LINK_LANGUAGE Generator Expression`:

.. genex:: $<LINK_LANGUAGE:languages>

  .. versionadded:: 3.18

  当用于链接步骤的语言匹配\ ``languages``\ 中任何以逗号分隔的条目时，则为\ ``1``，否则为\
  ``0``。此表达式可用于指定目标中特定语言的链接库、链接选项、链接目录和链接依赖项。例如：

  .. code-block:: cmake

    add_library(api_C ...)
    add_library(api_CXX ...)
    add_library(api INTERFACE)
    target_link_options(api   INTERFACE $<$<LINK_LANGUAGE:C>:-opt_c>
                                        $<$<LINK_LANGUAGE:CXX>:-opt_cxx>)
    target_link_libraries(api INTERFACE $<$<LINK_LANGUAGE:C>:api_C>
                                        $<$<LINK_LANGUAGE:CXX>:api_CXX>)

    add_executable(myapp1 main.c)
    target_link_options(myapp1 PRIVATE api)

    add_executable(myapp2 main.cpp)
    target_link_options(myapp2 PRIVATE api)

  这指定使用\ ``api``\ 目标来链接目标\ ``myapp1``\ 和\ ``myapp2``。实际上，\ ``myapp1``\
  将与目标\ ``api_C``\ 和选项\ ``-opt_c``\ 进行链接，因为它将使用\ ``C``\ 作为链接语言。\
  ``myapp2``\ 将使用\ ``api_CXX``\ 和选项\ ``-opt_cxx``\ 链接，因为\ ``CXX``\ 将是链接语言。

  .. _`Constraints LINK_LANGUAGE Generator Expression`:

  .. note::

    为了确定目标的链接语言，需要传递地收集将链接到它的所有目标。因此，对于链接库属性，\
    将进行双重计算。在第一次求值期间，\ ``$<LINK_LANGUAGE:..>``\ 表达式总是返回\ ``0``。\
    在第一次传递之后计算的链接语言将用于第二次传递。为了避免不一致，要求第二次传递不改变链接\
    语言。此外，为了避免意外的副作用，需要指定完整的实体作为\ ``$<LINK_LANGUAGE:..>``\
    表达式。例如：

    .. code-block:: cmake

      add_library(lib STATIC file.cxx)
      add_library(libother STATIC file.c)

      # bad usage
      add_executable(myapp1 main.c)
      target_link_libraries(myapp1 PRIVATE lib$<$<LINK_LANGUAGE:C>:other>)

      # correct usage
      add_executable(myapp2 main.c)
      target_link_libraries(myapp2 PRIVATE $<$<LINK_LANGUAGE:C>:libother>)

    在本例中，对于\ ``myapp1``，第一次传递将意外地确定链接语言是\ ``CXX``，\
    因为生成器表达式的计算将是一个空字符串，因此\ ``myapp1``\ 将依赖于\ ``C++``\ 的目标\
    ``lib``。相反，对于\ ``myapp2``，第一次评估将给出\ ``C``\ 作为链接语言，\
    因此第二次评估将正确地添加目标\ ``libother``\ 作为链接依赖项。

.. genex:: $<LINK_LANG_AND_ID:language,compiler_ids>

  .. versionadded:: 3.18

  当用于链接步骤的语言匹配\ ``language``\ 并且语言链接器的CMake编译器id匹配\
  ``compiler_ids``\ 中任何一个逗号分隔的条目时，则为\ ``1``，否则为\ ``0``。\
  该表达式是\ ``$<LINK_LANGUAGE:language>``\ 和\ ``$<LANG_COMPILER_ID:compiler_ids>``\
  组合的简写形式。此表达式可用于指定目标中特定语言和链接器组合的链接库、链接选项、链接目录和\
  链接依赖项。例如：

  .. code-block:: cmake

    add_library(libC_Clang ...)
    add_library(libCXX_Clang ...)
    add_library(libC_Intel ...)
    add_library(libCXX_Intel ...)

    add_executable(myapp main.c)
    if (CXX_CONFIG)
      target_sources(myapp PRIVATE file.cxx)
    endif()
    target_link_libraries(myapp
      PRIVATE $<$<LINK_LANG_AND_ID:CXX,Clang,AppleClang>:libCXX_Clang>
              $<$<LINK_LANG_AND_ID:C,Clang,AppleClang>:libC_Clang>
              $<$<LINK_LANG_AND_ID:CXX,Intel>:libCXX_Intel>
              $<$<LINK_LANG_AND_ID:C,Intel>:libC_Intel>)

  这指定了基于编译器id和链接语言的不同链接库的使用。当\ ``Clang``\ 或\ ``AppleClang``\ 是\
  ``CXX``\ 链接器时，这个例子将把目标\ ``libCXX_Intel``\ 作为链接依赖项，当\ ``Intel``\
  是\ ``CXX``\ 链接器时，将把目标\ ``libCXX_Intel``\ 作为链接依赖项。同样地，当\ ``C``\
  链接器是\ ``Clang``\ 或\ ``AppleClang``\ 时，目标\ ``libC_Clang``\ 将被添加为链接依\
  赖项，当\ ``Intel``\ 是\ ``C``\ 链接器时，目标\ ``libC_Intel``\ 将被添加为链接依赖项。

  有关使用此生成器表达式的约束，请参阅\ :ref:`相关的说明
  <Constraints LINK_LANGUAGE Generator Expression>`\
  ``$<LINK_LANGUAGE:language>``。

链接特性
^^^^^^^^^^^^^

.. genex:: $<LINK_LIBRARY:feature,library-list>

  .. versionadded:: 3.24

  指定一组要链接到目标的库，以及提供关于应该\ *如何*\ 链接它们的详细信息的\ ``feature``。例如：

  .. code-block:: cmake

    add_library(lib1 STATIC ...)
    add_library(lib2 ...)
    target_link_libraries(lib2 PRIVATE "$<LINK_LIBRARY:WHOLE_ARCHIVE,lib1>")

  这指定\ ``lib2``\ 应该链接到\ ``lib1``，并在这样做时使用\ ``WHOLE_ARCHIVE``\ 特性。

  特性名称区分大小写，只能包含字母、数字和下划线。所有大写的特性名称都保留给CMake自己的内置\
  特性。预定义的内置库特性包括：

  .. include:: ../variable/LINK_LIBRARY_PREDEFINED_FEATURES.txt

  内置和自定义库特性是根据以下变量定义的：

  * :variable:`CMAKE_<LANG>_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED`
  * :variable:`CMAKE_<LANG>_LINK_LIBRARY_USING_<FEATURE>`
  * :variable:`CMAKE_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED`
  * :variable:`CMAKE_LINK_LIBRARY_USING_<FEATURE>`

  用于每个变量的值是在创建目标的目录作用域的末尾设置的值。用法如下：

  1. 如果特定于语言的\ :variable:`CMAKE_<LANG>_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED`\
     变量为真，则该\ ``feature``\ 必须由相应的\ :variable:`CMAKE_<LANG>_LINK_LIBRARY_USING_<FEATURE>`\
     变量定义。
  2. 如果不支持特定于语言的\ ``feature``\ ，则\ :variable:`CMAKE_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED`\
     变量必须为真，并且该\ ``feature``\ 必须由相应的\ :variable:`CMAKE_LINK_LIBRARY_USING_<FEATURE>`\
     变量定义。

  应注意以下限制：

  * ``library-list``\ 可以指定CMake目标或库。任何\ :ref:`OBJECT <Object Libraries>`\
    或\ :ref:`INTERFACE <Interface Libraries>`\ 类型的CMake目标都将忽略表达式的特征方面，\
    而是以标准方式链接。

  * ``$<LINK_LIBRARY:...>``\ 生成器表达式只能用于指定链接库。实际上，这意味着它可以出现在\
    :prop_tgt:`LINK_LIBRARIES`、:prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 和\
    :prop_tgt:`INTERFACE_LINK_LIBRARIES_DIRECT`\ 目标属性中，并在\
    :command:`target_link_libraries`\ 和\ :command:`link_libraries`\ 命令中指定。

  * 如果\ ``$<LINK_LIBRARY:...>``\ 生成器表达式出现在目标的\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\
    属性中，它将包含在由\ :command:`install(EXPORT)`\ 命令生成的导入目标中。使用此导入\
    的环境负责定义此表达式使用的链接特性。

  * 链接步骤中涉及的每个目标或库最多只能有一种库特性。一个特性的缺失也与所有其他特性不兼容。\
    例如：

    .. code-block:: cmake

      add_library(lib1 ...)
      add_library(lib2 ...)
      add_library(lib3 ...)

      # lib1 will be associated with feature1
      target_link_libraries(lib2 PUBLIC "$<LINK_LIBRARY:feature1,lib1>")

      # lib1 is being linked with no feature here. This conflicts with the
      # use of feature1 in the line above and would result in an error.
      target_link_libraries(lib3 PRIVATE lib1 lib2)

    如果不可能在整个构建过程中对给定的目标或库使用相同的特性，则可以使用\
    :prop_tgt:`LINK_LIBRARY_OVERRIDE`\ 和\ :prop_tgt:`LINK_LIBRARY_OVERRIDE_<LIBRARY>`\
    目标属性来解决此类不兼容性问题。

  * ``$<LINK_LIBRARY:...>``\ 生成器表达式不保证指定目标和库的列表将保持分组在一起。\
    要像GNU ``ld``\ 链接器所支持的那样管理\ ``--start-group``\ 和\ ``--end-group``\
    这样的构造，请使用\ :genex:`LINK_GROUP`\ 生成器表达式。

.. genex:: $<LINK_GROUP:feature,library-list>

  .. versionadded:: 3.24

  指定要链接到目标的库组，以及定义该组应如何链接的\ ``feature``。例如:

  .. code-block:: cmake

    add_library(lib1 STATIC ...)
    add_library(lib2 ...)
    target_link_libraries(lib2 PRIVATE "$<LINK_GROUP:RESCAN,lib1,external>")

  这指定\ ``lib2``\ 应该链接到\ ``lib1``\ 和\ ``external``\ 库，并且根据\ ``RESCAN``\
  特性的定义，这两个库都应该包含在链接器命令行中。

  特性名称区分大小写，只能包含字母、数字和下划线。所有大写的特性名称都保留给CMake自己的内置\
  特性。目前，只有一个预定义的内置组特性：

  .. include:: ../variable/LINK_GROUP_PREDEFINED_FEATURES.txt

  内置和自定义组功能是根据以下变量定义的：

  * :variable:`CMAKE_<LANG>_LINK_GROUP_USING_<FEATURE>_SUPPORTED`
  * :variable:`CMAKE_<LANG>_LINK_GROUP_USING_<FEATURE>`
  * :variable:`CMAKE_LINK_GROUP_USING_<FEATURE>_SUPPORTED`
  * :variable:`CMAKE_LINK_GROUP_USING_<FEATURE>`

  用于每个变量的值是在创建目标的目录作用域的末尾设置的值。用法如下：

  1. 如果特定于语言的\ :variable:`CMAKE_<LANG>_LINK_GROUP_USING_<FEATURE>_SUPPORTED`\
     变量为真，则该\ ``feature``\ 必须由相应的\ :variable:`CMAKE_<LANG>_LINK_GROUP_USING_<FEATURE>`\
     变量定义。
  2. 如果不支持特定于语言的 ``feature``，则\ :variable:`CMAKE_LINK_GROUP_USING_<FEATURE>_SUPPORTED`\
     变量必须为真，并且该\ ``feature``\ 必须由相应的\
     :variable:`CMAKE_LINK_GROUP_USING_<FEATURE>`\ 变量定义。

  ``LINK_GROUP``\ 生成器表达式与\ :genex:`LINK_LIBRARY`\ 生成器表达式兼容。可以使用\
  :genex:`LINK_LIBRARY`\ 生成器表达式指定组中涉及的库。

  链接步骤中涉及的每个目标或外部库都可以是多个组的一部分，但前提是所有涉及的组都指定了相同的\
  ``feature``。这样的组不会在链接器命令行上被合并，单独的组仍然会被保留。禁止为相同的目标\
  或库混合不同的组特征。

  .. code-block:: cmake

    add_library(lib1 ...)
    add_library(lib2 ...)
    add_library(lib3 ...)
    add_library(lib4 ...)
    add_library(lib5 ...)

    target_link_libraries(lib3 PUBLIC  "$<LINK_GROUP:feature1,lib1,lib2>")
    target_link_libraries(lib4 PRIVATE "$<LINK_GROUP:feature1,lib1,lib3>")
    # lib4 will be linked with the groups {lib1,lib2} and {lib1,lib3}.
    # Both groups specify the same feature, so this is fine.

    target_link_libraries(lib5 PRIVATE "$<LINK_GROUP:feature2,lib1,lib3>")
    # An error will be raised here because both lib1 and lib3 are part of two
    # groups with different features.

  当目标或外部库作为组的一部分参与链接步骤，同时又不属于任何组时，任何出现的非组链接项都将被\
  它所属的组替换。

  .. code-block:: cmake

    add_library(lib1 ...)
    add_library(lib2 ...)
    add_library(lib3 ...)
    add_library(lib4 ...)

    target_link_libraries(lib3 PUBLIC lib1)

    target_link_libraries(lib4 PRIVATE lib3 "$<LINK_GROUP:feature1,lib1,lib2>")
    # lib4 will only be linked with lib3 and the group {lib1,lib2}

  因为\ ``lib1``\ 是为\ ``lib4``\ 定义的组的一部分，所以这个组将应用回对\ ``lib3``\ 使用\
  ``lib1``。最终结果就像\ ``lib3``\ 的链接关系被指定为：

  .. code-block:: cmake

    target_link_libraries(lib3 PUBLIC "$<LINK_GROUP:feature1,lib1,lib2>")

  注意，组相对于非组链接项的优先级可能导致组之间的循环依赖关系。如果发生这种情况，将引发致命\
  错误，因为不允许组使用循环依赖项。

  .. code-block:: cmake

    add_library(lib1A ...)
    add_library(lib1B ...)
    add_library(lib2A ...)
    add_library(lib2B ...)
    add_library(lib3 ...)

    # Non-group linking relationships, these are non-circular so far
    target_link_libraries(lib1A PUBLIC lib2A)
    target_link_libraries(lib2B PUBLIC lib1B)

    # The addition of these groups creates circular dependencies
    target_link_libraries(lib3 PRIVATE
      "$<LINK_GROUP:feat,lib1A,lib1B>"
      "$<LINK_GROUP:feat,lib2A,lib2B>"
    )

  由于为\ ``lib3``\ 定义了组，\ ``lib1A``\ 和\ ``lib2B``\ 的链接关系有效地扩展为等价的：

  .. code-block:: cmake

    target_link_libraries(lib1A PUBLIC "$<LINK_GROUP:feat,lib2A,lib2B>")
    target_link_libraries(lib2B PUBLIC "$<LINK_GROUP:feat,lib1A,lib1B>")

  这在组之间创建了一个循环依赖：\ ``lib1A --> lib2B --> lib1A``。

  还应注意以下限制：

  * ``library-list``\ 可以指定CMake目标或库。任何\ :ref:`OBJECT <Object Libraries>`\
    或\ :ref:`INTERFACE <Interface Libraries>`\ 类型的CMake目标都将忽略表达式的特征方面，\
    而是以标准方式链接。

  * ``$<LINK_GROUP:...>``\ 生成器表达式只能用于指定链接库。实际上，这意味着它可以出现在\
    :prop_tgt:`LINK_LIBRARIES`、:prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 和\
    :prop_tgt:`INTERFACE_LINK_LIBRARIES_DIRECT`\ 目标属性中，并在\
    :command:`target_link_libraries`\ 和\ :command:`link_libraries`\ 命令中指定。

  * 如果\ ``$<LINK_GROUP:...>``\ 生成器表达式出现在目标的\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\
    属性中，它将包含在由\ :command:`install(EXPORT)`\ 命令生成的导入目标中。使用此导入\
    的环境负责定义此表达式使用的链接特性。

链接上下文
^^^^^^^^^^^^

.. genex:: $<LINK_ONLY:...>

  .. versionadded:: 3.1

  ``...``\ 的内容，除了从\ :ref:`传递编译属性 <Transitive Compile Properties>`\ 收集\
  使用需求时，在这种情况下，它是空字符串。这用于\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\
  目标属性中，通常通过\ :command:`target_link_libraries`\ 命令填充，以指定私有链接依赖\
  关系，而不需要其他使用要求。例如包含目录或编译选项。

  .. versionadded:: 3.24
    ``LINK_ONLY``\ 也可以在\ :prop_tgt:`LINK_LIBRARIES`\ 目标属性中使用。参见策略\
    :policy:`CMP0131`。

.. genex:: $<DEVICE_LINK:list>

  .. versionadded:: 3.18

  如果是设备链接步骤，则返回列表，否则返回空列表。设备链接步骤由\ :prop_tgt:`CUDA_SEPARABLE_COMPILATION`\
  和\ :prop_tgt:`CUDA_RESOLVE_DEVICE_SYMBOLS`\ 属性和策略\ :policy:`CMP0105`\ 控制。\
  此表达式只能用于指定链接选项。

.. genex:: $<HOST_LINK:list>

  .. versionadded:: 3.18

  如果是普通的链接步骤，则返回列表，否则返回空列表。当还涉及到设备链接步骤时，此表达式相当有用\
  （请参阅\ :genex:`$<DEVICE_LINK:list>`\ 生成器表达式）。此表达式只能用于指定链接选项。


.. _`Target-Dependent Expressions`:

依赖于目标的表达式
----------------------------

目标元数据
^^^^^^^^^^^^^^^^

这些表达式用于查找目标的信息。

.. genex:: $<TARGET_EXISTS:tgt>

  .. versionadded:: 3.12

  如果\ ``tgt``\ 作为CMake目标存在，则为\ ``1``，否则为\ ``0``。

.. genex:: $<TARGET_NAME_IF_EXISTS:tgt>

  .. versionadded:: 3.12

  如果目标存在，则目标名\ ``tgt``，否则为空字符串。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加。

.. genex:: $<TARGET_NAME:tgt>

  目标名称为\ ``tgt``。这将\ ``tgt``\ 标记为较大表达式中目标的名称，如果将目标导出到多个\
  依赖导出集，则需要此名称。\ ``tgt``\ 文本必须是目标的字面名称；它不能包含生成器表达式。\
  目标不一定存在。

.. genex:: $<TARGET_POLICY:policy>

  如果'head'目标创建时\ ``policy``\ 是\ ``NEW``\ 的，为\ ``1``，否则为\ ``0``。如果未\
  设置\ ``policy``，则会发出策略的警告消息。这个生成器表达式只适用于策略的一个子集。


目标属性
^^^^^^^^^^^^^^^^^

这些表达式查找\ :ref:`目标属性 <Target Properties>`\ 的值。

.. genex:: $<TARGET_PROPERTY:tgt,prop>

  目标\ ``tgt``\ 上的属性\ ``prop``\ 的值，如果未设置该属性，则为空。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加。

  .. versionchanged:: 3.26
    当在评估\ :ref:`目标使用要求 <Target Usage Requirements>`\ 期间遇到时，通常是在\
    ``INTERFACE_*``\ 目标属性中，在指定需求的目标的目录中查找\ ``tgt``\ 名称，而不是在\
    计算表达式的消费目标的目录中。

  .. versionchanged:: 3.31
    传递接口属性的生成器表达式，如\ ``$<TARGET_PROPERTY:target,INTERFACE_*>``，现在可\
    以正确地处理嵌套生成器表达式中的重复求值。以前，由于对传递闭包进行了优化，这些重复的求值\
    返回空值。这一更改确保了对非联合操作的一致求值。

.. genex:: $<TARGET_PROPERTY:prop>
  :target: TARGET_PROPERTY:prop

  属性\ ``prop``\ 在表达式被求值的目标上的值，如果未设置该属性，则为空。注意，对于\
  :ref:`目标使用要求 <Target Usage Requirements>`\ 中的生成器表达式，这是消费目标，而\
  不是指定需求的目标。

这些表达式对某些属性有特殊的求值规则：

:ref:`目标构建规范属性 <Target Build Specification>`
  这些值是一个\ :ref:`分号分隔列表 <CMake Language Lists>`，表示目标本身上的值与目标的\
  相应\ :ref:`目标使用要求 <Target Usage Requirements>`\ 的值的并集，这些值由目标的\
  :prop_tgt:`LINK_LIBRARIES`\ 命名：

  * 对于\ :ref:`目标编译属性 <Transitive Compile Properties>`，对相应使用需求的评估\
    传递到链接目标的\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 的闭包，\ *不包括*\ 由\
    :genex:`LINK_ONLY`\ 生成器表达式保护的条目。

  * 对于\ :ref:`目标链接属性 <Transitive Link Properties>`,，对相应使用需求的评估传递\
    到链接目标的\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 的闭包，其中\ *包括*\ 由\
    :genex:`LINK_ONLY`\ 生成器表达式保护的条目。参见策略\ :policy:`CMP0166`。

  :prop_tgt:`LINK_LIBRARIES`\ 本身的求值不是传递的。

:ref:`目标使用要求属性 <Target Usage Requirements>`
  这些值是一个\ :ref:`分号分隔列表 <CMake Language Lists>`，表示目标本身上的值与目标的\
  相应目标使用要求的值的并集，这些值由目标的\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\
  命名：

  * 对于\ :ref:`目标编译属性 <Transitive Compile Properties>`，对相应使用需求的评估\
    传递到链接目标的\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 的闭包，\ *不包括*\ 由\
    :genex:`LINK_ONLY`\ 生成器表达式保护的条目。

  * 对于\ :ref:`目标链接属性 <Transitive Link Properties>`,，对相应使用需求的评估传递\
    到链接目标的\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 的闭包，其中\ *包括*\ 由\
    :genex:`LINK_ONLY`\ 生成器表达式保护的条目。参见策略\ :policy:`CMP0166`。

  :prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 本身的求值不是传递的。

:ref:`自定义传递属性 <Custom Transitive Properties>`
  .. versionadded:: 3.30

  这些在评估过程中处理如下：

  * :genex:`$<TARGET_PROPERTY:tgt,PROP>`\ 的求值对于某些属性\ ``PROP``，命名时没有\
    ``INTERFACE_``\ 前缀，检查目标\ ``tgt``\ 上的\
    :prop_tgt:`TRANSITIVE_COMPILE_PROPERTIES`\ 和\
    :prop_tgt:`TRANSITIVE_LINK_PROPERTIES`\ 属性，目标由其\
    :prop_tgt:`LINK_LIBRARIES`\ 命名，目标的传递闭包由链接目标的\
    :prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 命名。

    如果\ ``PROP``\ 包含在其中一个属性中，那么它的计算结果为一个\
    :ref:`分号分隔列表 <CMake Language Lists>`，表示目标本身的值与目标的\
    :prop_tgt:`LINK_LIBRARIES`\ 命名的相应\ ``INTERFACE_PROP``\ 的值的联合：

    * 如果\ ``PROP``\ 是由\ :prop_tgt:`TRANSITIVE_COMPILE_PROPERTIES`\ 命名的，\
      那么对应的\ ``INTERFACE_PROP``\ 的计算将通过链接目标的\
      :prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 的闭包传递，不包括由\ :genex:`LINK_ONLY`\
      生成器表达式保护的项。

    * 如果\ ``PROP``\ 是由\ :prop_tgt:`TRANSITIVE_LINK_PROPERTIES`\ 命名的，那么相应的\
      ``INTERFACE_PROP``\ 的计算将通过链接目标的\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\
      的闭包传递，包括由\ :genex:`LINK_ONLY`\ 生成器表达式保护的项。

  * 以\ ``INTERFACE_``\ 前缀命名的属性\ ``INTERFACE_PROP``\ 的\
    :genex:`$<TARGET_PROPERTY:tgt,INTERFACE_PROP>`\ 的计算，检查\ ``tgt``\ 目标上的\
    :prop_tgt:`TRANSITIVE_COMPILE_PROPERTIES`\ 和\
    :prop_tgt:`TRANSITIVE_LINK_PROPERTIES`\ 属性，以及以其\
    :prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 命名的目标的传递闭包。

    如果对应的\ ``PROP``\ 被这些属性之一列出，那么\ ``INTERFACE_PROP``\ 的计算结果为一个\
    :ref:`分号分隔列表 <CMake Language Lists>`，表示目标本身上的值与目标的\
    :prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 命名的相同属性的值的联合：

    * 如果\ ``PROP``\ 是由\ :prop_tgt:`TRANSITIVE_COMPILE_PROPERTIES`\ 命名的，\
      那么对应的 ``INTERFACE_PROP`` 的求值会传递到目标的\
      :prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 的闭包中，不包括由\ :genex:`LINK_ONLY`\
      生成器表达式保护的项。

    * 如果\ ``PROP``\ 是由\ :prop_tgt:`TRANSITIVE_LINK_PROPERTIES`\ 命名的，那么相应的\
      ``INTERFACE_PROP``\ 的计算是通过目标的\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\
      的闭包传递的，包括由\ :genex:`LINK_ONLY`\ 生成器表达式保护的项。

  如果\ ``PROP``\ 同时由\ :prop_tgt:`TRANSITIVE_COMPILE_PROPERTIES`\ 和\
  :prop_tgt:`TRANSITIVE_LINK_PROPERTIES`\ 命名，则后者优先。

:ref:`Compatible Interface Properties`
  这些值由目标本身及目标的\ :prop_tgt:`LINK_LIBRARIES`\ 命名的目标以及被链接目标的\
  :prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 的传递闭包组合而成。来自多个目标的compatible\
  接口属性的值根据定义它的 ``COMPATIBLE_INTERFACE_*``\ 属性所需的兼容性类型组合。


目标工件
^^^^^^^^^^^^^^^^

这些表达式查找与给定目标\ ``tgt``\ 相关联的工件的信息。除非另有说明，这可以是任何运行时工件，\
即：

* :command:`add_executable`\ 创建的可执行目标。
* :command:`add_library`\ 创建的共享库目标（\ ``.so``、\ ``.dll``，但不是它们的\
  ``.lib``\ 导入库）。
* :command:`add_library`\ 创建的静态库目标。

在下面的代码中，短语“the ``tgt`` filename”表示\ ``tgt``\ 二进制文件的名称。这必须与短语\
“目标名称”区分开来，它只是字符串\ ``tgt``。

.. genex:: $<TARGET_FILE:tgt>

  ``tgt``\ 二进制文件的完整路径。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的，除非该表达式在\
  :command:`add_custom_command`\ 或\ :command:`add_custom_target`\ 中使用。

.. genex:: $<TARGET_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.15

  ``tgt``\ 的基本名称，即不带前缀和后缀的\ ``$<TARGET_FILE_NAME:tgt>``。例如，如果\
  ``tgt``\ 文件名是\ ``libbase.so``，基名是\ ``base``。

  另请参阅\ :prop_tgt:`OUTPUT_NAME`、\ :prop_tgt:`ARCHIVE_OUTPUT_NAME`、\
  :prop_tgt:`LIBRARY_OUTPUT_NAME`\ 和\ :prop_tgt:`RUNTIME_OUTPUT_NAME`\ 目标属性\
  及其特定于配置的变体\ :prop_tgt:`OUTPUT_NAME_<CONFIG>`、\ :prop_tgt:`ARCHIVE_OUTPUT_NAME_<CONFIG>`、\
  :prop_tgt:`LIBRARY_OUTPUT_NAME_<CONFIG>`\ 和\ :prop_tgt:`RUNTIME_OUTPUT_NAME_<CONFIG>`。

  也可以考虑\ :prop_tgt:`<CONFIG>_POSTFIX`\ 和\ :prop_tgt:`DEBUG_POSTFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加。

.. genex:: $<TARGET_FILE_PREFIX:tgt>

  .. versionadded:: 3.15

  ``tgt``\ 文件名的前缀（例如\ ``lib``）。

  请参见\ :prop_tgt:`PREFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加。

.. genex:: $<TARGET_FILE_SUFFIX:tgt>

  .. versionadded:: 3.15

  ``tgt``\ 文件名的后缀（扩展名如\ ``.so``\ 或\ ``.exe``）。

  请参见\ :prop_tgt:`SUFFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加。

.. genex:: $<TARGET_FILE_NAME:tgt>

  ``tgt``\ 文件名。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加（请参阅策略\ :policy:`CMP0112`）。

.. genex:: $<TARGET_FILE_DIR:tgt>

  ``tgt``\ 二进制文件的目录。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加（请参阅策略\ :policy:`CMP0112`）。

.. genex:: $<TARGET_IMPORT_FILE:tgt>

  .. versionadded:: 3.27

  链接器导入文件的完整路径。在DLL平台上，它将是\ ``.lib``\ 文件。对于AIX上的可执行文件，\
  对于macOS上的共享库，它可以分别是\ ``.imp``\ 或\ ``.tbd``\ 导入文件，具体取决于\
  :prop_tgt:`ENABLE_EXPORTS`\ 属性的值。

  如果没有与目标关联的导入文件，则返回空字符串。

.. genex:: $<TARGET_IMPORT_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.27

  目标文件链接器导入文件的基名\ ``tgt``，不带前缀或者后缀。例如，目标文件名为\
  ``libbase.tbd``，则基文件名为\ ``base``。

  另请参阅\ :prop_tgt:`OUTPUT_NAME`\ 和\ :prop_tgt:`ARCHIVE_OUTPUT_NAME`\ 目标属性\
  及其特定于配置的变体\ :prop_tgt:`OUTPUT_NAME_<CONFIG>`\ 和\
  :prop_tgt:`ARCHIVE_OUTPUT_NAME_<CONFIG>`。

  也可以考虑\ :prop_tgt:`<CONFIG>_POSTFIX`\ 和\ :prop_tgt:`DEBUG_POSTFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_IMPORT_FILE_PREFIX:tgt>

  .. versionadded:: 3.27

  目标\ ``tgt``\ 导入文件的前缀。

  另请参见\ :prop_tgt:`IMPORT_PREFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_IMPORT_FILE_SUFFIX:tgt>

  .. versionadded:: 3.27

  目标导入文件的后缀 ``tgt``。

  后缀对应于文件扩展名（如\ ``.lib``\ 或\ ``.tbd``）。

  另请参见\ :prop_tgt:`IMPORT_SUFFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_IMPORT_FILE_NAME:tgt>

  .. versionadded:: 3.27

  ``tgt``\ 目标的导入文件名。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_IMPORT_FILE_DIR:tgt>

  ``tgt``\ 目标的导入文件目录。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_LINKER_FILE:tgt>

  链接到\ ``tgt``\ 目标时使用的文件。这通常是\ ``tgt``\ 表示的库（\ ``.a``、\ ``.lib``、\
  ``.so``），但对于DLL平台上的共享库，它将是与DLL关联的\ ``.lib``\ 导入库。

  .. versionadded:: 3.27
    在macOS上，它可以是与共享库关联的\ ``.tbd``\ 导入文件，具体取决于\
    :prop_tgt:`ENABLE_EXPORTS`\ 属性的值。

  该生成器表达式等价于\ :genex:`$<TARGET_LINKER_LIBRARY_FILE>`\ 或\
  :genex:`$<TARGET_LINKER_IMPORT_FILE>`\ 生成器表达式，具体取决于目标和平台的特征。

.. genex:: $<TARGET_LINKER_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.15

  用于链接目标\ ``tgt``\ 的基本文件名，例如\ :genex:`$<TARGET_LINKER_FILE_NAME:tgt>` ，\
  不带前缀和后缀。例如，目标文件名为\ ``libbase.a``，基本名称为\ ``base``。

  另请参阅\ :prop_tgt:`OUTPUT_NAME`、\ :prop_tgt:`ARCHIVE_OUTPUT_NAME`\
  和\ :prop_tgt:`LIBRARY_OUTPUT_NAME`\ 目标属性及其特定于配置的变体\
  :prop_tgt:`OUTPUT_NAME_<CONFIG>`、:prop_tgt:`ARCHIVE_OUTPUT_NAME_<CONFIG>`\
  和\ :prop_tgt:`LIBRARY_OUTPUT_NAME_<CONFIG>`。

  也可以考虑\ :prop_tgt:`<CONFIG>_POSTFIX`\ 和\ :prop_tgt:`DEBUG_POSTFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加。

.. genex:: $<TARGET_LINKER_FILE_PREFIX:tgt>

  .. versionadded:: 3.15

  用于链接目标\ ``tgt``\ 的文件前缀。

  另请参阅\ :prop_tgt:`PREFIX`\ 和\ :prop_tgt:`IMPORT_PREFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加。

.. genex:: $<TARGET_LINKER_FILE_SUFFIX:tgt>

  .. versionadded:: 3.15

  用于链接的文件后缀，其中\ ``tgt``\ 是目标的名称。

  后缀对应于文件扩展名（例如".so"或".lib"）。

  另请参阅\ :prop_tgt:`SUFFIX`\ 和\ :prop_tgt:`IMPORT_SUFFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加。

.. genex:: $<TARGET_LINKER_FILE_NAME:tgt>

  用于链接目标\ ``tgt``\ 的文件名。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加（请参阅策略\ :policy:`CMP0112`）。

.. genex:: $<TARGET_LINKER_FILE_DIR:tgt>

  用于链接目标\ ``tgt``\ 的文件目录。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加（请参阅策略\ :policy:`CMP0112`）。

.. genex:: $<TARGET_LINKER_LIBRARY_FILE:tgt>

  .. versionadded:: 3.27

  链接到\ ``tgt``\ 目标时使用的文件是直接使用库完成的，而不是导入文件。这通常是\ ``tgt``\
  表示的库（\ ``.a``、\ ``.so``、\ ``.dylib``）。因此，在DLL平台上，它将是一个空字符串。

.. genex:: $<TARGET_LINKER_LIBRARY_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.27

  用于链接目标\ ``tgt``\ 的库文件的基本名称，即\
  :genex:`$<TARGET_LINKER_LIBRARY_FILE_NAME:tgt>`，不带前缀和后缀。例如，目标文件名为\
  ``libbase.a``，则基文件名为\ ``base``。

  另请参阅\ :prop_tgt:`OUTPUT_NAME`、\ :prop_tgt:`ARCHIVE_OUTPUT_NAME`\ 和\
  :prop_tgt:`LIBRARY_OUTPUT_NAME`\ 目标属性及其配置特定的变体\
  :prop_tgt:`OUTPUT_NAME_<CONFIG>`、\ :prop_tgt:`ARCHIVE_OUTPUT_NAME_<CONFIG>`\
  和\ :prop_tgt:`LIBRARY_OUTPUT_NAME_<CONFIG>`。

  也可以考虑\ :prop_tgt:`<CONFIG>_POSTFIX`\ 和\ :prop_tgt:`DEBUG_POSTFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_LINKER_LIBRARY_FILE_PREFIX:tgt>

  .. versionadded:: 3.27

  用于链接目标\ ``tgt``\ 的库文件前缀。

  另请参见\ :prop_tgt:`PREFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_LINKER_LIBRARY_FILE_SUFFIX:tgt>

  .. versionadded:: 3.27

  用于链接目标\ ``tgt``\ 的库文件后缀。

  后缀对应于文件扩展名（如“.a”或“.dylib”）。

  另请参见\ :prop_tgt:`SUFFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_LINKER_LIBRARY_FILE_NAME:tgt>

  .. versionadded:: 3.27

  用于链接目标\ ``tgt``\ 的库文件名。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_LINKER_LIBRARY_FILE_DIR:tgt>

  .. versionadded:: 3.27

  用于链接目标\ ``tgt``\ 的库文件目录。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_LINKER_IMPORT_FILE:tgt>

  .. versionadded:: 3.27

  使用导入文件链接到\ ``tgt``\ 目标时使用的文件。这通常是\ ``tgt``\ 表示的导入文件（\
  ``.lib``、\ ``.tbd``）。因此，当链接步骤中没有涉及导入文件时，将返回一个空字符串。

.. genex:: $<TARGET_LINKER_IMPORT_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.27

  用于链接目标\ ``tgt``\ 的导入文件的基本名称，即\
  :genex:`$<TARGET_LINKER_IMPORT_FILE_NAME:tgt>`\ ，不带前缀和后缀。例如，如果目标文\
  件名为\ ``libbase.tbd``，则基文件名为\ ``base``。

  另请参阅\ :prop_tgt:`OUTPUT_NAME`\ 和\ :prop_tgt:`ARCHIVE_OUTPUT_NAME`\ 目标属性\
  及其配置特定的变体\ :prop_tgt:`OUTPUT_NAME_<CONFIG>`\ 和\
  :prop_tgt:`ARCHIVE_OUTPUT_NAME_<CONFIG>`。

  也可以考虑\ :prop_tgt:`<CONFIG>_POSTFIX`\ 和\ :prop_tgt:`DEBUG_POSTFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_LINKER_IMPORT_FILE_PREFIX:tgt>

  .. versionadded:: 3.27

  用于链接目标\ ``tgt``\ 的导入文件的前缀。

  另请参见\ :prop_tgt:`IMPORT_PREFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_LINKER_IMPORT_FILE_SUFFIX:tgt>

  .. versionadded:: 3.27

  用于链接目标\ ``tgt``\ 的导入文件的后缀。

  后缀对应于文件扩展名（如“.lib”或“.tbd”）。

  另请参见\ :prop_tgt:`IMPORT_SUFFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_LINKER_IMPORT_FILE_NAME:tgt>

  .. versionadded:: 3.27

  用于链接目标\ ``tgt``\ 的导入文件名。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_LINKER_IMPORT_FILE_DIR:tgt>

  .. versionadded:: 3.27

  用于链接目标\ ``tgt``\ 的导入文件的目录。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_SONAME_FILE:tgt>

  带有soname（\ ``.so.3``）的文件，其中\ ``tgt``\ 是目标的名称。

.. genex:: $<TARGET_SONAME_FILE_NAME:tgt>

  带有soname（\ ``.so.3``）的文件名。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加（请参阅策略\ :policy:`CMP0112`）。

.. genex:: $<TARGET_SONAME_FILE_DIR:tgt>

  soname（\ ``.so.3``\ ）的文件目录。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加（请参阅策略\ :policy:`CMP0112`）。

.. genex:: $<TARGET_SONAME_IMPORT_FILE:tgt>

  .. versionadded:: 3.27

  使用soname（\ ``.3.tbd``\ ）导入文件，其中\ ``tgt``\ 是目标的名称。

.. genex:: $<TARGET_SONAME_IMPORT_FILE_NAME:tgt>

  .. versionadded:: 3.27

  使用soname（\ ``.3.tbd``\ ）导入文件的名称。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_SONAME_IMPORT_FILE_DIR:tgt>

  .. versionadded:: 3.27

  使用sonname（\ ``.3.tbd``\ ）导入文件的目录。

  请注意，\ ``tgt``\ 并不是作为计算该表达式的目标的依赖项添加的。

.. genex:: $<TARGET_PDB_FILE:tgt>

  .. versionadded:: 3.1

  链接器生成的程序数据库文件（.pdb）的完整路径，其中\ ``tgt``\ 是目标的名称。

  另请参阅\ :prop_tgt:`PDB_NAME`\ 和\ :prop_tgt:`PDB_OUTPUT_DIRECTORY`\ 目标属性及\
  其特定于配置的变体\ :prop_tgt:`PDB_NAME_<CONFIG>`\ 和\
  :prop_tgt:`PDB_OUTPUT_DIRECTORY_<CONFIG>`。

.. genex:: $<TARGET_PDB_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.15

  链接器生成的程序数据库文件（.pdb）的基本名称，其中\ ``tgt``\ 是目标的名称。

  基本名称对应于不带前缀和后缀的目标PDB文件名（参见\ ``$<TARGET_PDB_FILE_NAME:tgt>``）。\
  例如，如果目标文件名是\ ``base.pdb``，基本名称为\ ``base``。

  另请参阅\ :prop_tgt:`PDB_NAME`\ 目标属性及其特定于配置的变体\ :prop_tgt:`PDB_NAME_<CONFIG>`。

  也可以考虑\ :prop_tgt:`<CONFIG>_POSTFIX`\ 和\ :prop_tgt:`DEBUG_POSTFIX`\ 目标属性。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加。

.. genex:: $<TARGET_PDB_FILE_NAME:tgt>

  .. versionadded:: 3.1

  链接器生成的程序数据库文件（.pdb）的名称。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加（请参阅策略\ :policy:`CMP0112`）。

.. genex:: $<TARGET_PDB_FILE_DIR:tgt>

  .. versionadded:: 3.1

  链接器生成的程序数据库文件（.pdb）的目录。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加（请参阅策略\ :policy:`CMP0112`）。

.. genex:: $<TARGET_BUNDLE_DIR:tgt>

  .. versionadded:: 3.9

  bundle目录的完整路径（\ ``/path/to/my.app``、\ ``/path/to/my.framework``\ 或者\
  ``/path/to/my.bundle``），其中\ ``tgt``\ 是目标的名称。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加（请参阅策略\ :policy:`CMP0112`）。

.. genex:: $<TARGET_BUNDLE_DIR_NAME:tgt>

  .. versionadded:: 3.24

  bundle目录的名称（\ ``my.app``、\ ``my.framework``\ 或者\ ``my.bundle``），其中\
  ``tgt``\ 是目标的名称。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加（请参阅策略\ :policy:`CMP0112`）。

.. genex:: $<TARGET_BUNDLE_CONTENT_DIR:tgt>

  .. versionadded:: 3.9

  bundle内容目录的完整路径，其中\ ``tgt``\ 是目标的名称。对于macOS SDK，它指向\
  ``/path/to/my.app/Contents``、\ ``/path/to/my.framework``\ 或\
  ``/path/to/my.bundle/Contents``。对于所有其他SDK（例如iOS），它指向\
  ``/path/to/my.app``、\ ``/path/to/my.framework``\ 或\ ``/path/to/my.bundle`` ，\
  因为它们的扁平bundle结构。

  请注意，\ ``tgt``\ 并没有作为计算该表达式的目标的依赖项添加（请参阅策略\ :policy:`CMP0112`）。

.. genex:: $<TARGET_OBJECTS:tgt>

  .. versionadded:: 3.1

  构建\ ``tgt``\ 产生的对象列表。这通常用于\ :ref:`对象库 <Object Libraries>`\ 目标。

.. genex:: $<TARGET_RUNTIME_DLLS:tgt>

  .. versionadded:: 3.21

  目标在运行时依赖的DLL列表。这是由目标的传递依赖项中所有 ``SHARED`` 目标的位置决定的。\
  如果只需要DLL所在的目录，请参见\ :genex:`TARGET_RUNTIME_DLL_DIRS`\ 生成器表达式。
  在可执行文件、\ ``SHARED``\ 库和\ ``MODULE``\ 库以外的目标上使用此生成器表达式是错误的。\
  **在非dll平台上，这个表达式总是求值为空字符串**。

  可以使用\ :option:`cmake -E copy -t <cmake-E copy>`\
  命令将目标所依赖的所有DLL复制到\ ``POST_BUILD``\ 自定义命令的输出目录中。例如：

  .. code-block:: cmake

    find_package(foo CONFIG REQUIRED) # package generated by install(EXPORT)

    add_executable(exe main.c)
    target_link_libraries(exe PRIVATE foo::foo foo::bar)
    add_custom_command(TARGET exe POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy -t $<TARGET_FILE_DIR:exe> $<TARGET_RUNTIME_DLLS:exe>
      COMMAND_EXPAND_LISTS
    )

  .. note::

    :ref:`Imported Targets`\ 的目标只有在知道其\ ``.dll``\ 文件的位置时才会被支持。\
    导入的\ ``SHARED``\ 库必须将\ :prop_tgt:`IMPORTED_LOCATION`\ 设置为其\ ``.dll``\
    文件。有关详细信息，请参阅\ :ref:`add_library导入库 <add_library imported libraries>`\
    部分。许多查找模块生成\ ``UNKNOWN``\ 类型的导入目标，因此将被忽略。

  在支持运行时路径（\ ``RPATH``\ ）的平台上，请参考\ :prop_tgt:`INSTALL_RPATH`\ 目标属性。\
  在Apple平台上，请参考\ :prop_tgt:`INSTALL_NAME_DIR`\ 目标属性。

.. genex:: $<TARGET_RUNTIME_DLL_DIRS:tgt>

  .. versionadded:: 3.27

  包含目标运行时所依赖的DLL的目录列表（参见\ :genex:`TARGET_RUNTIME_DLLS`\ ）。这是由目\
  标的传递依赖项中所有\ ``SHARED``\ 目标的位置决定的。在可执行文件、\ ``SHARED``\ 库和\
  ``MODULE``\ 库以外的目标上使用此生成器表达式是错误的。\ **在非DLL平台上，此表达式的计算\
  结果始终为空字符串**。

  这个生成器表达式可以用来创建一个批处理文件，使用\ :command:`file(GENERATE)`\ 来设置相\
  应的PATH环境变量。

导出和安装表达式
------------------------------

.. genex:: $<INSTALL_INTERFACE:...>

  ``...``\ 的内容当使用\ :command:`install(EXPORT)`\ 导出属性时，否则为空。

.. genex:: $<BUILD_INTERFACE:...>

  当使用\ :command:`export`\ 导出属性时的\ ``...``\ 内容，或者当目标被同一构建系统中的\
  另一个目标使用时。否则展开为空字符串。

.. genex:: $<BUILD_LOCAL_INTERFACE:...>

  .. versionadded:: 3.26

  ``...``\ 的内容当目标被同一构建系统中的另一个目标使用时。否则展开为空字符串。

.. genex:: $<INSTALL_PREFIX>

  当通过\ :command:`install(EXPORT)`\ 导出目标时，或在\ :prop_tgt:`INSTALL_NAME_DIR`\
  属性、\ :command:`install(RUNTIME_DEPENDENCY_SET)`\ 的\ ``INSTALL_NAME_DIR``\
  参数中求值时，安装前缀的内容，否则为空。

  .. versionchanged:: 3.27
    计算为\ :command:`install(CODE)`\ 的code参数或\ :command:`install(SCRIPT)`\
    的文件参数中的安装前缀内容。

多层表达式求值
---------------------------------

.. genex:: $<GENEX_EVAL:expr>

  .. versionadded:: 3.12

  在当前上下文中作为生成器表达式计算的\ ``expr``\ 的内容。这允许使用生成器表达式，\
  其计算结果本身就是生成器表达式。

.. genex:: $<TARGET_GENEX_EVAL:tgt,expr>

  .. versionadded:: 3.12

  ``expr``\ 的内容在\ ``tgt``\ 目标的上下文中作为生成器表达式计算。这允许使用本身包含生成\
  器表达式的自定义目标属性。

  当你希望管理支持生成器表达式的自定义属性时，具有计算生成器表达式的功能非常有用。例如：

  .. code-block:: cmake

    add_library(foo ...)

    set_property(TARGET foo PROPERTY
      CUSTOM_KEYS $<$<CONFIG:DEBUG>:FOO_EXTRA_THINGS>
    )

    add_custom_target(printFooKeys
      COMMAND ${CMAKE_COMMAND} -E echo $<TARGET_PROPERTY:foo,CUSTOM_KEYS>
    )

  ``printFooKeys``\ 自定义命令的简单实现是错误的，因为\ ``CUSTOM_KEYS``\ 目标属性没有被计算，\
  并且内容按原样传递（即\ ``$<$<CONFIG:DEBUG>:FOO_EXTRA_THINGS>``）。

  为了得到预期的结果（例如，如果config是\ ``Debug``，则\ ``FOO_EXTRA_THINGS``），\
  需要计算\ ``$<TARGET_PROPERTY:foo,CUSTOM_KEYS>``\ 的输出：

  .. code-block:: cmake

    add_custom_target(printFooKeys
      COMMAND ${CMAKE_COMMAND} -E
        echo $<TARGET_GENEX_EVAL:foo,$<TARGET_PROPERTY:foo,CUSTOM_KEYS>>
    )

转义字符
------------------

这些表达式求值为特定的字符串字面量。使用它们来代替实际的字符串字面量，以防止它们具有特殊的含义。

.. genex:: $<ANGLE-R>

  一个\ ``>``\ 字面量。例如，用于比较包含\ ``>``\ 的字符串。

.. genex:: $<COMMA>

  一个\ ``,``\ 字面量。用于比较包含\ ``,``\ 的字符串。

.. genex:: $<SEMICOLON>

  一个\ ``;``\ 字面量。用于防止\ ``;``\ 对参数进行列表扩展。

.. genex:: $<QUOTE>

  .. versionadded:: 3.30

  ``"``\ 字面量。用于允许在生成器表达式中使用字符串字面量引号。


弃用表达式
----------------------

.. genex:: $<CONFIGURATION>

  配置名称。CMake 3.0后已弃用。用\ :genex:`CONFIG`\ 代替。
