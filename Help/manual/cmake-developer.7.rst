.. cmake-manual-description: CMake Developer Reference

cmake-developer(7)
******************

.. only:: html

   .. contents::

引言
============

本手册旨在供使用\ :manual:`cmake-language(7)`\ 代码的开发人员参考，无论是编写自己的模块，\
自己的构建系统，还是CMake本身。

请参见\ https://cmake.org/get-involved/\ 参与CMake上游的开发。它包括到贡献说明的链接，\
而贡献说明又链接到CMake自身的开发指南。

访问Windows注册表
==========================

CMake提供了一些工具来访问\ ``Windows``\ 平台上的注册表。

查询Windows注册表
----------------------

.. versionadded:: 3.24

:command:`cmake_host_system_information`\ 命令提供了在本地计算机上查询注册表的可能性。\
查看\ :ref:`cmake_host_system(QUERY_WINDOWS_REGISTRY) <Query Windows registry>`\
获取更多信息。

.. _`Find Using Windows Registry`:

使用Windows注册表查找
---------------------------

.. versionchanged:: 3.24

:command:`find_file`、:command:`find_library`、:command:`find_path`、\
:command:`find_program`\ 和\ :command:`find_package`\ 命令的\ ``HINTS``\ 和\
``PATHS``\ 选项提供了在\ ``Windows``\ 平台上查询注册表的可能性。

注册表查询的正式语法，使用带有常规扩展的\
`BNF <https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form>`_\ 表示法指定，如下\
所示：

.. raw:: latex

   \begin{small}

.. productionlist::
  registry_query: '[' `sep_definition`? `root_key`
                :     ((`key_separator` `sub_key`)? (`value_separator` `value_name`_)?)? ']'
  sep_definition: '{' `value_separator` '}'
  root_key: 'HKLM' | 'HKEY_LOCAL_MACHINE' | 'HKCU' | 'HKEY_CURRENT_USER' |
          : 'HKCR' | 'HKEY_CLASSES_ROOT' | 'HKCC' | 'HKEY_CURRENT_CONFIG' |
          : 'HKU' | 'HKEY_USERS'
  sub_key: `element` (`key_separator` `element`)*
  key_separator: '/' | '\\'
  value_separator: `element` | ';'
  value_name: `element` | '(default)'
  element: `character`\+
  character: <any character except `key_separator` and `value_separator`>

.. raw:: latex

   \end{small}

:token:`sep_definition`\ 可选项提供了指定用于分隔\ :token:`sub_key`\ 和\
:token:`value_name`\ 项的字符串的可能性。如果未指定，则使用\ ``;``\ 字符。可以将多个\
:token:`registry_query`\ 项指定为路径的一部分。

.. code-block:: cmake

  # example using default separator
  find_file(... PATHS "/root/[HKLM/Stuff;InstallDir]/lib[HKLM\\\\Stuff;Architecture]")

  # example using different specified separators
  find_library(... HINTS "/root/[{|}HKCU/Stuff|InstallDir]/lib[{@@}HKCU\\\\Stuff@@Architecture]")

如果\ :token:`value_name`\ 项未指定或有特殊名称\ ``(default)``，则返回默认值的内容\
（如果有）。:token:`value_name`\ 支持的类型有：

* ``REG_SZ``。
* ``REG_EXPAND_SZ``。返回被扩展的数据。
* ``REG_DWORD``。
* ``REG_QWORD``。

当注册表查询失败时（通常是因为键不存在或不支持数据类型），字符串\ ``/REGISTRY-NOTFOUND``\
将被替换为\ ``[]``\ 查询表达式。

.. _`Find Modules`:

查找模块
============

“查找模块”是一个\ ``Find<PackageName>.cmake``\ 文件，在调用时由\
:command:`find_package`\ 命令加载。

查找模块的主要任务是确定包是否可用，设置\ ``<PackageName>_FOUND``\ 变量以反映这一点，并提\
供使用包所需的任何变量、宏和导入目标。在上游库没有提供\
:ref:`配置文件包 <Config File Packages>`\ 的情况下，查找模块很有用。

传统的方法是对所有东西都使用变量，包括库和可执行文件：请参阅下面的\ `标准变量名`_\ 部分。\
这是CMake提供的大多数现有查找模块所做的。

更现代的方法是通过提供\ :ref:`导入目标 <Imported targets>`，尽可能地像\
:ref:`配置文件包 <Config File Packages>`\ 文件那样运行。这样可以将\
:ref:`usage requirements <Target Usage Requirements>`\ 给消费者。

在任何一种情况下（甚至在同时提供变量和导入目标时），查找模块都应该提供与具有相同名称的旧版\
本的向后兼容性。

