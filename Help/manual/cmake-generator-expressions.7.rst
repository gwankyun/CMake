.. cmake-manual-description: CMake Generator Expressions

cmake-generator-expressions(7)
******************************

.. only:: html

   .. contents::

引言
============

生成器表达式在构建系统生成期间进行计算，以生成特定于每个构建配置的信息。

生成器表达式可以在许多目标属性的语境中使用，例如\ :prop_tgt:`LINK_LIBRARIES`、:prop_tgt:`INCLUDE_DIRECTORIES`、:prop_tgt:`COMPILE_DEFINITIONS`\ 等。也可以在使用命令填充这些属性时使用它们，例如\ :command:`target_link_libraries`、:command:`target_include_directories`、:command:`target_compile_definitions` 等。

它们支持条件链接、编译时使用条件定义、条件包含目录等等。条件可能基于构建配置、目标属性、平台信息或任何其他可查询的信息。

生成器表达式的形式是\ ``$<...>``。为了避免混淆，这个页面与大多数CMake文档不同，它省略了尖括号\ ``<...>``\ 围绕占位符，如\ ``condition``、``string``、``target``\ 等。

生成器表达式可以嵌套使用，如下面的大多数示例所示。

.. _`Boolean Generator Expressions`:

布尔生成器表达式
=============================

布尔表达式的值为\ ``0``\ 或\ ``1``。它们通常用于在\ :ref:`条件生成器表达式<Conditional Generator Expressions>`\ 中作为构造条件。

可用的布尔表达式有：

逻辑操作符
-----------------

.. genex:: $<BOOL:string>

  将\ ``string``\ 转换为\ ``0``\ 或\ ``1``。如果以下任意一个为真，则计算为\ ``0``：

  * ``string``\ 是空的，
  * ``string``\ 不区分大小写，等价为\ ``0``、``FALSE``、``OFF``、``N``、``NO``、``IGNORE``\ 或\ ``NOTFOUND``，或
  * ``string``\ 以\ ``-NOTFOUND``\ 后缀结束（区分大小写）。

  否则等于\ ``1``。

.. genex:: $<AND:conditions>

  其中的\ ``conditions``\ 是一个逗号分隔的布尔表达式列表。如果所有条件都为\ ``1``，则返回\ ``1``。否则等于\ ``0``。

.. genex:: $<OR:conditions>

  其中的\ ``conditions``\ 是一个逗号分隔的布尔表达式列表。如果至少有一个条件是\ ``1``，则返回\ ``1``。否则等于\ ``0``。

.. genex:: $<NOT:condition>

  如果\ ``condition``\ 是\ ``1``，则为\ ``0``，否则为\ ``1``。

字符串比较
------------------

.. genex:: $<STREQUAL:string1,string2>

  如果\ ``string1``\ 和\ ``string2``\ 相等，则为\ ``1``，否则为\ ``0``。比较区分大小写。若要进行大小写不敏感的比较，请与\ :ref:`字符串转换生成器表达式
  <String Transforming Generator Expressions>`\ 结合使用，

  .. code-block:: cmake

    $<STREQUAL:$<UPPER_CASE:${foo}>,"BAR"> # "1" if ${foo} is any of "BAR", "Bar", "bar", ...

.. genex:: $<EQUAL:value1,value2>

  如果\ ``value1``\ 和\ ``value2``\ 在数值上相等则为\ ``1``，否则为\ ``0``。

.. genex:: $<IN_LIST:string,list>

  .. versionadded:: 3.12

  如果\ ``string``\ 是分号分隔\ ``list``\ 的成员，则为\ ``1``，否则为\ ``0``。区分大小写。

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

变量查询
----------------

.. genex:: $<TARGET_EXISTS:target>

  .. versionadded:: 3.12

  如果\ ``target``\ 存在，则为\ ``1``，否则为\ ``0``。

.. genex:: $<CONFIG:cfgs>

  如果配置是逗号分隔列表\ ``cfgs``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。这是一个不区分大小写的比较。:prop_tgt:`MAP_IMPORTED_CONFIG_<CONFIG>`\ 中的映射在对\ :prop_tgt:`IMPORTED`\ 目标的属性求值时也会被该表达式考虑到。

