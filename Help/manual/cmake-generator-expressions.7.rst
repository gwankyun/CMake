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

如果\ :variable:`CMAKE_CXX_COMPILER_VERSION <CMAKE_<LANG>_COMPILER_VERSION>`\ 小于4.2.0，\
则上述内容将扩展为\ ``OLD_COMPILER``。

空格和引号
======================

生成器表达式通常在命令参数之后进行解析。如果生成器表达式包含空格、新行、分号或其他可能被解释为命令参数分隔符的字符，\
则整个表达式在传递给命令时应该用引号括起来。如果不这样做，可能会导致表达式被拆分，并\
且可能不再将其识别为生成器表达式。

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
因此不可能使用\ :command:`message()`\ 命令检查它们的结果。生成调试消息的一种可能的方法是添加一个自定义目标：

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

  这个参考偏离了大多数CMake文档，因为它省略了尖括号\ ``<...>``\ 围绕占位符，\
  如 ``condition``、\ ``string``、\ ``target``\ 等。这是为了防止那些占位符被错误地解释为生成器表达式。

.. _`Conditional Generator Expressions`:

条件表达式
-----------------------

生成器表达式的一个基本类别与条件逻辑有关。支持两种形式的条件生成器表达式：

.. genex:: $<condition:true_string>

  如果\ ``condition``\ 为\ ``1``，则返回\ ``true_string``；如果\ ``condition``\ 为 ``0``，\
  则返回空字符串。\ ``condition``\ 的任何其他值都会导致错误。

.. genex:: $<IF:condition,true_string,false_string>

  .. versionadded:: 3.8

  如果\ ``condition``\ 为\ ``1``，则返回\ ``true_string``；如果 ``condition`` 为 ``0``，\
  则返回\ ``false_string``。\ ``condition``\ 的任何其他值都会导致错误。

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

  其中\ ``conditions``\ 是一个以逗号分隔的布尔表达式列表，所有这些表达式的值必须为\ ``1``\ 或\ ``0``。\
  如果所有条件都为\ ``1``，则整个表达式的值为\ ``1``。如果任何条件为\ ``0``，整个表达式的计算结果为\ ``0``。

.. genex:: $<OR:conditions>

  其中\ ``conditions``\ 是逗号分隔的布尔表达式列表。所有这些都必须等于\ ``1``\ 或\ ``0``。\
  如果至少有一个条件为\ ``1``，则整个表达式的值为\ ``1``。如果所有条件的值为\ ``0``，\
  则整个表达式的值为\ ``0``。

.. genex:: $<NOT:condition>

  ``condition``\ 必须为\ ``0``\ 或\ ``1``。如果\ ``condition``\ 为\ ``1``，\
  表达式的结果为\ ``0``，否则为\ ``1``。

.. _`Comparison Expressions`:

主要比较表达式
------------------------------

CMake支持各种生成器表达式进行比较。本节将介绍主要的和最广泛使用的比较类型。\
其他更具体的比较类型将在后面单独的部分中进行说明。

字符串比较
^^^^^^^^^^^^^^^^^^

.. genex:: $<STREQUAL:string1,string2>

  如果\ ``string1``\ 和\ ``string2``\ 相等，则为\ ``1``，否则为\ ``0``。比较是区分大小写的。\
  要进行不区分大小写的比较，请与\ :ref:`字符串转换生成器表达式 <String Transforming Generator Expressions>`\
  结合使用。例如，如果\ ``${foo}``\ 是\ ``BAR``、\ ``Bar``、\ ``bar``\ 等中的任意一个，\
  则下面的计算结果为\ ``1``。

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

  ``...``\ 的内容转换为C标识符。转换遵循与\ :command:`string(MAKE_C_IDENTIFIER)`\ 相同的行为。

列表表达式
----------------

.. genex:: $<IN_LIST:string,list>

  .. versionadded:: 3.12

  如果\ ``string``\ 是分号分隔\ ``list``\ 中的项，则为\ ``1``，否则为\ ``0``。\
  它使用区分大小写的比较。

