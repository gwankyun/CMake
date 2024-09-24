find_package
------------

.. |FIND_XXX| replace:: find_package
.. |FIND_ARGS_XXX| replace:: <PackageName>
.. |FIND_XXX_REGISTRY_VIEW_DEFAULT| replace:: ``TARGET``
.. |CMAKE_FIND_ROOT_PATH_MODE_XXX| replace::
   :variable:`CMAKE_FIND_ROOT_PATH_MODE_PACKAGE`

.. only:: html

   .. contents::

.. note:: :guide:`使用依赖项指南`\ 提供了这个通用主题的高级介绍。它更广泛地概述了\
  ``find_package()``\ 命令在全局中的位置，包括它与\ :module:`FetchContent`\ 模块的关系。\
  建议在阅读下面的细节之前先阅读一下这本指南。

找到一个包（通常由项目外部提供），并加载其特定于包的详细信息。对该命令的调用也可能被\
:ref:`dependency providers <dependency_providers>`\ 拦截。

典型用法
^^^^^^^^^^^^^

大多数对\ ``find_package()``\ 的调用通常是以下格式：

.. parsed-literal::

  find_package(<PackageName> [<version>] [REQUIRED] [COMPONENTS <components>...])

``<PackageName>``\ 是唯一的强制参数。\ ``<version>``\ 通常省略，如果没有包就不能成功配置\
项目，则应该给出\ ``REQUIRED``。一些更复杂的包支持可以使用\ ``COMPONENTS``\ 关键字选择\
组件，但大多数包没有那么复杂的级别。

以上是\ `basic signature`_\ 的简化形式。在可能的情况下，项目应该使用这种形式找到包。这降低\
了复杂性，并最大化了找到或提供包的方式。

了解\ `basic signature`_\ 就足以了解\ ``find_package()``\ 的一般用法了。打算提供配置包\
的项目维护者应该了解更大的图景，在\ :ref:`Full Signature`\ 和本页的所有后续部分中有解释。

搜索模式
^^^^^^^^^^^^

这个命令有几种搜索包的模式：

**模块模式**
  在这种模式下，CMake搜索名为\ ``Find<PackageName>.cmake``\ 的文件。首先在\
  :variable:`CMAKE_MODULE_PATH`\ 中列出的位置中查找，然后在CMake安装提供的\
  :ref:`Find Modules`\ 中查找。如果找到该文件，则由CMake读取和处理。它负责查找包，检查版本，\
  并生成任何需要的消息。有些Find模块对版本控制的支持有限，甚至没有；请查看Find模块的文档。

  ``Find<PackageName>.cmake``\ 文件通常不是由包本身提供的。相反，它通常是由包之外的东西\
  提供的，例如操作系统、CMake本身，甚至调用\ ``find_package()``\ 命令的项目。由于是外部\
  提供的，\ :ref:`Find Modules`\ 在本质上往往是启发式的，很容易过时。它们通常搜索特定的库、\
  文件和其他包工件。

  模块模式仅支持\ :ref:`基本命令签名 <Basic Signature>`。

**配置模式**
  在这种模式下，CMake搜索名为\ ``<lowercasePackageName>-config.cmake``\ 或者\
  ``<PackageName>Config.cmake``\ 的文件。它还将查找\
  ``<lowercasePackageName>-config-version.cmake``\ 或者\
  ``<PackageName>ConfigVersion.cmake``，如果指定了版本细节（有关如何使用这些单独的版本\
  文件的解释，请参见\ :ref:`version selection`）。

  在配置模式下，可以给这个命令一个要搜索的包名列表。CMake搜索配置和版本文件的位置比模块模式\
  要复杂得多（请参阅\ :ref:`search procedure`）。

  配置文件和版本文件通常是作为包的一部分安装的，所以它们往往比Find模块更可靠。它们通常包含包\
  内容的直接信息，因此不需要在配置文件或版本文件本身中搜索或启发式使用。

  :ref:`基本 <Basic Signature>`\ 和\ :ref:`完整 <Full Signature>`\ 都支持配置模式。

**FetchContent重定向模式**
  .. versionadded:: 3.24
    ``find_package()``\ 的调用可以在内部重定向到\ :module:`FetchContent`\ 模块提供的包。\
    对于调用者来说，该行为看起来类似于配置模式，只是省略了搜索逻辑，并且没有使用组件信息。\
    更多细节请参见\ :command:`FetchContent_Declare`\ 和\
    :command:`FetchContent_MakeAvailable`。