FindFoo.cmake模块通常通过以下命令加载：\ ::

  find_package(Foo [major[.minor[.patch[.tweak]]]]
               [EXACT] [QUIET] [REQUIRED]
               [[COMPONENTS] [components...]]
               [OPTIONAL_COMPONENTS components...]
               [NO_POLICY_SCOPE])

有关查找模块设置了哪些变量的详细信息，请参阅\ :command:`find_package`\ 文档。其中大多数\
都是通过使用\ :module:`FindPackageHandleStandardArgs`\ 来处理的。

简单地说，模块应该只定位与请求版本兼容的包的版本，正如变量族\ ``Foo_FIND_VERSION``\ 所描\
述的那样。如果\ ``Foo_FIND_QUIETLY``\ 设置为true，它应该避免打印消息，包括没有找到包的任\
何抱怨。如果\ ``Foo_FIND_REQUIRED``\ 被设置为true，如果找不到包，模块应该发出\
``FATAL_ERROR``。如果两者都设置为true，则如果它找不到包，则应该打印一条非致命消息。

找到多个半独立部件的包（如库包）应该搜索\ ``Foo_FIND_COMPONENTS``\ 中列出的组件，如果设\
置为true，并且只有在每个搜索组件\ ``<c>``\ 未找到时才将\ ``Foo_FOUND``\ 设置为true, \
``Foo_FIND_REQUIRED_<c>``\ 未设置为true。\ ``find_package_handle_standard_args()``\
的\ ``HANDLE_COMPONENTS``\ 参数可用于实现此功能。

如果没有设置\ ``Foo_FIND_COMPONENTS``，那么搜索哪些模块和需要哪些模块取决于查找模块，但应\
该标明下来。

对于内部实现，以下划线开头的变量仅供临时使用是一个普遍接受的约定。


.. _`CMake Developer Standard Variable Names`:

标准变量名
-----------------------

对于采用设置变量方法的\ ``FindXxx.cmake``\ 模块（代替或添加创建导入目标），应该使用以下变\
量名来保持查找模块之间的一致性。请注意，所有变量都以\ ``Xxx_``\ 开头，除非另有说明，否则必\
须与\ ``FindXxx.cmake``\ 文件的名称完全匹配，包括大写/小写。变量名上的前缀确保它们不会与\
其他查找模块的变量冲突。对于查找模块定义的任何宏、函数和导入目标，也应该遵循相同的模式。

``Xxx_INCLUDE_DIRS``
  最后一组包含目录列在一个变量中，供客户端代码使用。这不应该是一个缓存条目（注意，这也意味着\
  这个变量不应该用作\ :command:`find_path`\ 命令的结果变量——请参阅下面的\
  ``Xxx_INCLUDE_DIR``）。

``Xxx_LIBRARIES``
  与模块一起使用的库。这些可能是CMake目标，库二进制文件的完整绝对路径或链接器必须在其搜索路\
  径中找到的库的名称。这不应该是一个缓存条目（注意，这也意味着这个变量不应该用作\
  :command:`find_library`\ 命令的结果变量——请参阅下面的\ ``Xxx_LIBRARY``）。

``Xxx_DEFINITIONS``
  编译使用该模块的代码时要使用的编译定义。这真的不应该包含像\ ``-DHAS_JPEG``\ 这样的选项，\
  客户端源代码文件使用这些选项来决定是否\ ``#include <jpeg.h>``

``Xxx_EXECUTABLE``
  可执行文件的完整绝对路径。在这种情况下，\ ``Xxx``\ 可能不是模块的名称，它可能是工具的名称\
  （通常转换为全大写），假设工具具有如此知名的名称，因此不太可能存在具有相同名称的其他工具。\
  将其用作\ :command:`find_program`\ 命令的结果变量是合适的。

``Xxx_YYY_EXECUTABLE``
  类似于\ ``Xxx_EXECUTABLE``，除了这里\ ``Xxx``\ 总是模块名，\ ``YYY``\ 是工具名（同样，\
  通常是全大写）。如果工具名称不是非常广为人知，或者有可能与其他工具冲突，则首选此形式。为了\
  更大的一致性，如果模块提供了多个可执行文件，也更喜欢这种形式。

``Xxx_LIBRARY_DIRS``
  可选地，在一个变量中列出供客户端代码使用的库目录的最终集。这不应该是缓存项。

``Xxx_ROOT_DIR``
  在哪里可以找到模块的基目录。