.. genex:: $<JOIN:list,string>

  用插入在每个项之间的\ ``string``\ 内容连接列表。

.. genex:: $<REMOVE_DUPLICATES:list>

  .. versionadded:: 3.15

  删除给定\ ``list``\ 中的重复项。保留项的相对顺序，但如果遇到重复项，则只保留第一个实例。

.. genex:: $<FILTER:list,INCLUDE|EXCLUDE,regex>

  .. versionadded:: 3.15

  从\ ``list``\ 中包含或删除与正则表达式\ ``regex``\ 匹配的项。

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

  ::

    $<PATH:GET_ROOT_NAME,path>
    $<PATH:GET_ROOT_DIRECTORY,path>
    $<PATH:GET_ROOT_PATH,path>
    $<PATH:GET_FILENAME,path>
    $<PATH:GET_EXTENSION[,LAST_ONLY],path>
    $<PATH:GET_STEM[,LAST_ONLY],path>
    $<PATH:GET_RELATIVE_PART,path>
    $<PATH:GET_PARENT_PATH,path>

  如果请求的组件不在路径中，则返回空字符串。

.. _GenEx Path Transformations:

路径转换
^^^^^^^^^^^^^^^^^^^^

这些表达式提供了等同于\ :command:`cmake_path`\ 命令的\ :ref:`Modification <Path Modification>`\
和\ :ref:`Generation <Path Generation>`\ 选项的生成时功能。所有路径都应该是cmake样式的格式。

.. _GenEx PATH-CMAKE_PATH:

.. genex:: $<PATH:CMAKE_PATH[,NORMALIZE],path>

  .. versionadded:: 3.24

  返回\ ``path``。如果\ ``path``\ 是原生路径，它将转换为带有正斜杠（\ ``/``\ ）的cmake样式的路径。\
  在Windows上，长文件名标记会被考虑在内。

  当指定\ ``NORMALIZE``\ 选项时，转换后将对路径进行\ :ref:`normalized
  <Normalization>`。

.. genex:: $<PATH:APPEND,path,input,...>

  .. versionadded:: 3.24

  返回以\ ``/``\ 作为\ ``directory-separator``\ 附加到\ ``path``\ 的所有\ ``input``\ 参数。\
  根据\ ``input``\ 的不同，\ ``path``\ 的值可能会被丢弃。

  请参阅\ :ref:`cmake_path(APPEND) <APPEND>`\ 了解更多详细信息。

.. genex:: $<PATH:REMOVE_FILENAME,path>

  .. versionadded:: 3.24

  返回删除了文件名组件（由\ ``$<PATH:GET_FILENAME>``\ 返回）的\ ``path``。删除之后，\
  任何尾随的\ ``directory-separator``\ （如果存在的话）都将保持不变。

  参见\ :ref:`cmake_path(REMOVE_FILENAME) <REMOVE_FILENAME>`\ 了解更多细节。

.. genex:: $<PATH:REPLACE_FILENAME,path,input>

  .. versionadded:: 3.24

  返回\ ``path``，其中文件组件被\ ``input``\ 替换。如果\ ``path``\ 没有文件名组件\
  （例如\ ``$<PATH:HAS_FILENAME>``\ 返回\ ``0``），\ ``path``\ 不变。

  参见\ :ref:`cmake_path(REPLACE_FILENAME) <REPLACE_FILENAME>`\ 了解更多细节。

.. genex:: $<PATH:REMOVE_EXTENSION[,LAST_ONLY],path>

  .. versionadded:: 3.24

  返回已删除\ :ref:`extension <EXTENSION_DEF>`\ 的\ ``path``，如果有的话。

  有关详细信息，请参阅\ :ref:`cmake_path(REMOVE_EXTENSION) <REMOVE_EXTENSION>`。

