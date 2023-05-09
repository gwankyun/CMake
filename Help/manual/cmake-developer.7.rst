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

For a ``FindXxx.cmake`` module that takes the approach of setting
variables (either instead of or in addition to creating imported
targets), the following variable names should be used to keep things
consistent between Find modules.  Note that all variables start with
``Xxx_``, which (unless otherwise noted) must match exactly the name
of the ``FindXxx.cmake`` file, including upper/lowercase.
This prefix on the variable names ensures that they do not conflict with
variables of other Find modules.  The same pattern should also be followed
for any macros, functions and imported targets defined by the Find module.

``Xxx_INCLUDE_DIRS``
  The final set of include directories listed in one variable for use by
  client code. This should not be a cache entry (note that this also means
  this variable should not be used as the result variable of a
  :command:`find_path` command - see ``Xxx_INCLUDE_DIR`` below for that).

``Xxx_LIBRARIES``
  The libraries to use with the module.  These may be CMake targets, full
  absolute paths to a library binary or the name of a library that the
  linker must find in its search path.  This should not be a cache entry
  (note that this also means this variable should not be used as the
  result variable of a :command:`find_library` command - see
  ``Xxx_LIBRARY`` below for that).

``Xxx_DEFINITIONS``
  The compile definitions to use when compiling code that uses the module.
  This really shouldn't include options such as ``-DHAS_JPEG`` that a client
  source-code file uses to decide whether to ``#include <jpeg.h>``

``Xxx_EXECUTABLE``
  The full absolute path to an executable.  In this case, ``Xxx`` might not
  be the name of the module, it might be the name of the tool (usually
  converted to all uppercase), assuming that tool has such a well-known name
  that it is unlikely that another tool with the same name exists.  It would
  be appropriate to use this as the result variable of a
  :command:`find_program` command.

``Xxx_YYY_EXECUTABLE``
  Similar to ``Xxx_EXECUTABLE`` except here the ``Xxx`` is always the module
  name and ``YYY`` is the tool name (again, usually fully uppercase).
  Prefer this form if the tool name is not very widely known or has the
  potential  to clash with another tool.  For greater consistency, also
  prefer this form if the module provides more than one executable.

``Xxx_LIBRARY_DIRS``
  Optionally, the final set of library directories listed in one
  variable for use by client code. This should not be a cache entry.

``Xxx_ROOT_DIR``
  Where to find the base directory of the module.

``Xxx_VERSION_VV``
  Variables of this form specify whether the ``Xxx`` module being provided
  is version ``VV`` of the module.  There should not be more than one
  variable of this form set to true for a given module.  For example, a
  module ``Barry`` might have evolved over many years and gone through a
  number of different major versions.  Version 3 of the ``Barry`` module
  might set the variable ``Barry_VERSION_3`` to true, whereas an older
  version of the module might set ``Barry_VERSION_2`` to true instead.
  It would be an error for both ``Barry_VERSION_3`` and ``Barry_VERSION_2``
  to both be set to true.

``Xxx_WRAP_YY``
  When a variable of this form is set to false, it indicates that the
  relevant wrapping command should not be used.  The wrapping command
  depends on the module, it may be implied by the module name or it might
  be specified by the ``YY`` part of the variable.

``Xxx_Yy_FOUND``
  For variables of this form, ``Yy`` is the name of a component for the
  module.  It should match exactly one of the valid component names that
  may be passed to the :command:`find_package` command for the module.
  If a variable of this form is set to false, it means that the ``Yy``
  component of module ``Xxx`` was not found or is not available.
  Variables of this form would typically be used for optional components
  so that the caller can check whether an optional component is available.

``Xxx_FOUND``
  When the :command:`find_package` command returns to the caller, this
  variable will be set to true if the module was deemed to have been found
  successfully.

``Xxx_NOT_FOUND_MESSAGE``
  Should be set by config-files in the case that it has set
  ``Xxx_FOUND`` to FALSE.  The contained message will be printed by the
  :command:`find_package` command and by
  :command:`find_package_handle_standard_args` to inform the user about the
  problem.  Use this instead of calling :command:`message` directly to
  report a reason for failing to find the module or package.

``Xxx_RUNTIME_LIBRARY_DIRS``
  Optionally, the runtime library search path for use when running an
  executable linked to shared libraries.  The list should be used by
  user code to create the ``PATH`` on windows or ``LD_LIBRARY_PATH`` on
  UNIX.  This should not be a cache entry.

``Xxx_VERSION``
  The full version string of the package found, if any.  Note that many
  existing modules provide ``Xxx_VERSION_STRING`` instead.

``Xxx_VERSION_MAJOR``
  The major version of the package found, if any.

``Xxx_VERSION_MINOR``
  The minor version of the package found, if any.

``Xxx_VERSION_PATCH``
  The patch version of the package found, if any.

The following names should not usually be used in ``CMakeLists.txt`` files.
They are intended for use by Find modules to specify and cache the locations
of specific files or directories.  Users are typically able to set and edit
these variables to control the behavior of Find modules (like entering the
path to a library manually):

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