``Xxx_VERSION_VV``
  该表单的变量指定所提供的\ ``Xxx``\ 模块是否为该模块的\ ``VV``\ 版本。对于给定的模块，\
  不应该有多个这种形式的变量设置为true。例如，一个模块\ ``Barry``\ 可能已经发展了很多年，\
  并且经历了许多不同的主要版本。版本3的\ ``Barry``\ 模块可能会将变量\ ``Barry_VERSION_3``\
  设置为true，而旧版本的模块可能会将\ ``Barry_VERSION_2``\ 设置为true。\
  ``Barry_VERSION_3``\ 和\ ``Barry_VERSION_2``\ 都设置为true将是错误的。

``Xxx_WRAP_YY``
  当这种形式的变量被设置为false时，它表示不应该使用相关的包装命令。包装命令取决于模块，它可\
  能由模块名暗示，也可能由变量的\ ``YY``\ 部分指定。

``Xxx_Yy_FOUND``
  对于这种形式的变量，\ ``Yy``\ 是模块的组件名。它应该完全匹配可能传递给模块的\
  :command:`find_package`\ 命令的有效组件名之一。如果将这种形式的变量设置为false，则表示\
  没有找到模块\ ``Xxx``\ 的\ ``Yy``\ 组件或不可用。此表单的变量通常用于可选组件，以便调用\
  方可以检查可选组件是否可用。

``Xxx_FOUND``
  当\ :command:`find_package`\ 命令返回给调用者时，如果认为模块已被成功找到，则该变量将\
  被设置为true。

``Xxx_NOT_FOUND_MESSAGE``
  在将\ ``Xxx_FOUND``\ 设置为FALSE的情况下，应该由config-files设置。包含的消息将由\
  :command:`find_package`\ 命令和\ :command:`find_package_handle_standard_args`\
  命令打印，以通知用户有关问题。使用此方法而不是直接调用\ :command:`message`\ 来报告无法\
  找到模块或包的原因。

``Xxx_RUNTIME_LIBRARY_DIRS``
  可选地，运行时库搜索路径，供运行链接到共享库的可执行文件时使用。用户代码应该使用该列表来创\
  建windows上的\ ``PATH``\ 或UNIX上的\ ``LD_LIBRARY_PATH``。这不应该是缓存项。

``Xxx_VERSION``
  找到的包的完整版本字符串，如果有的话。注意，许多现有模块提供的是\ ``Xxx_VERSION_STRING``。

``Xxx_VERSION_MAJOR``
  找到的包的主要版本，如果有的话。

``Xxx_VERSION_MINOR``
  找到的包的次要版本，如果有的话。

``Xxx_VERSION_PATCH``
  找到的包的补丁版本，如果有的话。

以下名称通常不应该在\ ``CMakeLists.txt``\ 文件中使用。它们用于查找模块指定和缓存特定文件或\
目录的位置。用户通常能够设置和编辑这些变量来控制查找模块的行为（比如手动输入库的路径）:

``Xxx_LIBRARY``
  库的路径。仅当模块提供单个库时才使用此表单。将其用作\ :command:`find_library`\ 命令中\
  的结果变量是合适的。

``Xxx_Yy_LIBRARY``
  模块\ ``Xxx``\ 提供的库\ ``Yy``\ 的路径。当模块提供多个库或其他模块也可能提供相同名称的\
  库时，使用此表单。将这种形式用作\ :command:`find_library`\ 命令中的结果变量也是合适的。

``Xxx_INCLUDE_DIR``
  当模块只提供一个库时，该变量可用于指定在何处查找使用该库的头文件（或者更准确地说，是该库的\
  消费者应该添加到其头文件搜索路径中的路径）。将其用作\ :command:`find_path`\ 命令中的结\
  果变量是合适的。

``Xxx_Yy_INCLUDE_DIR``
  如果模块提供多个库，或者其他模块也可能提供同名库，则建议使用此表单指定在何处查找使用模块提\
  供的库\ ``Yy``\ 的头文件。同样，将它用作\ :command:`find_path`\ 命令中的结果变量是合\
  适的。

为了防止用户被需要配置的设置弄得不知所措，尽量在缓存中保留尽可能多的选项，至少留下一个选项，\
可用于禁用模块的使用，或定位未找到的库（例如\ ``Xxx_ROOT_DIR``）。出于同样的原因，将大多数\
缓存选项标记为高级。对于同时提供调试和发布二进制文件的包，通常使用\ ``_LIBRARY_<CONFIG>``\
后缀创建缓存变量，例如\ ``Foo_LIBRARY_RELEASE``\ 和\ ``Foo_LIBRARY_DEBUG``。\
:module:`SelectLibraryConfigurations`\ 模块对这种情况很有帮助。