当没有重定向到\ :module:`FetchContent`\ 提供的包时，命令参数决定是使用模块模式还是配置模式。\
当使用\ `basic signature`_\ 时，该命令首先以模块模式进行搜索。如果没有找到包，搜索将退回到\
配置模式。用户可以将\ :variable:`CMAKE_FIND_PACKAGE_PREFER_CONFIG`\ 变量设置为true来\
逆转优先级，并在回退到模块模式之前，让CMake首先使用配置模式进行搜索。使用\ ``MODULE``\
关键字还可以强制基本签名只使用模块模式。如果使用\ `full signature`_，只能在配置模式下进行搜索。

.. _`basic signature`:

基本签名
^^^^^^^^^^^^^^^

.. parsed-literal::

  find_package(<PackageName> [version] [EXACT] [QUIET] [MODULE]
               [REQUIRED] [[COMPONENTS] [components...]]
               [OPTIONAL_COMPONENTS components...]
               [REGISTRY_VIEW  (64|32|64_32|32_64|HOST|TARGET|BOTH)]
               [GLOBAL]
               [NO_POLICY_SCOPE]
               [BYPASS_PROVIDER])

模块模式和配置模式都支持基本签名。\ ``MODULE``\ 关键字意味着只能使用模块模式来查找包，而不\
能返回到配置模式。

无论使用的模式是什么，都将设置一个\ ``<PackageName>_FOUND``\ 变量，表示是否找到了包。\
找到包后，可以通过包本身记录的其他变量和\ :ref:`Imported Targets`\ 提供特定于包的信息。\
``QUIET``\ 选项禁用信息性消息，包括那些指示在不\ ``REQUIRED``\ 时无法找到包的消息。如果\
找不到包，\ ``REQUIRED``\ 选项将停止处理并显示错误消息。

特定于包的所需组件列表可以在\ ``COMPONENTS``\ 关键字之后列出。如果这些组件中的任何一个不能\
被满足，则认为整个包没有被找到。如果\ ``REQUIRED``\ 选项也存在，则将其视为致命错误，否则执\
行仍然继续。作为一种简写形式，如果\ ``REQUIRED``\ 选项存在，\ ``COMPONENTS``\ 关键字可\
以省略，并且必要组件可以直接列在\ ``REQUIRED``\ 之后。

其他可选组件可以列在\ ``OPTIONAL_COMPONENTS``\ 之后。如果这些不能满足，仍然可以考虑找到\
整体的包，只要所有需要的组件都满足。

可用组件的集合及其含义由目标包定义。形式上，如何解释提供给它的组件信息取决于目标包，但它应该\
遵循上面所述的期望。对于没有指定组件的调用，没有单一的预期行为，目标包应该清楚地定义在这种情\
况下会发生什么。常见的安排包括假设它应该找到所有组件，没有组件或可用组件的一些定义良好的子集。

.. versionadded:: 3.24
  ``REGISTRY_VIEW``\ 关键字指定应该查询哪些注册表视图。这个关键字只在\ ``Windows``\
  平台上有意义，在其他平台上会被忽略。形式上，如何解释提供给它的注册表视图信息由目标包决定。

.. versionadded:: 3.24
  指定 ``GLOBAL`` 关键字将把导入项目中的所有导入目标提升到全局作用域。或者，可以通过设置\
  :variable:`CMAKE_FIND_PACKAGE_TARGETS_GLOBAL`\ 变量来启用该功能。

.. _FIND_PACKAGE_VERSION_FORMAT:

参数\ ``[version]``\ 请求与找到的包兼容的版本。它有两种可能的形式：

  * 单个版本，格式为\ ``major[.minor[.patch[.tweak]]]``，其中每个分量都是数值。
  * 版本范围，格式为\ ``versionMin...[<]versionMax``，其中\ ``versionMin``\ 和\
    ``versionMax``\ 的格式和约束与单个版本相同，都是整数。默认情况下，包含两个端点。通过\
    指定\ ``<``，上端点将被排除。版本范围仅支持CMake 3.19或更高版本。

``EXACT``\ 选项要求版本完全匹配。此选项与版本范围的规范不兼容。

如果没有\ ``[version]``\ 和/或组件列表提供给find-module中的递归调用，则会自动从外部调用\
转发相应的参数（包括\ ``[version]``\ 的\ ``EXACT``\ 标志）。版本支持目前只在包的基础上提\
供（参见下面的\ `Version Selection`_\ 部分）。当指定了版本范围，但包只设计为期望单一版本时，\
包将忽略范围的上限，只考虑范围下限的单一版本。