.. genex:: $<PATH:REPLACE_EXTENSION[,LAST_ONLY],path,input>

  .. versionadded:: 3.24

  返回\ ``path``，其中\ :ref:`extension <EXTENSION_DEF>`\ 替换为\ ``input``，\
  如果有的话。

  详细信息请参见\ :ref:`cmake_path(REPLACE_EXTENSION) <REPLACE_EXTENSION>`。

.. genex:: $<PATH:NORMAL_PATH,path>

  .. versionadded:: 3.24

  返回根据\ :ref:`Normalization`\ 中描述的步骤归一化的\ ``path``。

.. genex:: $<PATH:RELATIVE_PATH,path,base_directory>

  .. versionadded:: 3.24

  返回\ ``path``，修改后使其相对于\ ``base_directory``\ 参数。

  有关更多细节，请参阅\ :ref:`cmake_path(RELATIVE_PATH) <cmake_path-RELATIVE_PATH>`。

.. genex:: $<PATH:ABSOLUTE_PATH[,NORMALIZE],path,base_directory>

  .. versionadded:: 3.24

  返回绝对\ ``path``。如果\ ``path``\ 是一个相对路径（\ ``$<PATH:IS_RELATIVE>``\ 返回\ ``1``），\
  它将相对于\ ``base_directory``\ 参数指定的给定基目录进行计算。

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
  数中的最外层生成器表达式有效。对于\ :generator:`Ninja Multi-Config`\ 生成器，生成器表达式在\
  ``...``\ 使用自定义命令的“输出配置”进行计算。使用其他生成器，\ ``...``\ 正常计算。

.. genex:: $<COMMAND_CONFIG:...>

  .. versionadded:: 3.20

  仅在\ :command:`add_custom_command`\ 和\ :command:`add_custom_target`\ 中作为参\
  数中的最外层生成器表达式有效。对于\ :generator:`Ninja Multi-Config`\ 生成器，生成器表达式在\
  ``...``\ 使用自定义命令的“命令配置”进行计算。使用其他生成器，\ ``...``\ 正常计算。

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

  如果CXX编译器的版本与\ ``version``\ 匹配，则为\ ``1``，否则为\ ``0``。

.. genex:: $<CUDA_COMPILER_VERSION>

  .. versionadded:: 3.15

  使用的CUDA编译器的版本。

.. genex:: $<CUDA_COMPILER_VERSION:version>

  .. versionadded:: 3.15

  如果CUDA编译器的版本与\ ``version``\ 匹配，则为\ ``1``，否则为\ ``0``。

.. genex:: $<OBJC_COMPILER_VERSION>

  .. versionadded:: 3.16

  使用的OBJC编译器的版本。

.. genex:: $<OBJC_COMPILER_VERSION:version>

  .. versionadded:: 3.16

  如果OBJC编译器的版本与\ ``version``\ 匹配，则为\ ``1``，否则为\ ``0``。

.. genex:: $<OBJCXX_COMPILER_VERSION>

  .. versionadded:: 3.16

  使用的OBJCXX编译器的版本。

.. genex:: $<OBJCXX_COMPILER_VERSION:version>

  .. versionadded:: 3.16

  如果OBJCXX编译器的版本与\ ``version``\ 匹配，则为\ ``1``，否则为\ ``0``。

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

编译器语言和ID
^^^^^^^^^^^^^^^^^^^^^^^^

另请参阅\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量，该变量与本小节中的大多数表达式密切相关。

.. genex:: $<C_COMPILER_ID>

  CMake使用的C编译器的id。

.. genex:: $<C_COMPILER_ID:compiler_ids>

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的C编译器id与\ ``compiler_ids``\
  中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

.. genex:: $<CXX_COMPILER_ID>

  CMake使用的CXX编译器的id。

.. genex:: $<CXX_COMPILER_ID:compiler_ids>

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的CXX编译器id与\ ``compiler_ids``\
  中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

.. genex:: $<CUDA_COMPILER_ID>

  .. versionadded:: 3.15

  CMake使用的CUDA编译器的id。