虽然这些都是标准的变量名，但你应该为实际使用的任何旧名称提供向后兼容性。确保将它们注释为已弃\
用，这样就不会有人开始使用它们。

查找模块示例
--------------------

我们将描述如何为库\ ``Foo``\ 创建一个简单的查找模块。

模块的顶部应该以许可声明开始，然后是空白行，然后是\ :ref:`Bracket Comment`。注释应该以\
``.rst:``\ 开头，以表明其其余内容是restructuredtext格式的文档。例如：

::

  # Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
  # file Copyright.txt or https://cmake.org/licensing for details.

  #[=======================================================================[.rst:
  FindFoo
  -------

  Finds the Foo library.

  Imported Targets
  ^^^^^^^^^^^^^^^^

  This module provides the following imported targets, if found:

  ``Foo::Foo``
    The Foo library

  Result Variables
  ^^^^^^^^^^^^^^^^

  This will define the following variables:

  ``Foo_FOUND``
    True if the system has the Foo library.
  ``Foo_VERSION``
    The version of the Foo library which was found.
  ``Foo_INCLUDE_DIRS``
    Include directories needed to use Foo.
  ``Foo_LIBRARIES``
    Libraries needed to link to Foo.

  Cache Variables
  ^^^^^^^^^^^^^^^

  The following cache variables may also be set:

  ``Foo_INCLUDE_DIR``
    The directory containing ``foo.h``.
  ``Foo_LIBRARY``
    The path to the Foo library.

  #]=======================================================================]

模块文档包括：

* 带下划线的标题，指定模块名称。

* 对模块查找内容的简单描述。某些包可能需要更多的描述。如果模块的用户应该知道一些警告或其他细\
  节，请在这里指定。

* 列出由模块提供的导入目标的部分，如果有的话。

* 列出模块提供的结果变量的部分。

* 可选，列出模块使用的缓存变量的部分，如果有的话。

如果包提供了任何宏或函数，它们应该被列在一个额外的部分中，但是可以通过在定义这些宏或函数的位\
置上方的附加\ ``.rst:``\ 注释块进行记录。

查找模块的实现可以从文档块下面开始。现在需要找到实际的库等等。这里的代码显然会因模块而异\
（毕竟，处理这个问题是查找模块的重点），但是库往往有一个共同的模式。

首先，我们尝试使用\ ``pkg-config``\ 来查找库。请注意，我们不能依赖它，因为它可能不可用，\
但它提供了一个很好的起点。

.. code-block:: cmake

  find_package(PkgConfig)
  pkg_check_modules(PC_Foo QUIET Foo)

这应该定义一些从\ ``PC_Foo_``\ 开始的变量，其中包含来自\ ``Foo.pc``\ 文件的信息。

现在我们需要找到库并包含文件；我们使用\ ``pkg-config``\ 中的信息为CMake提供有关查找位置的\
提示。

.. code-block:: cmake

  find_path(Foo_INCLUDE_DIR
    NAMES foo.h
    PATHS ${PC_Foo_INCLUDE_DIRS}
    PATH_SUFFIXES Foo
  )
  find_library(Foo_LIBRARY
    NAMES foo
    PATHS ${PC_Foo_LIBRARY_DIRS}
  )

或者，如果库有多个配置可用，你可以使用\ :module:`SelectLibraryConfigurations`\ 来自动\
设置\ ``Foo_LIBRARY``\ 变量：

.. code-block:: cmake

  find_library(Foo_LIBRARY_RELEASE
    NAMES foo
    PATHS ${PC_Foo_LIBRARY_DIRS}/Release
  )
  find_library(Foo_LIBRARY_DEBUG
    NAMES foo
    PATHS ${PC_Foo_LIBRARY_DIRS}/Debug
  )

  include(SelectLibraryConfigurations)
  select_library_configurations(Foo)

如果你有一个获得版本的好方法（例如，从头文件），你可以使用该信息来设置\ ``Foo_VERSION``\
（尽管注意，查找模块传统上使用的是\ ``Foo_VERSION_STRING``，所以你可能想要设置两者）。\
否则，尝试使用\ ``pkg-config``\ 中的信息

.. code-block:: cmake

  set(Foo_VERSION ${PC_Foo_VERSION})

现在我们可以使用\ :module:`FindPackageHandleStandardArgs`\ 为我们完成剩下的大部分工作

.. code-block:: cmake

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(Foo
    FOUND_VAR Foo_FOUND
    REQUIRED_VARS
      Foo_LIBRARY
      Foo_INCLUDE_DIR
    VERSION_VAR Foo_VERSION
  )