有关\ ``NO_POLICY_SCOPE``\ 选项的讨论，请参阅\ :command:`cmake_policy`\ 命令文档。

.. versionadded:: 3.24
  只有\ :ref:`dependency provider <dependency_providers>`\ 调用\ ``find_package()``\
  时，才允许使用\ ``BYPASS_PROVIDER``\ 关键字。提供程序可以使用它直接调用内置的\
  ``find_package()``\ 实现，并防止该调用被重新路由回自身。CMake的未来版本可能会检测到来\
  自依赖提供程序以外的地方使用此关键字的尝试，并终止并抛出致命错误。

.. _`full signature`:

完整签名
^^^^^^^^^^^^^^

.. parsed-literal::

  find_package(<PackageName> [version] [EXACT] [QUIET]
               [REQUIRED] [[COMPONENTS] [components...]]
               [OPTIONAL_COMPONENTS components...]
               [CONFIG|NO_MODULE]
               [GLOBAL]
               [NO_POLICY_SCOPE]
               [BYPASS_PROVIDER]
               [NAMES name1 [name2 ...]]
               [CONFIGS config1 [config2 ...]]
               [HINTS path1 [path2 ... ]]
               [PATHS path1 [path2 ... ]]
               [REGISTRY_VIEW  (64|32|64_32|32_64|HOST|TARGET|BOTH)]
               [PATH_SUFFIXES suffix1 [suffix2 ...]]
               [NO_DEFAULT_PATH]
               [NO_PACKAGE_ROOT_PATH]
               [NO_CMAKE_PATH]
               [NO_CMAKE_ENVIRONMENT_PATH]
               [NO_SYSTEM_ENVIRONMENT_PATH]
               [NO_CMAKE_PACKAGE_REGISTRY]
               [NO_CMAKE_BUILDS_PATH] # Deprecated; does nothing.
               [NO_CMAKE_SYSTEM_PATH]
               [NO_CMAKE_INSTALL_PREFIX]
               [NO_CMAKE_SYSTEM_PACKAGE_REGISTRY]
               [CMAKE_FIND_ROOT_PATH_BOTH |
                ONLY_CMAKE_FIND_ROOT_PATH |
                NO_CMAKE_FIND_ROOT_PATH])

``CONFIG``\ 选项、同义的\ ``NO_MODULE``\ 选项，或使用\ `basic signature`_\ 中没有指定\
的选项，都强制执行纯配置模式。在纯配置模式下，该命令跳过模块模式搜索，并立即进行配置模式搜索。

配置模式搜索试图定位要查找的包提供的配置文件。创建了一个名为\ ``<PackageName>_DIR``\ 的\
缓存项，用于保存包含该文件的目录。缺省情况下，搜索名称为\ ``<PackageName>``\ 的包。如果指\
定了\ ``NAMES``\ 选项，则使用后面的名称，而不是\ ``<PackageName>``。在决定是否将调用重\
定向到\ :module:`FetchContent`\ 提供的包时，也要考虑名称。

该命令搜索名为\ ``<PackageName>Config.cmake``\ 的文件或\
``<lowercasePackageName>-config.cmake``\ 用于指定的每个名称。可以使用\ ``CONFIGS``\
选项给出可能配置文件名称的替换集。:ref:`search procedure`\ 如下所示。一旦找到，就检查任何\
:ref:`版本约束 <version selection>`，如果满足，就由CMake读取和处理配置文件。因为文件是由\
包提供的，所以它已经知道包内容的位置。配置文件的完整路径保存在cmake变量\
``<PackageName>_CONFIG``\ 中。

CMake在搜索具有适当版本的包时考虑的所有配置文件都存储在\
``<PackageName>_CONSIDERED_CONFIGS``\ 变量中，而相关的版本存储在\
``<PackageName>_CONSIDERED_VERSIONS``\ 变量中。

如果找不到包配置文件，除非指定\ ``QUIET``\ 参数，否则CMake将生成一个描述问题的错误。如果指\
定了\ ``REQUIRED``，并且没有找到包，则会生成致命错误，配置步骤将停止执行。如果\
``<PackageName>_DIR``\ 被设置为一个不包含配置文件的目录，CMake将忽略它并从头开始搜索。