.. genex:: $<CUDA_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.15

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的CUDA编译器id与\ ``compiler_ids``\
  中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

.. genex:: $<OBJC_COMPILER_ID>

  .. versionadded:: 3.16

  CMake使用的OBJC编译器的id。

.. genex:: $<OBJC_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.16

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的Objective-C编译器id与\ ``compiler_ids``\
  中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

.. genex:: $<OBJCXX_COMPILER_ID>

  .. versionadded:: 3.16

  CMake使用的OBJCXX编译器的id。

.. genex:: $<OBJCXX_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.16

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的Objective-C++编译器id与\ ``compiler_ids``\
  中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

.. genex:: $<Fortran_COMPILER_ID>

  CMake使用的Fortran编译器的id。

.. genex:: $<Fortran_COMPILER_ID:compiler_ids>

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的Fortran编译器id与\ ``compiler_ids``\
  中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

.. genex:: $<HIP_COMPILER_ID>

  .. versionadded:: 3.21

  CMake使用的HIP编译器的id。

.. genex:: $<HIP_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.21

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的HIP编译器id与\ ``compiler_ids``\
  中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

.. genex:: $<ISPC_COMPILER_ID>

  .. versionadded:: 3.19

  CMake使用的ISPC编译器的id。

.. genex:: $<ISPC_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.19

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CMake的ISPC编译器id与\ ``compiler_ids``\
  中的任何一个条目匹配，则返回\ ``1``，否则为\ ``0``。

.. genex:: $<COMPILE_LANGUAGE>

  .. versionadded:: 3.3

  计算编译选项时源文件的编译语言。关于生成器表达式的可移植性，请参阅\
  :ref:`相关的布尔表达式 <Boolean COMPILE_LANGUAGE Generator Expression>`\ ``$<COMPILE_LANGUAGE:language>``。

.. _`Boolean COMPILE_LANGUAGE Generator Expression`:

.. genex:: $<COMPILE_LANGUAGE:languages>

  .. versionadded:: 3.3

  .. versionchanged:: 3.15
    可以为\ ``languages``\ 指定多种语言。CMake 3.14及更早版本只接受单一语言。

  当用于编译单元的语言与\ ``languages``\ 中任何以逗号分隔的条目匹配时，则为\ ``1``，\
  否则为\ ``0``。此表达式可用于指定编译选项、编译定义，并在目标中包含特定语言的源文件的目录。例如：

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
  则会报告错误。有关编译特性的信息和支持的编译器列表，请参阅\ :manual:`cmake-compile-features(7)`\ 手册。

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

  当用于链接步骤的语言匹配\ ``languages``\ 中任何以逗号分隔的条目时，则为\ ``1``，否则为\ ``0``。\
  此表达式可用于指定目标中特定语言的链接库、链接选项、链接目录和链接依赖项。例如：

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
    在第一次传递之后计算的链接语言将用于第二次传递。为了避免不一致，要求第二次传递不改变链接语言。\
    此外，为了避免意外的副作用，需要指定完整的实体作为\ ``$<LINK_LANGUAGE:..>``\ 表达式。例如：

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

Link Context
^^^^^^^^^^^^

.. genex:: $<LINK_ONLY:...>

  .. versionadded:: 3.1

  Content of ``...``, except while collecting :ref:`Target Usage Requirements`,
  in which case it is the empty string.  This is intended for use in an
  :prop_tgt:`INTERFACE_LINK_LIBRARIES` target property, typically populated
  via the :command:`target_link_libraries` command, to specify private link
  dependencies without other usage requirements.

  .. versionadded:: 3.24
    ``LINK_ONLY`` may also be used in a :prop_tgt:`LINK_LIBRARIES` target
    property.  See policy :policy:`CMP0131`.

.. genex:: $<DEVICE_LINK:list>

  .. versionadded:: 3.18

  Returns the list if it is the device link step, an empty list otherwise.
  The device link step is controlled by :prop_tgt:`CUDA_SEPARABLE_COMPILATION`
  and :prop_tgt:`CUDA_RESOLVE_DEVICE_SYMBOLS` properties and
  policy :policy:`CMP0105`. This expression can only be used to specify link
  options.