这将检查\ ``REQUIRED_VARS``\ 是否包含值（不以\ ``-NOTFOUND``\ 结尾），并适当地设置\
``Foo_FOUND``。它还将缓存这些值。如果设置了\ ``Foo_VERSION``，并且所需的版本被传递给\
:command:`find_package`，它将根据\ ``Foo_VERSION``\ 中的版本检查所请求的版本。它还将酌\
情打印消息；注意，如果找到了包，它将打印第一个必需变量的内容，以指示找到包的位置。

此时，我们必须为查找模块的用户提供一种方法来链接到找到的库。如上面的\ `查找模块`_\
部分所述，有两种方法。传统的变量方法是这样的

.. code-block:: cmake

  if(Foo_FOUND)
    set(Foo_LIBRARIES ${Foo_LIBRARY})
    set(Foo_INCLUDE_DIRS ${Foo_INCLUDE_DIR})
    set(Foo_DEFINITIONS ${PC_Foo_CFLAGS_OTHER})
  endif()

如果找到了多个库，则应将所有库都包含在这些变量中（有关更多信息，请参阅\ `标准变量名`_\ 名称部分）。

当提供导入的目标时，这些目标应该有命名空间（因此使用\ ``Foo::``\ 前缀）；CMake将识别传递给\
:command:`target_link_libraries`\ 的名称中包含\ ``::``\ 的值应该是导入的目标（而不仅仅\
是库名），并且如果该目标不存在（参见策略\ :policy:`CMP0028`），则会产生适当的诊断消息。

.. code-block:: cmake

  if(Foo_FOUND AND NOT TARGET Foo::Foo)
    add_library(Foo::Foo UNKNOWN IMPORTED)
    set_target_properties(Foo::Foo PROPERTIES
      IMPORTED_LOCATION "${Foo_LIBRARY}"
      INTERFACE_COMPILE_OPTIONS "${PC_Foo_CFLAGS_OTHER}"
      INTERFACE_INCLUDE_DIRECTORIES "${Foo_INCLUDE_DIR}"
    )
  endif()

关于这一点需要注意的一点是，\ ``INTERFACE_INCLUDE_DIRECTORIES``\ 和类似的属性应该只包\
含关于目标本身的信息，而不包含它的任何依赖项。相反，这些依赖项也应该是目标，并且CMake应该被\
告知它们是这个目标的依赖项。然后，CMake将自动组合所有必要的信息。

使用\ :command:`add_library`\ 命令创建的\ :prop_tgt:`IMPORTED`\ 目标的类型总是可以指\
定为\ ``UNKNOWN``\ 类型。在可能发现静态或共享变量的情况下，这简化了代码，CMake将通过检查文\
件来确定类型。

如果库可用于多个配置，:prop_tgt:`IMPORTED_CONFIGURATIONS`\ 目标属性也应该被填充：

.. code-block:: cmake

  if(Foo_FOUND)
    if (NOT TARGET Foo::Foo)
      add_library(Foo::Foo UNKNOWN IMPORTED)
    endif()
    if (Foo_LIBRARY_RELEASE)
      set_property(TARGET Foo::Foo APPEND PROPERTY
        IMPORTED_CONFIGURATIONS RELEASE
      )
      set_target_properties(Foo::Foo PROPERTIES
        IMPORTED_LOCATION_RELEASE "${Foo_LIBRARY_RELEASE}"
      )
    endif()
    if (Foo_LIBRARY_DEBUG)
      set_property(TARGET Foo::Foo APPEND PROPERTY
        IMPORTED_CONFIGURATIONS DEBUG
      )
      set_target_properties(Foo::Foo PROPERTIES
        IMPORTED_LOCATION_DEBUG "${Foo_LIBRARY_DEBUG}"
      )
    endif()
    set_target_properties(Foo::Foo PROPERTIES
      INTERFACE_COMPILE_OPTIONS "${PC_Foo_CFLAGS_OTHER}"
      INTERFACE_INCLUDE_DIRECTORIES "${Foo_INCLUDE_DIR}"
    )
  endif()

``RELEASE``\ 变量应该首先在属性中列出，以便当用户使用的配置与任何列出的\
``IMPORTED_CONFIGURATIONS``\ 不完全匹配时选择该变量。

大多数缓存变量应该隐藏在\ :program:`ccmake`\ 接口中，除非用户显式要求编辑它们。

.. code-block:: cmake

  mark_as_advanced(
    Foo_INCLUDE_DIR
    Foo_LIBRARY
  )

如果此模块替换旧版本，则应该设置兼容性变量以尽可能减少中断。

.. code-block:: cmake

  # compatibility variables
  set(Foo_VERSION_STRING ${Foo_VERSION})