.. genex:: $<PLATFORM_ID:platform_ids>

  其中\ ``platform_ids``\ 是一个逗号分隔的列表。如果CMake的平台标识匹配\ ``platform_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_SYSTEM_NAME`\ 变量。

.. genex:: $<C_COMPILER_ID:compiler_ids>

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果C编译器的CMake编译器标识匹配\ ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<CXX_COMPILER_ID:compiler_ids>

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CXX编译器的CMake编译器标识匹配\ ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<CUDA_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.15

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果CUDA编译器的CMake编译器标识匹配\ ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<OBJC_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.16

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果Objective-C编译器的CMake编译器标识匹配\ ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<OBJCXX_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.16

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果Objective-C++编译器的CMake编译器标识匹配\ ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<Fortran_COMPILER_ID:compiler_ids>

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果Fortran编译器的CMake编译器标识匹配\ ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<HIP_COMPILER_ID:compiler_ids>

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果HIP编译器的CMake编译器标识匹配\ ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<ISPC_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.19

  其中\ ``compiler_ids``\ 是一个逗号分隔的列表。如果ISPC编译器的CMake编译器标识匹配\ ``compiler_ids``\ 中的任何一个条目，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<C_COMPILER_VERSION:version>

  如果C编译器的版本匹配\ ``version``，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<CXX_COMPILER_VERSION:version>

  如果CXX编译器的版本匹配\ ``version``，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<CUDA_COMPILER_VERSION:version>

  .. versionadded:: 3.15

  如果CUDA编译器的版本匹配\ ``version``，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<OBJC_COMPILER_VERSION:version>

  .. versionadded:: 3.16

  如果OBJC编译器的版本匹配\ ``version``，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<OBJCXX_COMPILER_VERSION:version>

  .. versionadded:: 3.16

  如果OBJCXX编译器的版本匹配\ ``version``，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<Fortran_COMPILER_VERSION:version>

  如果Fortran编译器的版本匹配\ ``version``，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<HIP_COMPILER_VERSION:version>

  如果HIP编译器的版本匹配\ ``version``，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<ISPC_COMPILER_VERSION:version>

  .. versionadded:: 3.19

  如果ISPC编译器的版本匹配\ ``version``，则为\ ``1``，否则为\ ``0``。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<TARGET_POLICY:policy>

  如果创建“头”目标时\ ``policy``\ 为NEW，则为\ ``1``，否则为\ ``0``。如果未设置该\ ``policy``，则将发出该策略的警告消息。这个生成器表达式只适用于部分策略。

.. genex:: $<COMPILE_FEATURES:features>

  .. versionadded:: 3.1

  ``features``\ 是一个以逗号分隔的列表。如果所有的\ ``features``\ 都对“头”目标可用，则计算为\ ``1``，否则为\ ``0``。如果在计算目标的链接实现时使用该表达式，并且如果有任何依赖项增加了“头”目标所需的\ :prop_tgt:`C_STANDARD`\ 或\ :prop_tgt:`CXX_STANDARD`，则会报告错误。参考\ :manual:`cmake-compile-features(7)`\ 手册获取编译特性的信息和支持的编译器列表。

.. _`Boolean COMPILE_LANGUAGE Generator Expression`:

.. genex:: $<COMPILE_LANG_AND_ID:language,compiler_ids>

  .. versionadded:: 3.15

  如果用于编译单元的语言与\ ``language``\ 匹配，并且CMake的编译器标识与\ ``compiler_ids``\ 中的任何一个条目匹配，则为\ ``1``，否则为\ ``0``。这个表达式是\ ``$<compile_language:language>``\ 和\ ``$<lang_compiler_id:compiler_ids>``\ 组合的缩写形式。此表达式可用于指定编译选项、编译定义，并目标中特定语言源文件和编译器组合的引用目录。例如：

  .. code-block:: cmake

    add_executable(myapp main.cpp foo.c bar.cpp zot.cu)
    target_compile_definitions(myapp
      PRIVATE $<$<COMPILE_LANG_AND_ID:CXX,AppleClang,Clang>:COMPILING_CXX_WITH_CLANG>
              $<$<COMPILE_LANG_AND_ID:CXX,Intel>:COMPILING_CXX_WITH_INTEL>
              $<$<COMPILE_LANG_AND_ID:C,Clang>:COMPILING_C_WITH_CLANG>
    )

  这指定了基于编译器标识和编译语言的不同编译定义的使用。这个例子中，当Clang是CXX编译器时，会有\ ``COMPILING_CXX_WITH_CLANG``\ 编译定义，而当Intel是CXX编译器时，会有\ ``COMPILING_CXX_WITH_INTEL``\ 编译定义。同样地，当C编译器是Clang时，它只会看到\ ``COMPILING_C_WITH_CLANG``\ 的定义。

  如果没有\ ``COMPILE_LANG_AND_ID``\ 生成器表达式，相同的逻辑将表示为：

  .. code-block:: cmake

    target_compile_definitions(myapp
      PRIVATE $<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CXX_COMPILER_ID:AppleClang,Clang>>:COMPILING_CXX_WITH_CLANG>
              $<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CXX_COMPILER_ID:Intel>>:COMPILING_CXX_WITH_INTEL>
              $<$<AND:$<COMPILE_LANGUAGE:C>,$<C_COMPILER_ID:Clang>>:COMPILING_C_WITH_CLANG>
    )

.. genex:: $<COMPILE_LANGUAGE:languages>

  .. versionadded:: 3.3

  当用于编译单元的语言匹配\ ``languages``\ 中的任何条目时，为\ ``1``，否则为\ ``0``。这个表达式可以用来指定编译选项、编译定义，以及在目标中特定语言源文件的引用目录。例如：

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

  这指定了\ ``-fno-exceptions``\ 编译选项的使用、``COMPILING_CXX``\ 编译定义以及\ ``cxx_headers``\ 的C++引用目录（省略了编译器标识检查）。它还为CUDA指定了\ ``COMPILING_CUDA``\ 编译定义。

  注意，使用\ :ref:`Visual Studio Generators`\ 和\ :generator:`Xcode`\ 时，没有办法表示目标级的编译定义，也没有办法分别设置\ ``C``\ 和\ ``CXX``\ 语言的引用目录。另外，使用\ :ref:`Visual Studio Generators`\ 时，没有办法分别表示\ ``C``\ 语言和\ ``CXX``\ 语言目标范围的标志。在这些生成器下，如果有任意一个C++源文件，C和C++源的表达式将使用\ ``CXX``\ 来求值，否则使用\ ``C``\ 来求值。一个解决办法是为每个源文件语言创建单独的库：

  .. code-block:: cmake

    add_library(myapp_c foo.c)
    add_library(myapp_cxx bar.cpp)
    target_compile_options(myapp_cxx PUBLIC -fno-exceptions)
    add_executable(myapp main.cpp)
    target_link_libraries(myapp myapp_c myapp_cxx)

.. _`Boolean LINK_LANGUAGE Generator Expression`:

.. genex:: $<LINK_LANG_AND_ID:language,compiler_ids>

  .. versionadded:: 3.18

  如果用于链接步骤的语言与\ ``language``\ 匹配，并且CMake的编译器id与\ ``compiler_ids``\ 中的任何一个条目匹配，则为\ ``1``，否则为\ ``0``。这个表达式是 \ ``$<LINK_LANGUAGE:language>``\ 和\ ``$<LANG_COMPILER_ID:compiler_ids>``\ 组合的缩写形式。这个表达式可以用来指定特定语言的链接库、链接选项、链接目录和链接依赖关系，以及目标中的链接器组合。例如：

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

  这指定了基于编译器标识和链接语言的不同链接库的使用。当\ ``Clang``\ 或\ ``AppleClang``\ 是\ ``CXX``\ 链接器时，这个例子将目标\ ``libCXX_Clang``\ 作为链接依赖，当\ ``Intel``\ 是\ ``CXX``\ 链接器时，目标\ ``libCXX_Intel``\ 作为链接依赖。同样地，当\ ``C``\ 连接器是\ ``Clang``\ 或\ ``AppleClang``\ 时，目标\ ``libC_Clang``\ 将被添加为链接依赖项，而当\ ``Intel``\ 是\ ``C``\ 连接器时，目标\ ``libC_Intel``\ 将被添加为链接依赖项。

  请参阅与\ ``$<LINK_LANGUAGE:language>`` :ref:`有关的注释 <Constraints LINK_LANGUAGE Generator Expression>`，了解关于生成器表达式使用的约束。

.. genex:: $<LINK_LANGUAGE:languages>

  .. versionadded:: 3.18

  当链接步骤使用的语言匹配任何\ ``languages``\ 中的条目时，为\ ``1``，否则为\ ``0``。这个表达式可以用来指定目标中特定语言的链接库、链接选项、链接目录和链接依赖关系。例如：

  .. code-block:: cmake

    add_library(api_C ...)
    add_library(api_CXX ...)
    add_library(api INTERFACE)
    target_link_options(api INTERFACE $<$<LINK_LANGUAGE:C>:-opt_c>
                                        $<$<LINK_LANGUAGE:CXX>:-opt_cxx>)
    target_link_libraries(api INTERFACE $<$<LINK_LANGUAGE:C>:api_C>
                                        $<$<LINK_LANGUAGE:CXX>:api_CXX>)

    add_executable(myapp1 main.c)
    target_link_options(myapp1 PRIVATE api)

    add_executable(myapp2 main.cpp)
    target_link_options(myapp2 PRIVATE api)

  这指定使用 ``api`` 目标来链接 ``myapp1`` 和\ ``myapp2`` 目标。在实践中，``myapp1``\ 将链接\ ``api_C``\ 目标和\ ``-opt_c``\ 选项，因为它将使用\ ``C``\ 作为链接语言。而\ ``myapp2``\ 将链接\ ``api_CXX``\ 和\ ``-opt_cxx``\ 选项，因为\ ``CXX``\ 将是链接语言。

  .. _`Constraints LINK_LANGUAGE Generator Expression`:

  .. note::

    要确定一个目标的链接语言，需要通过传递的方式收集所有将被链接到该目标的目标。因此，对于链接库属性，将进行双重求值。在第一次求值时，``$<LINK_LANGUAGE:..>``\ 表达式总是返回\ ``0``。在第一次传递之后计算的链接语言将用于第二次传递。为了避免不一致，要求第二次传递不更改链接语言。此外，为了避免意外的副作用，需要将完整的实体指定为\ ``$<LINK_LANGUAGE:..>``\ 表达式。例如：

    .. code-block:: cmake

      add_library(lib STATIC file.cxx)
      add_library(libother STATIC file.c)

      # bad usage
      add_executable(myapp1 main.c)
      target_link_libraries(myapp1 PRIVATE lib$<$<LINK_LANGUAGE:C>:other>)

      # correct usage
      add_executable(myapp2 main.c)
      target_link_libraries(myapp2 PRIVATE $<$<LINK_LANGUAGE:C>:libother>)

    在本例中，对于\ ``myapp1``，第一次传递将意外地确定链接语言是\ ``CXX``，因为生成器表达式的求值将是一个空字符串，所以\ ``myapp1``\ 将依赖于\ ``lib``\ 目标，即\ ``C++``。相反，对于\ ``myapp2``，第一次求值时将\ ``C``\ 作为链接语言，所以第二次求值时将正确地添加\ ``libother``\ 目标作为链接依赖。

.. genex:: $<DEVICE_LINK:list>

  .. versionadded:: 3.18

  如果是设备链接步骤，则返回列表，否则为空列表。设备链接步骤由\ :prop_tgt:`CUDA_SEPARABLE_COMPILATION`\ 和\ :prop_tgt:`CUDA_RESOLVE_DEVICE_SYMBOLS`\ 属性和策略\ :policy:`CMP0105`\ 控制。此表达式只能用于指定链接选项。

.. genex:: $<HOST_LINK:list>

  .. versionadded:: 3.18

  如果是普通的链接步骤，则返回列表，否则为空列表。当还涉及到设备链接步骤时，这个表达式相当有用（参考\ ``$<DEVICE_LINK:list>``\ 生成器表达式）。此表达式只能用于指定链接选项。

字符串值生成器表达式
===================================

这些表达式扩展为某个字符串。例如，

.. code-block:: cmake

  include_directories(/usr/include/$<CXX_COMPILER_ID>/)

扩展为\ ``/usr/include/GNU/``\ 或\ ``/usr/include/Clang/``\ 等等，这取决于编译器标识符。

字符串值表达式也可以与其他表达式组合。下面是一个条件表达式中的布尔表达式使用字符串值表达式的例子：

.. code-block:: cmake

  $<$<VERSION_LESS:$<CXX_COMPILER_VERSION>,4.2.0>:OLD_COMPILER>

如果\ :variable:`CMAKE_CXX_COMPILER_VERSION <CMAKE_<LANG>_COMPILER_VERSION>`\ 小于4.2.0，则扩展为\ ``OLD_COMPILER``。

这里有两个嵌套的字符串值表达式：

.. code-block:: cmake

  -I$<JOIN:$<TARGET_PROPERTY:INCLUDE_DIRECTORIES>, -I>

生成包含\ :prop_tgt:`INCLUDE_DIRECTORIES`\ 目标属性项的字符串，每个项前面加\ ``-I``。

展开前面的例子，如果首先要检查\ ``INCLUDE_DIRECTORIES``\ 属性是否为非空，那么建议引入一个helper变量来保持代码的可读性：

.. code-block:: cmake

  set(prop "$<TARGET_PROPERTY:INCLUDE_DIRECTORIES>") # helper variable
  $<$<BOOL:${prop}>:-I$<JOIN:${prop}, -I>>

以下字符串值生成器表达式可供使用：

转义字符
------------------

转义字符的特殊含义字符串字面量：

.. genex:: $<ANGLE-R>

  ``>``\ 字面量。用于比较包含\ ``>``\ 的字符串。

.. genex:: $<COMMA>

  ``,``\ 字面量。用于比较包含\ ``,``\ 的字符串。

.. genex:: $<SEMICOLON>

  ``;``\ 字面量。用于防止使用\ ``;``\ 的参数展开列表。

.. _`Conditional Generator Expressions`:

条件表达式
-----------------------

条件生成器表达式依赖于一个必须为\ ``0``\ 或\ ``1``\ 的布尔条件。

.. genex:: $<condition:true_string>

  如果\ ``condition``\ 为\ ``1``，则计算为\ ``true_string``。否则计算结果为空字符串。

.. genex:: $<IF:condition,true_string,false_string>

  .. versionadded:: 3.8

  如果\ ``condition``\ 为\ ``1``，则计算为\ ``true_string``。否则计算结果为\ ``false_string``。

通常，``condition``\ 是\ :ref:`布尔生成器表达式
<Boolean Generator Expressions>`。例如，

.. code-block:: cmake

  $<$<CONFIG:Debug>:DEBUG_MODE>

当使用\ ``Debug``\ 配置时展开为\ ``DEBUG_MODE``，否则展开为空字符串。

.. _`String Transforming Generator Expressions`:

字符串转换
----------------------

.. genex:: $<JOIN:list,string>

  用\ ``string``\ 内容连接列表。

.. genex:: $<REMOVE_DUPLICATES:list>

  .. versionadded:: 3.15

  删除给定\ ``list``\ 中的重复项。

.. genex:: $<FILTER:list,INCLUDE|EXCLUDE,regex>

  .. versionadded:: 3.15

  从\ ``list``\ 中包含或删除匹配正则表达式\ ``regex``\ 的项。

.. genex:: $<LOWER_CASE:string>

  ``string``\ 内容转换成小写字母。

.. genex:: $<UPPER_CASE:string>

  ``string``\ 内容转换成大写字母。

.. genex:: $<GENEX_EVAL:expr>

  .. versionadded:: 3.12

  ``expr``\ 的内容在当前上下文中作为生成器表达式计算。这允许使用生成器表达式中的生成器表达式计算结果本身。

.. genex:: $<TARGET_GENEX_EVAL:tgt,expr>

  .. versionadded:: 3.12

  ``expr``\ 的内容在\ ``tgt``\ 目标上下文中作为生成器表达式计算。这允许使用本身包含生成器表达式的自定义目标属性。

  当你想要管理支持生成器表达式的自定义属性时，具有计算生成器表达式的能力非常有用。例如：

  .. code-block:: cmake

    add_library(foo ...)

    set_property(TARGET foo PROPERTY
      CUSTOM_KEYS $<$<CONFIG:DEBUG>:FOO_EXTRA_THINGS>
    )

    add_custom_target(printFooKeys
      COMMAND ${CMAKE_COMMAND} -E echo $<TARGET_PROPERTY:foo,CUSTOM_KEYS>
    )

  这个\ ``printFooKeys``\ 自定义命令的简单实现是错误的，因为没有计算\ ``CUSTOM_KEYS``\ 目标属性，内容将按原来的方式传递（例如\ ``$<$<CONFIG:DEBUG>:FOO_EXTRA_THINGS>``）。

  为了得到预期的结果（例如，如果配置是\ ``Debug``，则得到\ ``FOO_EXTRA_THINGS``），需要计算\ ``$<TARGET_PROPERTY:foo,CUSTOM_KEYS>``\ 的输出：

  .. code-block:: cmake

    add_custom_target(printFooKeys
      COMMAND ${CMAKE_COMMAND} -E
        echo $<TARGET_GENEX_EVAL:foo,$<TARGET_PROPERTY:foo,CUSTOM_KEYS>>
    )

变量查询
----------------

.. genex:: $<CONFIG>

  配置名称。

.. genex:: $<CONFIGURATION>

  配置名称。CMake 3.0后弃用。用\ ``CONFIG``\ 替代。

.. genex:: $<PLATFORM_ID>

  当前系统的CMake平台标识。参考\ :variable:`CMAKE_SYSTEM_NAME`\ 变量。

.. genex:: $<C_COMPILER_ID>

  当前C编译器的CMake编译器标识。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<CXX_COMPILER_ID>

  当前CXX编译器的CMake编译器标识。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<CUDA_COMPILER_ID>

  当前CUDA编译器的CMake编译器标识。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<OBJC_COMPILER_ID>

  .. versionadded:: 3.16

  当前OBJC编译器的CMake编译器标识。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<OBJCXX_COMPILER_ID>

  .. versionadded:: 3.16

  当前OBJCXX编译器的CMake编译器标识。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<Fortran_COMPILER_ID>

  当前Fortran编译器的CMake编译器标识。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<HIP_COMPILER_ID>

  当前HIP编译器的CMake编译器标识。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<ISPC_COMPILER_ID>

  .. versionadded:: 3.19

  当前ISPC编译器的CMake编译器标识。参考\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量。

.. genex:: $<C_COMPILER_VERSION>

  当前C编译器版本。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<CXX_COMPILER_VERSION>

  当前CXX编译器版本。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<CUDA_COMPILER_VERSION>

  当前CUDA编译器版本。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<OBJC_COMPILER_VERSION>

  .. versionadded:: 3.16

  当前OBJC编译器版本。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<OBJCXX_COMPILER_VERSION>

  .. versionadded:: 3.16

  当前OBJCXX编译器版本。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<Fortran_COMPILER_VERSION>

  当前Fortran编译器版本。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<HIP_COMPILER_VERSION>

  当前HIP编译器版本。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<ISPC_COMPILER_VERSION>

  .. versionadded:: 3.19

  当前ISPC编译器版本。参考\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量。

.. genex:: $<COMPILE_LANGUAGE>

  .. versionadded:: 3.3

  计算编译选项时源文件的编译语言。关于生成器表达式的可移植性，请参阅\ :ref:`相关的布尔表达式 <Boolean COMPILE_LANGUAGE Generator Expression>`\ ``$<COMPILE_LANGUAGE:language>``。

.. genex:: $<LINK_LANGUAGE>

  .. versionadded:: 3.18

  计算链接选项时目标的链接语言。关于生成器表达式的可移植性，请参阅\ :ref:`相关的布尔表达式 <Boolean LINK_LANGUAGE Generator Expression>`\ ``$<LINK_LANGUAGE:language>``。

  .. note::

    链接库属性不支持此生成器表达式，以避免由于这些属性的双重求值而产生的副作用。

.. _`Target-Dependent Queries`:

依赖目标的查询
------------------------

这些查询引用目标\ ``tgt``。这可以是任何运行时工件，即：

* :command:`add_executable`\ 创建的可执行目标
* 由\ :command:`add_library`\ 创建的共享库目标（``.so``、``.dll``\ 但不包括它们的\ ``.lib``\ 库文件）
* 由\ :command:`add_library`\ 创建的静态库目标

在下文中，“\ ``tgt``\ 文件名”指的是\ ``tgt``\ 二进制文件的名称。这必须与“目标名称”区别开来，后者只是字符串\ ``tgt``。

.. genex:: $<TARGET_NAME_IF_EXISTS:tgt>

  .. versionadded:: 3.12

  如果目标存在，则目标名称为\ ``tgt``，否则为空字符串。

  请注意，``tgt``\ 不是作为目标的依赖项添加的，该表达式是在该目标上求值的。

.. genex:: $<TARGET_FILE:tgt>

  ``tgt``\ 二进制文件的完整路径。

.. genex:: $<TARGET_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.15

  ``tgt``\ 的基本名称，即不带前缀和后缀的\ ``$<TARGET_FILE_NAME:tgt>``。例如，如果\ ``tgt``\ 文件名是\ ``libbase.so``，则它的基本名称是\ ``base``。

  参考\ :prop_tgt:`OUTPUT_NAME`、:prop_tgt:`ARCHIVE_OUTPUT_NAME`、:prop_tgt:`LIBRARY_OUTPUT_NAME`\ 和\ :prop_tgt:`RUNTIME_OUTPUT_NAME`\ 目标属性和它们的特定配置变量
  \ :prop_tgt:`OUTPUT_NAME_<CONFIG>`、:prop_tgt:`ARCHIVE_OUTPUT_NAME_<CONFIG>`、:prop_tgt:`LIBRARY_OUTPUT_NAME_<CONFIG>`\
  和\ :prop_tgt:`RUNTIME_OUTPUT_NAME_<CONFIG>`。

  也可以考虑\ :prop_tgt:`<CONFIG>_POSTFIX`\ 和\ :prop_tgt:`DEBUG_POSTFIX`\ 目标属性。

  请注意，``tgt``\ 不是作为目标的依赖项添加的，该表达式是在该目标上求值的。

.. genex:: $<TARGET_FILE_PREFIX:tgt>

  .. versionadded:: 3.15

  ``tgt``\ 文件名的前缀（如\ ``lib``）。

  请参见\ :prop_tgt:`PREFIX`\ 目标属性。

  请注意，``tgt``\ 不是作为目标的依赖项添加的，该表达式是在该目标上求值的。

.. genex:: $<TARGET_FILE_SUFFIX:tgt>

  .. versionadded:: 3.15

  ``tgt``\ 文件名的后缀（扩展名如\ ``.so``\ 或\ ``.exe``）。

  参考\ :prop_tgt:`SUFFIX`\ 目标属性。

  请注意，``tgt``\ 不是作为目标的依赖项添加的，该表达式是在该目标上求值的。

.. genex:: $<TARGET_FILE_NAME:tgt>

  ``tgt``\ 文件名。

  注意，``tgt``\ 不是作为目标的依赖项添加的，这个表达式是在目标上计算的（请参阅策略\ :policy:`CMP0112`）。

.. genex:: $<TARGET_FILE_DIR:tgt>

  ``tgt``\ 二进制文件所在的目录。

  注意，``tgt``\ 不是作为目标的依赖项添加的，这个表达式是在目标上计算的（请参考策略\ :policy:`CMP0112`）。

.. genex:: $<TARGET_LINKER_FILE:tgt>

  链接到\ ``tgt``\ 目标时使用的文件。这通常是\ ``tgt``\ 表示的库（``.a``、``.lib``、``.so``），但对于DLL平台上的共享库，它会是与DLL关联的\ ``.lib``\ 导入库。

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

  Full path to the bundle directory (``my.app``, ``my.framework``, or
  ``my.bundle``) where ``tgt`` is the name of a target.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on (see policy :policy:`CMP0112`).

.. genex:: $<TARGET_BUNDLE_CONTENT_DIR:tgt>

  .. versionadded:: 3.9

  Full path to the bundle content directory where ``tgt`` is the name of a
  target. For the macOS SDK it leads to ``my.app/Contents``, ``my.framework``,
  or ``my.bundle/Contents``. For all other SDKs (e.g. iOS) it leads to
  ``my.app``, ``my.framework``, or ``my.bundle`` due to the flat bundle
  structure.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on (see policy :policy:`CMP0112`).

.. genex:: $<TARGET_PROPERTY:tgt,prop>

  Value of the property ``prop`` on the target ``tgt``.

  Note that ``tgt`` is not added as a dependency of the target this
  expression is evaluated on.

.. genex:: $<TARGET_PROPERTY:prop>

  Value of the property ``prop`` on the target for which the expression
  is being evaluated. Note that for generator expressions in
  :ref:`Target Usage Requirements` this is the consuming target rather
  than the target specifying the requirement.

.. genex:: $<TARGET_RUNTIME_DLLS:tgt>

  .. versionadded:: 3.21

  List of DLLs that the target depends on at runtime. This is determined by
  the locations of all the ``SHARED`` and ``MODULE`` targets in the target's
  transitive dependencies. Using this generator expression on targets other
  than executables, ``SHARED`` libraries, and ``MODULE`` libraries is an error.
  On non-DLL platforms, it evaluates to an empty string.

  This generator expression can be used to copy all of the DLLs that a target
  depends on into its output directory in a ``POST_BUILD`` custom command. For
  example:

  .. code-block:: cmake

    find_package(foo CONFIG REQUIRED) # package generated by install(EXPORT)

    add_executable(exe main.c)
    target_link_libraries(exe PRIVATE foo::foo foo::bar)
    add_custom_command(TARGET exe POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:exe> $<TARGET_FILE_DIR:exe>
      COMMAND_EXPAND_LISTS
      )

  .. note::

    :ref:`Imported Targets` are supported only if they know the location
    of their ``.dll`` files.  An imported ``SHARED`` or ``MODULE`` library
    must have :prop_tgt:`IMPORTED_LOCATION` set to its ``.dll`` file.  See
    the :ref:`add_library imported libraries <add_library imported libraries>`
    section for details.  Many :ref:`Find Modules` produce imported targets
    with the ``UNKNOWN`` type and therefore will be ignored.

.. genex:: $<INSTALL_PREFIX>

  Content of the install prefix when the target is exported via
  :command:`install(EXPORT)`, or when evaluated in the
  :prop_tgt:`INSTALL_NAME_DIR` property or the ``INSTALL_NAME_DIR`` argument of
  :command:`install(RUNTIME_DEPENDENCY_SET)`, and empty otherwise.

与输出相关的表达式
--------------------------

.. genex:: $<TARGET_NAME:...>

  Marks ``...`` as being the name of a target.  This is required if exporting
  targets to multiple dependent export sets.  The ``...`` must be a literal
  name of a target- it may not contain generator expressions.

.. genex:: $<LINK_ONLY:...>

  .. versionadded:: 3.1

  Content of ``...`` except when evaluated in a link interface while
  propagating :ref:`Target Usage Requirements`, in which case it is the
  empty string.
  Intended for use only in an :prop_tgt:`INTERFACE_LINK_LIBRARIES` target
  property, perhaps via the :command:`target_link_libraries` command,
  to specify private link dependencies without other usage requirements.

.. genex:: $<INSTALL_INTERFACE:...>

  Content of ``...`` when the property is exported using :command:`install(EXPORT)`,
  and empty otherwise.

.. genex:: $<BUILD_INTERFACE:...>

  Content of ``...`` when the property is exported using :command:`export`, or
  when the target is used by another target in the same buildsystem. Expands to
  the empty string otherwise.

.. genex:: $<MAKE_C_IDENTIFIER:...>

  Content of ``...`` converted to a C identifier.  The conversion follows the
  same behavior as :command:`string(MAKE_C_IDENTIFIER)`.

.. genex:: $<TARGET_OBJECTS:objLib>

  .. versionadded:: 3.1

  List of objects resulting from build of ``objLib``.

.. genex:: $<SHELL_PATH:...>

  .. versionadded:: 3.4

  Content of ``...`` converted to shell path style. For example, slashes are
  converted to backslashes in Windows shells and drive letters are converted
  to posix paths in MSYS shells. The ``...`` must be an absolute path.

  .. versionadded:: 3.14
    The ``...`` may be a :ref:`semicolon-separated list <CMake Language Lists>`
    of paths, in which case each path is converted individually and a result
    list is generated using the shell path separator (``:`` on POSIX and
    ``;`` on Windows).  Be sure to enclose the argument containing this genex
    in double quotes in CMake source code so that ``;`` does not split arguments.

.. genex:: $<OUTPUT_CONFIG:...>

  .. versionadded:: 3.20

  Only valid in :command:`add_custom_command` and :command:`add_custom_target`
  as the outer-most generator expression in an argument.
  With the :generator:`Ninja Multi-Config` generator, generator expressions
  in ``...`` are evaluated using the custom command's "output config".
  With other generators, the content of ``...`` is evaluated normally.

.. genex:: $<COMMAND_CONFIG:...>

  .. versionadded:: 3.20

  Only valid in :command:`add_custom_command` and :command:`add_custom_target`
  as the outer-most generator expression in an argument.
  With the :generator:`Ninja Multi-Config` generator, generator expressions
  in ``...`` are evaluated using the custom command's "command config".
  With other generators, the content of ``...`` is evaluated normally.

调试
=========

Since generator expressions are evaluated during generation of the buildsystem,
and not during processing of ``CMakeLists.txt`` files, it is not possible to
inspect their result with the :command:`message()` command.

One possible way to generate debug messages is to add a custom target,

.. code-block:: cmake

  add_custom_target(genexdebug COMMAND ${CMAKE_COMMAND} -E echo "$<...>")

The shell command ``make genexdebug`` (invoked after execution of ``cmake``)
would then print the result of ``$<...>``.

Another way is to write debug messages to a file:

.. code-block:: cmake

  file(GENERATE OUTPUT filename CONTENT "$<...>")