.. genex:: $<HOST_LINK:list>

  .. versionadded:: 3.18

  Returns the list if it is the normal link step, an empty list otherwise.
  This expression is mainly useful when a device link step is also involved
  (see :genex:`$<DEVICE_LINK:list>` generator expression). This expression can
  only be used to specify link options.


.. _`Target-Dependent Queries`:

Target-Dependent Expressions
----------------------------

These queries refer to a target ``tgt``. Unless otherwise stated, this can
be any runtime artifact, namely:

* An executable target created by :command:`add_executable`.
* A shared library target (``.so``, ``.dll`` but not their ``.lib`` import
  library) created by :command:`add_library`.
* A static library target created by :command:`add_library`.

In the following, the phrase "the ``tgt`` filename" means the name of the
``tgt`` binary file. This has to be distinguished from the phrase
"the target name", which is just the string ``tgt``.

.. genex:: $<TARGET_EXISTS:tgt>

  .. versionadded:: 3.12

  ``1`` if ``tgt`` exists as a CMake target, else ``0``.

.. genex:: $<TARGET_NAME_IF_EXISTS:tgt>

  .. versionadded:: 3.12

  The target name ``tgt`` if the target exists, an empty string otherwise.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on.

.. genex:: $<TARGET_NAME:...>

  Marks ``...`` as being the name of a target.  This is required if exporting
  targets to multiple dependent export sets.  The ``...`` must be a literal
  name of a target, it may not contain generator expressions.

.. genex:: $<TARGET_PROPERTY:tgt,prop>

  Value of the property ``prop`` on the target ``tgt``.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on.

  .. versionchanged:: 3.26
    When encountered during evaluation of :ref:`Target Usage Requirements`,
    typically in an ``INTERFACE_*`` target property, lookup of the ``tgt``
    name occurs in the directory of the target specifying the requirement,
    rather than the directory of the consuming target for which the
    expression is being evaluated.

.. genex:: $<TARGET_PROPERTY:prop>

  Value of the property ``prop`` on the target for which the expression
  is being evaluated. Note that for generator expressions in
  :ref:`Target Usage Requirements` this is the consuming target rather
  than the target specifying the requirement.

.. genex:: $<TARGET_OBJECTS:tgt>

  .. versionadded:: 3.1

  List of objects resulting from building ``tgt``.  This would typically be
  used on :ref:`object library <Object Libraries>` targets.

.. genex:: $<TARGET_POLICY:policy>

  ``1`` if the ``policy`` was ``NEW`` when the 'head' target was created,
  else ``0``.  If the ``policy`` was not set, the warning message for the policy
  will be emitted. This generator expression only works for a subset of
  policies.

.. genex:: $<TARGET_FILE:tgt>

  Full path to the ``tgt`` binary file.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on, unless the expression is being used in
  :command:`add_custom_command` or :command:`add_custom_target`.

.. genex:: $<TARGET_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.15

  Base name of ``tgt``, i.e. ``$<TARGET_FILE_NAME:tgt>`` without prefix and
  suffix.
  For example, if the ``tgt`` filename is ``libbase.so``, the base name is ``base``.

  See also the :prop_tgt:`OUTPUT_NAME`, :prop_tgt:`ARCHIVE_OUTPUT_NAME`,
  :prop_tgt:`LIBRARY_OUTPUT_NAME` and :prop_tgt:`RUNTIME_OUTPUT_NAME`
  target properties and their configuration specific variants
  :prop_tgt:`OUTPUT_NAME_<CONFIG>`, :prop_tgt:`ARCHIVE_OUTPUT_NAME_<CONFIG>`,
  :prop_tgt:`LIBRARY_OUTPUT_NAME_<CONFIG>` and
  :prop_tgt:`RUNTIME_OUTPUT_NAME_<CONFIG>`.

  The :prop_tgt:`<CONFIG>_POSTFIX` and :prop_tgt:`DEBUG_POSTFIX` target
  properties can also be considered.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on.

