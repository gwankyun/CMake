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

注册表查询的正式语法，使用带有常规扩展的\ `BNF <https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form>`_\
表示法指定，如下所示：

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
供使用包所需的任何变量、宏和导入目标。在上游库没有提供\ :ref:`配置文件包 <Config File Packages>`\
的情况下，查找模块很有用。

传统的方法是对所有东西都使用变量，包括库和可执行文件：请参阅下面的\ `标准变量名`_\ 部分。\
这是CMake提供的大多数现有查找模块所做的。

更现代的方法是通过提供\ :ref:`导入目标 <Imported targets>`，尽可能地像\
:ref:`配置文件包 <Config File Packages>`\ 文件那样运行。这样可以将\
:ref:`Target Usage Requirements`\ 给消费者。

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
何抱怨。如果\ ``Foo_FIND_REQUIRED``\ 被设置为true，如果找不到包，模块应该发出\ ``FATAL_ERROR``。\
如果两者都设置为true，则如果它找不到包，则应该打印一条非致命消息。

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
  这个变量不应该用作\ :command:`find_path`\ 命令的结果变量——请参阅下面的\ ``Xxx_INCLUDE_DIR``）。

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
  设置为true，而旧版本的模块可能会将\ ``Barry_VERSION_2``\ 设置为true。\ ``Barry_VERSION_3``\
  和\ ``Barry_VERSION_2``\ 都设置为true将是错误的。

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
  The path of the library.  Use this form only when the module provides a
  single library.  It is appropriate to use this as the result variable
  in a :command:`find_library` command.

``Xxx_Yy_LIBRARY``
  The path of library ``Yy`` provided by the module ``Xxx``.  Use this form
  when the module provides more than one library or where other modules may
  also provide a library of the same name. It is also appropriate to use
  this form as the result variable in a :command:`find_library` command.

``Xxx_INCLUDE_DIR``
  When the module provides only a single library, this variable can be used
  to specify where to find headers for using the library (or more accurately,
  the path that consumers of the library should add to their header search
  path).  It would be appropriate to use this as the result variable in a
  :command:`find_path` command.

``Xxx_Yy_INCLUDE_DIR``
  If the module provides more than one library or where other modules may
  also provide a library of the same name, this form is recommended for
  specifying where to find headers for using library ``Yy`` provided by
  the module.  Again, it would be appropriate to use this as the result
  variable in a :command:`find_path` command.

To prevent users being overwhelmed with settings to configure, try to
keep as many options as possible out of the cache, leaving at least one
option which can be used to disable use of the module, or locate a
not-found library (e.g. ``Xxx_ROOT_DIR``).  For the same reason, mark
most cache options as advanced.  For packages which provide both debug
and release binaries, it is common to create cache variables with a
``_LIBRARY_<CONFIG>`` suffix, such as ``Foo_LIBRARY_RELEASE`` and
``Foo_LIBRARY_DEBUG``.  The :module:`SelectLibraryConfigurations` module
can be helpful for such cases.

While these are the standard variable names, you should provide
backwards compatibility for any old names that were actually in use.
Make sure you comment them as deprecated, so that no-one starts using
them.

查找模块示例
--------------------

We will describe how to create a simple find module for a library ``Foo``.

The top of the module should begin with a license notice, followed by
a blank line, and then followed by a :ref:`Bracket Comment`.  The comment
should begin with ``.rst:`` to indicate that the rest of its content is
reStructuredText-format documentation.  For example:

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

The module documentation consists of:

* An underlined heading specifying the module name.

* A simple description of what the module finds.
  More description may be required for some packages.  If there are
  caveats or other details users of the module should be aware of,
  specify them here.

* A section listing imported targets provided by the module, if any.

* A section listing result variables provided by the module.

* Optionally a section listing cache variables used by the module, if any.

If the package provides any macros or functions, they should be listed in
an additional section, but can be documented by additional ``.rst:``
comment blocks immediately above where those macros or functions are defined.

The find module implementation may begin below the documentation block.
Now the actual libraries and so on have to be found.  The code here will
obviously vary from module to module (dealing with that, after all, is the
point of find modules), but there tends to be a common pattern for libraries.

First, we try to use ``pkg-config`` to find the library.  Note that we
cannot rely on this, as it may not be available, but it provides a good
starting point.