建议提供CMake包配置文件的包维护者命名和安装它们，以便下面概述的\ :ref:`search procedure`\
可以找到它们，而不需要使用其他选项。

.. _`search procedure`:

配置模式搜索
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note::
  在使用配置模式时，无论给出的是\ :ref:`完整签名 <full signature>`\ 还是\
  :ref:`基本签名 <basic signature>`，都会应用这个搜索过程。

.. versionadded:: 3.24
  所有对\ ``find_package()``\ 的调用（即使在模块模式下）都首先在\
  :variable:`CMAKE_FIND_PACKAGE_REDIRECTS_DIR`\ 目录中查找配置包文件。\
  :module:`FetchContent`\ 模块，甚至是项目本身，都可以向该位置写入文件，将\
  ``find_package()``\ 调用重定向到项目已经提供的内容。如果在该位置没有找到配置包文件，\
  搜索将按照下面描述的逻辑进行。

CMake为包构造一组可能的安装前缀。在每个前缀下搜索几个目录以查找配置文件。下表显示了搜索的目录。\
每个条目都是按照Windows（\ ``W``\ ）、UNIX（\ ``U``\ ）或Apple（\ ``A``\ ）约定的安装树：

==================================================================== ==========
 条目                                                                 约定
==================================================================== ==========
 ``<prefix>/``                                                          W
 ``<prefix>/(cmake|CMake)/``                                            W
 ``<prefix>/<name>*/``                                                  W
 ``<prefix>/<name>*/(cmake|CMake)/``                                    W
 ``<prefix>/<name>*/(cmake|CMake)/<name>*/`` [#]_                       W
 ``<prefix>/(lib/<arch>|lib*|share)/cmake/<name>*/``                    U
 ``<prefix>/(lib/<arch>|lib*|share)/<name>*/``                          U
 ``<prefix>/(lib/<arch>|lib*|share)/<name>*/(cmake|CMake)/``            U
 ``<prefix>/<name>*/(lib/<arch>|lib*|share)/cmake/<name>*/``            W/U
 ``<prefix>/<name>*/(lib/<arch>|lib*|share)/<name>*/``                  W/U
 ``<prefix>/<name>*/(lib/<arch>|lib*|share)/<name>*/(cmake|CMake)/``    W/U
==================================================================== ==========

.. [#] .. versionadded:: 3.25

在支持macOS :prop_tgt:`FRAMEWORK`\ 和\ :prop_tgt:`BUNDLE`\ 的系统中，可以在以下目录\
中搜索包含配置文件的框架或应用包：

=========================================================== ==========
 条目                                                        约定
=========================================================== ==========
 ``<prefix>/<name>.framework/Resources/``                      A
 ``<prefix>/<name>.framework/Resources/CMake/``                A
 ``<prefix>/<name>.framework/Versions/*/Resources/``           A
 ``<prefix>/<name>.framework/Versions/*/Resources/CMake/``     A
 ``<prefix>/<name>.app/Contents/Resources/``                   A
 ``<prefix>/<name>.app/Contents/Resources/CMake/``             A
=========================================================== ==========

在所有情况下，\ ``<name>``\ 都是不区分大小写的，对应于指定的任何名称（\ ``<PackageName>``\
或由\ ``NAMES``\ 给出的名称）。

如果至少启用了一种编译语言，那么可以根据编译器的目标体系结构搜索特定于体系结构的\
``lib/<arch>``\ 和\ ``lib*``\ 目录，顺序如下：

``lib/<arch>``
  如果设置了\ :variable:`CMAKE_LIBRARY_ARCHITECTURE`\ 变量，则进行搜索。

``lib64``
  在64位平台上搜索（\ :variable:`CMAKE_SIZEOF_VOID_P`\ 为8），\
  :prop_gbl:`FIND_LIBRARY_USE_LIB64_PATHS`\ 属性设置为\ ``TRUE``。

``lib32``
  在32位平台上搜索（\ :variable:`CMAKE_SIZEOF_VOID_P`\ 为4），\
  :prop_gbl:`FIND_LIBRARY_USE_LIB32_PATHS`\ 属性设置为\ ``TRUE``。

``libx32``
  如果\ :prop_gbl:`FIND_LIBRARY_USE_LIBX32_PATHS`\ 属性设置为\ ``TRUE``，则在平台上\
  使用x32 ABI进行搜索。

``lib``
  总是搜索。

.. versionchanged:: 3.24
  在\ ``Windows``\ 平台上，可以使用\ :ref:`专用的语法 <Find Using Windows Registry>`，\
  将注册表查询作为通过\ ``HINTS``\ 和\ ``PATHS``\ 关键字指定的目录的一部分。在所有其他平\
  台上，这些规范将被忽略。

.. versionadded:: 3.24
  可以指定\ ``REGISTRY_VIEW``\ 来管理作为\ ``PATHS``\ 和\ ``HINTS``\ 的一部分指定的\
  ``Windows``\ 注册表查询。

  .. include:: FIND_XXX_REGISTRY_VIEW.txt

如果指定了\ ``PATH_SUFFIXES``，则后缀将逐个添加到每个（\ ``W``\ ）或（\ ``U``\ )目录项。

This set of directories is intended to work in cooperation with
projects that provide configuration files in their installation trees.
Directories above marked with (``W``) are intended for installations on
Windows where the prefix may point at the top of an application's
installation directory.  Those marked with (``U``) are intended for
installations on UNIX platforms where the prefix is shared by multiple
packages.  This is merely a convention, so all (``W``) and (``U``) directories
are still searched on all platforms.  Directories marked with (``A``) are
intended for installations on Apple platforms.  The
:variable:`CMAKE_FIND_FRAMEWORK` and :variable:`CMAKE_FIND_APPBUNDLE`
variables determine the order of preference.

The set of installation prefixes is constructed using the following
steps.  If ``NO_DEFAULT_PATH`` is specified all ``NO_*`` options are
enabled.

1. Search prefixes unique to the current ``<PackageName>`` being found.
   See policy :policy:`CMP0074`.

   .. versionadded:: 3.12

   Specifically, search prefixes specified by the following variables,
   in order:

   a. :variable:`<PackageName>_ROOT` CMake variable,
      where ``<PackageName>`` is the case-preserved package name.

   b. :variable:`<PACKAGENAME>_ROOT` CMake variable,
      where ``<PACKAGENAME>`` is the upper-cased package name.
      See policy :policy:`CMP0144`.

      .. versionadded:: 3.27

   c. :envvar:`<PackageName>_ROOT` environment variable,
      where ``<PackageName>`` is the case-preserved package name.

   d. :envvar:`<PACKAGENAME>_ROOT` environment variable,
      where ``<PACKAGENAME>`` is the upper-cased package name.
      See policy :policy:`CMP0144`.

      .. versionadded:: 3.27

   The package root variables are maintained as a stack so if
   called from within a find module, root paths from the parent's find
   module will also be searched after paths for the current package.
   This can be skipped if ``NO_PACKAGE_ROOT_PATH`` is passed or by setting
   the :variable:`CMAKE_FIND_USE_PACKAGE_ROOT_PATH` to ``FALSE``.

2. Search paths specified in cmake-specific cache variables.  These
   are intended to be used on the command line with a :option:`-DVAR=VALUE <cmake -D>`.
   The values are interpreted as :ref:`semicolon-separated lists <CMake Language Lists>`.
   This can be skipped if ``NO_CMAKE_PATH`` is passed or by setting the
   :variable:`CMAKE_FIND_USE_CMAKE_PATH` to ``FALSE``:

   * :variable:`CMAKE_PREFIX_PATH`
   * :variable:`CMAKE_FRAMEWORK_PATH`
   * :variable:`CMAKE_APPBUNDLE_PATH`

3. Search paths specified in cmake-specific environment variables.
   These are intended to be set in the user's shell configuration,
   and therefore use the host's native path separator
   (``;`` on Windows and ``:`` on UNIX).
   This can be skipped if ``NO_CMAKE_ENVIRONMENT_PATH`` is passed or by setting
   the :variable:`CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH` to ``FALSE``:

   * ``<PackageName>_DIR``
   * :envvar:`CMAKE_PREFIX_PATH`
   * :envvar:`CMAKE_FRAMEWORK_PATH`
   * :envvar:`CMAKE_APPBUNDLE_PATH`

4. Search paths specified by the ``HINTS`` option.  These should be paths
   computed by system introspection, such as a hint provided by the
   location of another item already found.  Hard-coded guesses should
   be specified with the ``PATHS`` option.

5. Search the standard system environment variables.  This can be
   skipped if ``NO_SYSTEM_ENVIRONMENT_PATH`` is passed  or by setting the
   :variable:`CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH` to ``FALSE``. Path entries
   ending in ``/bin`` or ``/sbin`` are automatically converted to their
   parent directories:

   * ``PATH``

6. Search paths stored in the CMake :ref:`User Package Registry`.
   This can be skipped if ``NO_CMAKE_PACKAGE_REGISTRY`` is passed or by
   setting the variable :variable:`CMAKE_FIND_USE_PACKAGE_REGISTRY`
   to ``FALSE`` or the deprecated variable
   :variable:`CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY` to ``TRUE``.

   See the :manual:`cmake-packages(7)` manual for details on the user
   package registry.

7. Search cmake variables defined in the Platform files for the
   current system. The searching of :variable:`CMAKE_INSTALL_PREFIX` and
   :variable:`CMAKE_STAGING_PREFIX` can be
   skipped if ``NO_CMAKE_INSTALL_PREFIX`` is passed or by setting the
   :variable:`CMAKE_FIND_USE_INSTALL_PREFIX` to ``FALSE``. All these locations
   can be skipped if ``NO_CMAKE_SYSTEM_PATH`` is passed or by setting the
   :variable:`CMAKE_FIND_USE_CMAKE_SYSTEM_PATH` to ``FALSE``:

   * :variable:`CMAKE_SYSTEM_PREFIX_PATH`
   * :variable:`CMAKE_SYSTEM_FRAMEWORK_PATH`
   * :variable:`CMAKE_SYSTEM_APPBUNDLE_PATH`

   The platform paths that these variables contain are locations that
   typically include installed software. An example being ``/usr/local`` for
   UNIX based platforms.

8. Search paths stored in the CMake :ref:`System Package Registry`.
   This can be skipped if ``NO_CMAKE_SYSTEM_PACKAGE_REGISTRY`` is passed
   or by setting the :variable:`CMAKE_FIND_USE_SYSTEM_PACKAGE_REGISTRY`
   variable to ``FALSE`` or the deprecated variable
   :variable:`CMAKE_FIND_PACKAGE_NO_SYSTEM_PACKAGE_REGISTRY` to ``TRUE``.

   See the :manual:`cmake-packages(7)` manual for details on the system
   package registry.

9. Search paths specified by the ``PATHS`` option.  These are typically
   hard-coded guesses.

The :variable:`CMAKE_IGNORE_PATH`, :variable:`CMAKE_IGNORE_PREFIX_PATH`,
:variable:`CMAKE_SYSTEM_IGNORE_PATH` and
:variable:`CMAKE_SYSTEM_IGNORE_PREFIX_PATH` variables can also cause some
of the above locations to be ignored.

.. versionadded:: 3.16
   Added the ``CMAKE_FIND_USE_<CATEGORY>`` variables to globally disable
   various search locations.

.. include:: FIND_XXX_ROOT.txt
.. include:: FIND_XXX_ORDER.txt

By default the value stored in the result variable will be the path at
which the file is found.  The :variable:`CMAKE_FIND_PACKAGE_RESOLVE_SYMLINKS`
variable may be set to ``TRUE`` before calling ``find_package`` in order
to resolve symbolic links and store the real path to the file.

Every non-REQUIRED ``find_package`` call can be disabled or made REQUIRED:

* Setting the :variable:`CMAKE_DISABLE_FIND_PACKAGE_<PackageName>` variable
  to ``TRUE`` disables the package.  This also disables redirection to a
  package provided by :module:`FetchContent`.

* Setting the :variable:`CMAKE_REQUIRE_FIND_PACKAGE_<PackageName>` variable
  to ``TRUE`` makes the package REQUIRED.

Setting both variables to ``TRUE`` simultaneously is an error.

.. _`version selection`:

Config Mode Version Selection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note::
  When Config mode is used, this version selection process is applied
  regardless of whether the :ref:`full <full signature>` or
  :ref:`basic <basic signature>` signature was given.

When the ``[version]`` argument is given, Config mode will only find a
version of the package that claims compatibility with the requested
version (see :ref:`format specification <FIND_PACKAGE_VERSION_FORMAT>`). If the
``EXACT`` option is given, only a version of the package claiming an exact match
of the requested version may be found.  CMake does not establish any
convention for the meaning of version numbers.  Package version
numbers are checked by "version" files provided by the packages themselves
or by :module:`FetchContent`.  For a candidate package configuration file
``<config-file>.cmake`` the corresponding version file is located next
to it and named either ``<config-file>-version.cmake`` or
``<config-file>Version.cmake``.  If no such version file is available
then the configuration file is assumed to not be compatible with any
requested version.  A basic version file containing generic version
matching code can be created using the
:module:`CMakePackageConfigHelpers` module.  When a version file
is found it is loaded to check the requested version number.  The
version file is loaded in a nested scope in which the following
variables have been defined:

``PACKAGE_FIND_NAME``
  The ``<PackageName>``
``PACKAGE_FIND_VERSION``
  Full requested version string
``PACKAGE_FIND_VERSION_MAJOR``
  Major version if requested, else 0
``PACKAGE_FIND_VERSION_MINOR``
  Minor version if requested, else 0
``PACKAGE_FIND_VERSION_PATCH``
  Patch version if requested, else 0
``PACKAGE_FIND_VERSION_TWEAK``
  Tweak version if requested, else 0
``PACKAGE_FIND_VERSION_COUNT``
  Number of version components, 0 to 4

When a version range is specified, the above version variables will hold
values based on the lower end of the version range.  This is to preserve
compatibility with packages that have not been implemented to expect version
ranges.  In addition, the version range will be described by the following
variables:

``PACKAGE_FIND_VERSION_RANGE``
  Full requested version range string
``PACKAGE_FIND_VERSION_RANGE_MIN``
  This specifies whether the lower end point of the version range should be
  included or excluded.  Currently, the only supported value for this variable
  is ``INCLUDE``.
``PACKAGE_FIND_VERSION_RANGE_MAX``
  This specifies whether the upper end point of the version range should be
  included or excluded.  The supported values for this variable are
  ``INCLUDE`` and ``EXCLUDE``.

``PACKAGE_FIND_VERSION_MIN``
  Full requested version string of the lower end point of the range
``PACKAGE_FIND_VERSION_MIN_MAJOR``
  Major version of the lower end point if requested, else 0
``PACKAGE_FIND_VERSION_MIN_MINOR``
  Minor version of the lower end point if requested, else 0
``PACKAGE_FIND_VERSION_MIN_PATCH``
  Patch version of the lower end point if requested, else 0
``PACKAGE_FIND_VERSION_MIN_TWEAK``
  Tweak version of the lower end point if requested, else 0
``PACKAGE_FIND_VERSION_MIN_COUNT``
  Number of version components of the lower end point, 0 to 4

``PACKAGE_FIND_VERSION_MAX``
  Full requested version string of the upper end point of the range
``PACKAGE_FIND_VERSION_MAX_MAJOR``
  Major version of the upper end point if requested, else 0
``PACKAGE_FIND_VERSION_MAX_MINOR``
  Minor version of the upper end point if requested, else 0
``PACKAGE_FIND_VERSION_MAX_PATCH``
  Patch version of the upper end point if requested, else 0
``PACKAGE_FIND_VERSION_MAX_TWEAK``
  Tweak version of the upper end point if requested, else 0
``PACKAGE_FIND_VERSION_MAX_COUNT``
  Number of version components of the upper end point, 0 to 4

Regardless of whether a single version or a version range is specified, the
variable ``PACKAGE_FIND_VERSION_COMPLETE`` will be defined and will hold
the full requested version string as specified.

The version file checks whether it satisfies the requested version and
sets these variables:

``PACKAGE_VERSION``
  Full provided version string
``PACKAGE_VERSION_EXACT``
  True if version is exact match
``PACKAGE_VERSION_COMPATIBLE``
  True if version is compatible
``PACKAGE_VERSION_UNSUITABLE``
  True if unsuitable as any version

These variables are checked by the ``find_package`` command to determine
whether the configuration file provides an acceptable version.  They
are not available after the ``find_package`` call returns.  If the version
is acceptable the following variables are set:

``<PackageName>_VERSION``
  Full provided version string
``<PackageName>_VERSION_MAJOR``
  Major version if provided, else 0
``<PackageName>_VERSION_MINOR``
  Minor version if provided, else 0
``<PackageName>_VERSION_PATCH``
  Patch version if provided, else 0
``<PackageName>_VERSION_TWEAK``
  Tweak version if provided, else 0
``<PackageName>_VERSION_COUNT``
  Number of version components, 0 to 4

and the corresponding package configuration file is loaded.
When multiple package configuration files are available whose version files
claim compatibility with the version requested it is unspecified which
one is chosen: unless the variable :variable:`CMAKE_FIND_PACKAGE_SORT_ORDER`
is set no attempt is made to choose a highest or closest version number.

To control the order in which ``find_package`` checks for compatibility use
the two variables :variable:`CMAKE_FIND_PACKAGE_SORT_ORDER` and
:variable:`CMAKE_FIND_PACKAGE_SORT_DIRECTION`.
For instance in order to select the highest version one can set

.. code-block:: cmake

  SET(CMAKE_FIND_PACKAGE_SORT_ORDER NATURAL)
  SET(CMAKE_FIND_PACKAGE_SORT_DIRECTION DEC)

before calling ``find_package``.

Package File Interface Variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When loading a find module or package configuration file ``find_package``
defines variables to provide information about the call arguments (and
restores their original state before returning):

``CMAKE_FIND_PACKAGE_NAME``
  The ``<PackageName>`` which is searched for
``<PackageName>_FIND_REQUIRED``
  True if ``REQUIRED`` option was given
``<PackageName>_FIND_QUIETLY``
  True if ``QUIET`` option was given
``<PackageName>_FIND_REGISTRY_VIEW``
  The requested view if ``REGISTRY_VIEW`` option was given
``<PackageName>_FIND_VERSION``
  Full requested version string
``<PackageName>_FIND_VERSION_MAJOR``
  Major version if requested, else 0
``<PackageName>_FIND_VERSION_MINOR``
  Minor version if requested, else 0
``<PackageName>_FIND_VERSION_PATCH``
  Patch version if requested, else 0
``<PackageName>_FIND_VERSION_TWEAK``
  Tweak version if requested, else 0
``<PackageName>_FIND_VERSION_COUNT``
  Number of version components, 0 to 4
``<PackageName>_FIND_VERSION_EXACT``
  True if ``EXACT`` option was given
``<PackageName>_FIND_COMPONENTS``
  List of specified components (required and optional)
``<PackageName>_FIND_REQUIRED_<c>``
  True if component ``<c>`` is required,
  false if component ``<c>`` is optional

When a version range is specified, the above version variables will hold
values based on the lower end of the version range.  This is to preserve
compatibility with packages that have not been implemented to expect version
ranges.  In addition, the version range will be described by the following
variables:

``<PackageName>_FIND_VERSION_RANGE``
  Full requested version range string
``<PackageName>_FIND_VERSION_RANGE_MIN``
  This specifies whether the lower end point of the version range is
  included or excluded.  Currently, ``INCLUDE`` is the only supported value.
``<PackageName>_FIND_VERSION_RANGE_MAX``
  This specifies whether the upper end point of the version range is
  included or excluded.  The possible values for this variable are
  ``INCLUDE`` or ``EXCLUDE``.

``<PackageName>_FIND_VERSION_MIN``
  Full requested version string of the lower end point of the range
``<PackageName>_FIND_VERSION_MIN_MAJOR``
  Major version of the lower end point if requested, else 0
``<PackageName>_FIND_VERSION_MIN_MINOR``
  Minor version of the lower end point if requested, else 0
``<PackageName>_FIND_VERSION_MIN_PATCH``
  Patch version of the lower end point if requested, else 0
``<PackageName>_FIND_VERSION_MIN_TWEAK``
  Tweak version of the lower end point if requested, else 0
``<PackageName>_FIND_VERSION_MIN_COUNT``
  Number of version components of the lower end point, 0 to 4

``<PackageName>_FIND_VERSION_MAX``
  Full requested version string of the upper end point of the range
``<PackageName>_FIND_VERSION_MAX_MAJOR``
  Major version of the upper end point if requested, else 0
``<PackageName>_FIND_VERSION_MAX_MINOR``
  Minor version of the upper end point if requested, else 0
``<PackageName>_FIND_VERSION_MAX_PATCH``
  Patch version of the upper end point if requested, else 0
``<PackageName>_FIND_VERSION_MAX_TWEAK``
  Tweak version of the upper end point if requested, else 0
``<PackageName>_FIND_VERSION_MAX_COUNT``
  Number of version components of the upper end point, 0 to 4

Regardless of whether a single version or a version range is specified, the
variable ``<PackageName>_FIND_VERSION_COMPLETE`` will be defined and will hold
the full requested version string as specified.

In Module mode the loaded find module is responsible to honor the
request detailed by these variables; see the find module for details.
In Config mode ``find_package`` handles ``REQUIRED``, ``QUIET``, and
``[version]`` options automatically but leaves it to the package
configuration file to handle components in a way that makes sense
for the package.  The package configuration file may set
``<PackageName>_FOUND`` to false to tell ``find_package`` that component
requirements are not satisfied.