.. genex:: $<TARGET_FILE_PREFIX:tgt>

  .. versionadded:: 3.15

  Prefix of the ``tgt`` filename (such as ``lib``).

  See also the :prop_tgt:`PREFIX` target property.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on.

.. genex:: $<TARGET_FILE_SUFFIX:tgt>

  .. versionadded:: 3.15

  Suffix of the ``tgt`` filename (extension such as ``.so`` or ``.exe``).

  See also the :prop_tgt:`SUFFIX` target property.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on.

.. genex:: $<TARGET_FILE_NAME:tgt>

  The ``tgt`` filename.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on (see policy :policy:`CMP0112`).

.. genex:: $<TARGET_FILE_DIR:tgt>

  Directory of the ``tgt`` binary file.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on (see policy :policy:`CMP0112`).

.. genex:: $<TARGET_LINKER_FILE:tgt>

  File used when linking to the ``tgt`` target.  This will usually
  be the library that ``tgt`` represents (``.a``, ``.lib``, ``.so``),
  but for a shared library on DLL platforms, it would be the ``.lib``
  import library associated with the DLL.

.. genex:: $<TARGET_LINKER_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.15

  Base name of file used to link the target ``tgt``, i.e.
  ``$<TARGET_LINKER_FILE_NAME:tgt>`` without prefix and suffix. For example,
  if target file name is ``libbase.a``, the base name is ``base``.

  See also the :prop_tgt:`OUTPUT_NAME`, :prop_tgt:`ARCHIVE_OUTPUT_NAME`,
  and :prop_tgt:`LIBRARY_OUTPUT_NAME` target properties and their configuration
  specific variants :prop_tgt:`OUTPUT_NAME_<CONFIG>`,
  :prop_tgt:`ARCHIVE_OUTPUT_NAME_<CONFIG>` and
  :prop_tgt:`LIBRARY_OUTPUT_NAME_<CONFIG>`.

  The :prop_tgt:`<CONFIG>_POSTFIX` and :prop_tgt:`DEBUG_POSTFIX` target
  properties can also be considered.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on.

.. genex:: $<TARGET_LINKER_FILE_PREFIX:tgt>

  .. versionadded:: 3.15

  Prefix of file used to link target ``tgt``.

  See also the :prop_tgt:`PREFIX` and :prop_tgt:`IMPORT_PREFIX` target
  properties.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on.

.. genex:: $<TARGET_LINKER_FILE_SUFFIX:tgt>

  .. versionadded:: 3.15

  Suffix of file used to link where ``tgt`` is the name of a target.

  The suffix corresponds to the file extension (such as ".so" or ".lib").

  See also the :prop_tgt:`SUFFIX` and :prop_tgt:`IMPORT_SUFFIX` target
  properties.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on.

.. genex:: $<TARGET_LINKER_FILE_NAME:tgt>

  Name of file used to link target ``tgt``.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on (see policy :policy:`CMP0112`).

.. genex:: $<TARGET_LINKER_FILE_DIR:tgt>

  Directory of file used to link target ``tgt``.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on (see policy :policy:`CMP0112`).

.. genex:: $<TARGET_SONAME_FILE:tgt>

  File with soname (``.so.3``) where ``tgt`` is the name of a target.
.. genex:: $<TARGET_SONAME_FILE_NAME:tgt>

  Name of file with soname (``.so.3``).

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on (see policy :policy:`CMP0112`).

.. genex:: $<TARGET_SONAME_FILE_DIR:tgt>

  Directory of with soname (``.so.3``).

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on (see policy :policy:`CMP0112`).