.. code-block:: cmake

  find_package(PkgConfig)
  pkg_check_modules(PC_Foo QUIET Foo)

This should define some variables starting ``PC_Foo_`` that contain the
information from the ``Foo.pc`` file.

Now we need to find the libraries and include files; we use the
information from ``pkg-config`` to provide hints to CMake about where to
look.

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

Alternatively, if the library is available with multiple configurations, you can
use :module:`SelectLibraryConfigurations` to automatically set the
``Foo_LIBRARY`` variable instead:

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

If you have a good way of getting the version (from a header file, for
example), you can use that information to set ``Foo_VERSION`` (although
note that find modules have traditionally used ``Foo_VERSION_STRING``,
so you may want to set both).  Otherwise, attempt to use the information
from ``pkg-config``

.. code-block:: cmake

  set(Foo_VERSION ${PC_Foo_VERSION})

Now we can use :module:`FindPackageHandleStandardArgs` to do most of the
rest of the work for us

.. code-block:: cmake

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(Foo
    FOUND_VAR Foo_FOUND
    REQUIRED_VARS
      Foo_LIBRARY
      Foo_INCLUDE_DIR
    VERSION_VAR Foo_VERSION
  )

This will check that the ``REQUIRED_VARS`` contain values (that do not
end in ``-NOTFOUND``) and set ``Foo_FOUND`` appropriately.  It will also
cache those values.  If ``Foo_VERSION`` is set, and a required version
was passed to :command:`find_package`, it will check the requested version
against the one in ``Foo_VERSION``.  It will also print messages as
appropriate; note that if the package was found, it will print the
contents of the first required variable to indicate where it was found.

At this point, we have to provide a way for users of the find module to
link to the library or libraries that were found.  There are two
approaches, as discussed in the `Find Modules`_ section above.  The
traditional variable approach looks like

.. code-block:: cmake

  if(Foo_FOUND)
    set(Foo_LIBRARIES ${Foo_LIBRARY})
    set(Foo_INCLUDE_DIRS ${Foo_INCLUDE_DIR})
    set(Foo_DEFINITIONS ${PC_Foo_CFLAGS_OTHER})
  endif()

If more than one library was found, all of them should be included in
these variables (see the `标准变量名`_ section for more
information).

When providing imported targets, these should be namespaced (hence the
``Foo::`` prefix); CMake will recognize that values passed to
:command:`target_link_libraries` that contain ``::`` in their name are
supposed to be imported targets (rather than just library names), and
will produce appropriate diagnostic messages if that target does not
exist (see policy :policy:`CMP0028`).

.. code-block:: cmake

  if(Foo_FOUND AND NOT TARGET Foo::Foo)
    add_library(Foo::Foo UNKNOWN IMPORTED)
    set_target_properties(Foo::Foo PROPERTIES
      IMPORTED_LOCATION "${Foo_LIBRARY}"
      INTERFACE_COMPILE_OPTIONS "${PC_Foo_CFLAGS_OTHER}"
      INTERFACE_INCLUDE_DIRECTORIES "${Foo_INCLUDE_DIR}"
    )
  endif()

One thing to note about this is that the ``INTERFACE_INCLUDE_DIRECTORIES`` and
similar properties should only contain information about the target itself, and
not any of its dependencies.  Instead, those dependencies should also be
targets, and CMake should be told that they are dependencies of this target.
CMake will then combine all the necessary information automatically.

The type of the :prop_tgt:`IMPORTED` target created in the
:command:`add_library` command can always be specified as ``UNKNOWN``
type.  This simplifies the code in cases where static or shared variants may
be found, and CMake will determine the type by inspecting the files.

If the library is available with multiple configurations, the
:prop_tgt:`IMPORTED_CONFIGURATIONS` target property should also be
populated:

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

The ``RELEASE`` variant should be listed first in the property
so that the variant is chosen if the user uses a configuration which is
not an exact match for any listed ``IMPORTED_CONFIGURATIONS``.

Most of the cache variables should be hidden in the :program:`ccmake` interface unless
the user explicitly asks to edit them.

.. code-block:: cmake

  mark_as_advanced(
    Foo_INCLUDE_DIR
    Foo_LIBRARY
  )

If this module replaces an older version, you should set compatibility variables
to cause the least disruption possible.

.. code-block:: cmake

  # compatibility variables
  set(Foo_VERSION_STRING ${Foo_VERSION})