.. genex:: $<TARGET_PDB_FILE:tgt>

  .. versionadded:: 3.1

  Full path to the linker generated program database file (.pdb)
  where ``tgt`` is the name of a target.

  See also the :prop_tgt:`PDB_NAME` and :prop_tgt:`PDB_OUTPUT_DIRECTORY`
  target properties and their configuration specific variants
  :prop_tgt:`PDB_NAME_<CONFIG>` and :prop_tgt:`PDB_OUTPUT_DIRECTORY_<CONFIG>`.

.. genex:: $<TARGET_PDB_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.15

  Base name of the linker generated program database file (.pdb)
  where ``tgt`` is the name of a target.

  The base name corresponds to the target PDB file name (see
  ``$<TARGET_PDB_FILE_NAME:tgt>``) without prefix and suffix. For example,
  if target file name is ``base.pdb``, the base name is ``base``.

  See also the :prop_tgt:`PDB_NAME` target property and its configuration
  specific variant :prop_tgt:`PDB_NAME_<CONFIG>`.

  The :prop_tgt:`<CONFIG>_POSTFIX` and :prop_tgt:`DEBUG_POSTFIX` target
  properties can also be considered.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on.

.. genex:: $<TARGET_PDB_FILE_NAME:tgt>

  .. versionadded:: 3.1

  Name of the linker generated program database file (.pdb).

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on (see policy :policy:`CMP0112`).

.. genex:: $<TARGET_PDB_FILE_DIR:tgt>

  .. versionadded:: 3.1

  Directory of the linker generated program database file (.pdb).

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on (see policy :policy:`CMP0112`).

.. genex:: $<TARGET_BUNDLE_DIR:tgt>

  .. versionadded:: 3.9

  Full path to the bundle directory (``/path/to/my.app``,
  ``/path/to/my.framework``, or ``/path/to/my.bundle``),
  where ``tgt`` is the name of a target.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on (see policy :policy:`CMP0112`).

.. genex:: $<TARGET_BUNDLE_DIR_NAME:tgt>

  .. versionadded:: 3.24

  Name of the bundle directory (``my.app``, ``my.framework``, or
  ``my.bundle``), where ``tgt`` is the name of a target.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on (see policy :policy:`CMP0112`).

.. genex:: $<TARGET_BUNDLE_CONTENT_DIR:tgt>

  .. versionadded:: 3.9

  Full path to the bundle content directory where ``tgt`` is the name of a
  target.  For the macOS SDK it leads to ``/path/to/my.app/Contents``,
  ``/path/to/my.framework``, or ``/path/to/my.bundle/Contents``.
  For all other SDKs (e.g. iOS) it leads to ``/path/to/my.app``,
  ``/path/to/my.framework``, or ``/path/to/my.bundle`` due to the flat
  bundle structure.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on (see policy :policy:`CMP0112`).

.. genex:: $<TARGET_RUNTIME_DLLS:tgt>

  .. versionadded:: 3.21

  List of DLLs that the target depends on at runtime. This is determined by
  the locations of all the ``SHARED`` targets in the target's transitive
  dependencies. Using this generator expression on targets other than
  executables, ``SHARED`` libraries, and ``MODULE`` libraries is an error.
  **On non-DLL platforms, this expression always evaluates to an empty string**.

  This generator expression can be used to copy all of the DLLs that a target
  depends on into its output directory in a ``POST_BUILD`` custom command using
  the :option:`cmake -E copy -t <cmake-E copy>` command. For example:

  .. code-block:: cmake

    find_package(foo CONFIG REQUIRED) # package generated by install(EXPORT)

    add_executable(exe main.c)
    target_link_libraries(exe PRIVATE foo::foo foo::bar)
    add_custom_command(TARGET exe POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy -t $<TARGET_FILE_DIR:exe> $<TARGET_RUNTIME_DLLS:exe>
      COMMAND_EXPAND_LISTS
    )

  .. note::

    :ref:`Imported Targets` are supported only if they know the location
    of their ``.dll`` files.  An imported ``SHARED`` library must have
    :prop_tgt:`IMPORTED_LOCATION` set to its ``.dll`` file.  See the
    :ref:`add_library imported libraries <add_library imported libraries>`
    section for details.  Many :ref:`Find Modules` produce imported targets
    with the ``UNKNOWN`` type and therefore will be ignored.

On platforms that support runtime paths (``RPATH``), refer to the
:prop_tgt:`INSTALL_RPATH` target property.
On Apple platforms, refer to the :prop_tgt:`INSTALL_NAME_DIR` target property.

Export And Install Expressions
------------------------------

.. genex:: $<INSTALL_INTERFACE:...>

  Content of ``...`` when the property is exported using
  :command:`install(EXPORT)`, and empty otherwise.

.. genex:: $<BUILD_INTERFACE:...>

  当使用\ :command:`export`\ 导出属性时的\ ``...``\ 内容，或者当目标被同一构建系统中的另一个目标使用时。否则展开为空字符串。

.. genex:: $<BUILD_LOCAL_INTERFACE:...>

  .. versionadded:: 3.26

  Content of ``...`` when the target is used by another target in the same
  buildsystem. Expands to the empty string otherwise.

.. genex:: $<INSTALL_PREFIX>

  Content of the install prefix when the target is exported via
  :command:`install(EXPORT)`, or when evaluated in the
  :prop_tgt:`INSTALL_NAME_DIR` property or the ``INSTALL_NAME_DIR`` argument of
  :command:`install(RUNTIME_DEPENDENCY_SET)`, and empty otherwise.

Multi-level Expression Evaluation
---------------------------------

.. genex:: $<GENEX_EVAL:expr>

  .. versionadded:: 3.12

  Content of ``expr`` evaluated as a generator expression in the current
  context. This enables consumption of generator expressions whose
  evaluation results itself in generator expressions.

.. genex:: $<TARGET_GENEX_EVAL:tgt,expr>

  .. versionadded:: 3.12

  Content of ``expr`` evaluated as a generator expression in the context of
  ``tgt`` target. This enables consumption of custom target properties that
  themselves contain generator expressions.

  Having the capability to evaluate generator expressions is very useful when
  you want to manage custom properties supporting generator expressions.
  For example:

  .. code-block:: cmake

    add_library(foo ...)

    set_property(TARGET foo PROPERTY
      CUSTOM_KEYS $<$<CONFIG:DEBUG>:FOO_EXTRA_THINGS>
    )

    add_custom_target(printFooKeys
      COMMAND ${CMAKE_COMMAND} -E echo $<TARGET_PROPERTY:foo,CUSTOM_KEYS>
    )

  This naive implementation of the ``printFooKeys`` custom command is wrong
  because ``CUSTOM_KEYS`` target property is not evaluated and the content
  is passed as is (i.e. ``$<$<CONFIG:DEBUG>:FOO_EXTRA_THINGS>``).

  To have the expected result (i.e. ``FOO_EXTRA_THINGS`` if config is
  ``Debug``), it is required to evaluate the output of
  ``$<TARGET_PROPERTY:foo,CUSTOM_KEYS>``:

  .. code-block:: cmake

    add_custom_target(printFooKeys
      COMMAND ${CMAKE_COMMAND} -E
        echo $<TARGET_GENEX_EVAL:foo,$<TARGET_PROPERTY:foo,CUSTOM_KEYS>>
    )

Escaped Characters
------------------

These expressions evaluate to specific string literals. Use them in place of
the actual string literal where you need to prevent them from having their
special meaning.

.. genex:: $<ANGLE-R>

  A literal ``>``. Used for example to compare strings that contain a ``>``.

.. genex:: $<COMMA>

  A literal ``,``. Used for example to compare strings which contain a ``,``.

.. genex:: $<SEMICOLON>

  A literal ``;``. Used to prevent list expansion on an argument with ``;``.

Deprecated Expressions
----------------------

.. genex:: $<CONFIGURATION>

  Configuration name. Deprecated since CMake 3.0. Use :genex:`CONFIG` instead.
