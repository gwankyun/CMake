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
:ref:`依赖提供者 <dependency_providers>`\ 拦截。

典型用法
^^^^^^^^^^^^^

大多数对\ ``find_package()``\ 的调用通常是以下格式：

.. code-block:: cmake

  find_package(<PackageName> [<version>] [REQUIRED] [COMPONENTS <components>...])

``<PackageName>``\ 是唯一的强制参数。\ ``<version>``\ 通常省略，如果没有包就不能成功配置\
项目，则应该给出\ ``REQUIRED``。一些更复杂的包支持可以使用\ ``COMPONENTS``\ 关键字选择\
组件，但大多数包没有那么复杂的级别。

以上是\ `基本签名 <basic signature>`_\ 的简化形式。在可能的情况下，项目应该使用这种形式找\
到包。这降低了复杂性，并最大化了找到或提供包的方式。

了解\ `基本签名 <basic signature>`_\ 就足以了解\ ``find_package()``\ 的一般用法了。\
打算提供包配置文件的项目维护者应该了解更大的图景，在\ :ref:`Full Signature`\ 和本页的所有\
后续部分中有解释。

搜索模式
^^^^^^^^^^^^

这个命令有几种搜索包的模式：

.. _`Module mode`:

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

.. _`Config mode`:

**配置模式**
  在此模式下，CMake 搜索匹配以下任一格式的文件：

  * ``<PackageName>.cps``
  * ``<lowercasePackageName>.cps``
  * ``<lowercasePackageName>-config.cmake``
  * ``<PackageName>Config.cmake``

  如果找到后两个文件之一，且指定了版本详细信息，CMake 还将分别查找
  ``<lowercasePackageName>-config-version.cmake`` 或
  ``<PackageName>ConfigVersion.cmake`` （有关这些独立版本文件的使用方式，请参阅\
  :ref:`version selection`）。后两个选项是 CMake 脚本包描述文件。前两个是
  |CPS|_ （CPS）包描述文件，它们更具可移植性，并在“基础”文件中包含版本信息。除任何明确\
  注明的例外之外，对“配置文件”、“配置模式”、“包配置文件”等的引用同样适用于 CPS 和 CMake
  脚本文件。

  .. note::
    搜索的实现方式使得在大多数情况下倾向于优先选择\ |CPS|\ 文件而非CMake脚本配置文件。指定\
    ``CONFIGS``\ 选项会排除对CPS文件的考虑。

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
当使用\ `基本签名 <basic signature>`_\ 时，该命令首先以模块模式进行搜索。如果没有找到包，\
搜索将退回到配置模式。用户可以将\ :variable:`CMAKE_FIND_PACKAGE_PREFER_CONFIG`\ 变量\
设置为true来逆转优先级，并在回退到模块模式之前，让CMake首先使用配置模式进行搜索。使用\
``MODULE``\ 关键字还可以强制基本签名只使用模块模式。如果使用\ `完整签名 <full signature>`_，\
只能在配置模式下进行搜索。

.. _`basic signature`:

基本签名
^^^^^^^^^^^^^^^

.. code-block:: cmake

  find_package(<PackageName> [<version>] [EXACT] [QUIET] [MODULE]
               [REQUIRED|OPTIONAL] [[COMPONENTS] <component>...]
               [OPTIONAL_COMPONENTS <component>...]
               [REGISTRY_VIEW {64|32|64_32|32_64|HOST|TARGET|BOTH}]
               [GLOBAL]
               [NO_POLICY_SCOPE]
               [BYPASS_PROVIDER]
               [UNWIND_INCLUDE])

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

可以启用\ :variable:`CMAKE_FIND_REQUIRED`\ 变量，使此调用默认具有\ ``REQUIRED``\ 属性。\
这种行为可以通过提供\ ``OPTIONAL``\ 关键字来覆盖。和\ ``REQUIRED``\ 选项一样，\
组件列表可以直接列在\ ``OPTIONAL``\ 之后，这与将它们列在\ ``COMPONENTS``\ 关键字\
之后等效。当指定\ ``OPTIONAL``\ 关键字时，在未找到包时的警告输出将被抑制。

其他可选组件可以列在\ ``OPTIONAL_COMPONENTS``\ 之后。如果这些不能满足，仍然可以考虑找到\
整体的包，只要所有需要的组件都满足。

可用组件的集合及其含义由目标包定义：

* 对于CMake脚本包配置文件，正式来说，目标包如何解释提供给它的组件信息由其自行决定，但它应该\
  遵循上述期望。对于未指定任何组件的调用，没有单一的预期行为，目标包应该明确定义在这种情况下\
  会发生什么。常见的安排包括假设应该找到所有组件、不找任何组件或找到可用组件的某个明确定义的子集。

* |CPS|\ 包由一个根配置文件和零个或多个附录组成，每个附录都提供组件并且可能有依赖项。CMake\
  总是尝试加载根配置文件。只有当附录的依赖项可以满足，并且它们要么提供了请求的组件，要么没有\
  请求任何组件时，才会加载附录。如果提供必需组件的附录的依赖项无法满足，则认为该包未找到。否则，\
  该附录将被忽略。

.. versionadded:: 3.24
  ``REGISTRY_VIEW``\ 关键字指定应该查询哪些注册表视图。这个关键字只在\ ``Windows``\
  平台上有意义，在其他平台上会被忽略。形式上，如何解释提供给它的注册表视图信息由目标包决定。

.. versionadded:: 3.24
  指定 ``GLOBAL`` 关键字将把导入项目中的所有导入目标提升到全局作用域。或者，可以通过设置\
  :variable:`CMAKE_FIND_PACKAGE_TARGETS_GLOBAL`\ 变量来启用该功能。

.. _FIND_PACKAGE_VERSION_FORMAT:

参数\ ``<version>``\ 请求与找到的包兼容的版本。它有两种可能的形式：

* 单个版本，格式为\ ``major[.minor[.patch[.tweak]]]``，其中每个分量都是数值。
* 版本范围，格式为\ ``versionMin...[<]versionMax``，其中\ ``versionMin``\ 和\
  ``versionMax``\ 的格式和约束与单个版本相同，都是整数。默认情况下，包含两个端点。通过\
  指定\ ``<``，上端点将被排除。版本范围仅支持CMake 3.19或更高版本。

.. note::
  除CPS包外，目前版本支持是按单个包分别提供的。当指定了版本范围，但包仅被设计为支持单个版本时，\
  该包将忽略版本范围的上限，仅考虑范围下限的单个版本。支持版本范围的非CPS包，其支持方式由各个\
  包自行决定。有关详细信息和重要注意事项，请参阅下面的\ `版本选择 <Version Selection>`_\ 部分。

``EXACT``\ 选项要求版本完全匹配。此选项与版本范围的规范不兼容。

如果没有\ ``<version>``\ 和/或组件列表提供给find-module中的递归调用，则会自动从外部调用\
转发相应的参数（包括\ ``<version>``\ 的\ ``EXACT``\ 标志）。版本支持目前只在包的基础上提\
供（参见下面的\ `版本选择 <Version Selection>`_\ 部分）。

有关\ ``NO_POLICY_SCOPE``\ 选项的讨论，请参阅\ :command:`cmake_policy`\ 命令文档。

.. versionadded:: 3.24
  只有\ :ref:`依赖提供者 <dependency_providers>`\ 调用\ ``find_package()``\
  时，才允许使用\ ``BYPASS_PROVIDER``\ 关键字。提供程序可以使用它直接调用内置的\
  ``find_package()``\ 实现，并防止该调用被重新路由回自身。CMake的未来版本可能会检测到来\
  自依赖提供程序以外的地方使用此关键字的尝试，并终止并抛出致命错误。

.. versionadded:: 4.2
  ``UNWIND_INCLUDE`` 关键字仅允许在 ``find_package()`` 于父级
  ``find_package()`` 调用中被调用时使用。当对 ``find_package(UNWIND_INCLUDE)``
  的调用未能找到所需的包时，它将进入“回退”状态。在此状态下，进一步对
  ``find_package()`` 和 :command:`include()` 的调用将被禁止，且所有父级
  :command:`include()` 命令在其作用域到达时将立即调用 :command:`return()`。
  此“回退”过程将持续进行，直到返回到父级 ``find_package()`` 为止。

  ``UNWIND_INCLUDE`` 仅旨在供由 :command:`install(EXPORT_PACKAGE_DEPENDENCIES)`
  生成的 ``find_package()`` 调用使用，但对于希望以类似方式手动管理其依赖项的人也可能有用。

.. _`full signature`:

完整签名
^^^^^^^^^^^^^^

.. code-block:: cmake

  find_package(<PackageName> [version] [EXACT] [QUIET]
               [REQUIRED|OPTIONAL] [[COMPONENTS] <component>...]
               [OPTIONAL_COMPONENTS <component>...]
               [CONFIG|NO_MODULE]
               [GLOBAL]
               [NO_POLICY_SCOPE]
               [BYPASS_PROVIDER]
               [NAMES <name>...]
               [CONFIGS <config>...]
               [HINTS <path>...]
               [PATHS <path>...]
               [REGISTRY_VIEW {64|32|64_32|32_64|HOST|TARGET|BOTH}]
               [PATH_SUFFIXES <suffix>...]
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

``CONFIG``\ 选项、同义的\ ``NO_MODULE``\ 选项，或使用\ `基本签名 <basic signature>`_\
中没有指定的选项，都强制执行纯配置模式。在纯配置模式下，该命令跳过模块模式搜索，并立即进行配置\
模式搜索。

配置模式搜索试图定位要查找的包提供的配置文件。创建了一个名为\ ``<PackageName>_DIR``\ 的\
缓存项，用于保存包含该文件的目录。缺省情况下，搜索名称为\ ``<PackageName>``\ 的包。如果指\
定了\ ``NAMES``\ 选项，则使用后面的名称，而不是\ ``<PackageName>``。在决定是否将调用重\
定向到\ :module:`FetchContent`\ 提供的包时，也要考虑名称。

该命令针对每个指定的包名，搜索匹配以下任一名称的文件：

* ``<PackageName>Config.cmake``
* ``<lowercasePackageName>-config.cmake``
* ``<PackageName>.cps``
* ``<lowercasePackageName>.cps``

可以使用\ ``CONFIGS``\
选项给出可能配置文件名称的替换集。:ref:`search procedure`\ 如下所示。一旦找到，就检查任何\
:ref:`版本约束 <version selection>`，如果满足，就由CMake读取和处理配置文件。因为文件是由\
包提供的，所以它已经知道包内容的位置。配置文件的完整路径保存在CMake变量\
``<PackageName>_CONFIG``\ 中。

.. note::

  由于 CPS 文件不允许使用与包名\ *不*\ 匹配的名称，因此指定 ``CONFIGS`` 将抑制对 CPS 文件的搜索。

CMake在搜索具有适当版本的包时考虑的所有配置文件都存储在\
``<PackageName>_CONSIDERED_CONFIGS``\ 变量中，而相关的版本存储在\
``<PackageName>_CONSIDERED_VERSIONS``\ 变量中。

如果找不到包配置文件，CMake 将生成描述该问题的错误，除非指定了 ``QUIET`` 参数。\
如果指定了 ``REQUIRED`` 且未找到该包，则将生成致命错误并停止执行配置步骤。
如果 ``<PackageName>_DIR`` 已被设置为不包含配置文件的目录，或者所请求的版本与该目录中\
找到的包不兼容（参见\ :ref:`version selection`），CMake 将忽略该设置并从头开始搜索。

建议提供包配置文件的包维护者命名和安装它们，以便下面概述的\ :ref:`search procedure`\
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
 ``<prefix>/<name>/cps/`` [#p2]_                                        W
 ``<prefix>/<name>/*/cps/`` [#p2]_                                      W
 ``<prefix>/cps/<name>/`` [#p2]_                                        W
 ``<prefix>/cps/<name>/*/`` [#p2]_                                      W
 ``<prefix>/cps/`` [#p2]_                                               W
 ``<prefix>/``                                                          W
 ``<prefix>/(cmake|CMake)/``                                            W
 ``<prefix>/<name>*/``                                                  W
 ``<prefix>/<name>*/(cmake|CMake)/``                                    W
 ``<prefix>/<name>*/(cmake|CMake)/<name>*/`` [#p1]_                     W
 ``<prefix>/(lib/<arch>|lib*|share)/cps/<name>/`` [#p2]_                U
 ``<prefix>/(lib/<arch>|lib*|share)/cps/<name>/*/`` [#p2]_              U
 ``<prefix>/(lib/<arch>|lib*|share)/cps/`` [#p2]_                       U
 ``<prefix>/(lib/<arch>|lib*|share)/cmake/<name>*/``                    U
 ``<prefix>/(lib/<arch>|lib*|share)/<name>*/``                          U
 ``<prefix>/(lib/<arch>|lib*|share)/<name>*/(cmake|CMake)/``            U
 ``<prefix>/<name>*/(lib/<arch>|lib*|share)/cmake/<name>*/``            W/U
 ``<prefix>/<name>*/(lib/<arch>|lib*|share)/<name>*/``                  W/U
 ``<prefix>/<name>*/(lib/<arch>|lib*|share)/<name>*/(cmake|CMake)/``    W/U
==================================================================== ==========

.. [#p1] .. versionadded:: 3.25

.. [#p2] .. versionadded:: 4.3

在支持macOS :prop_tgt:`FRAMEWORK`\ 和\ :prop_tgt:`BUNDLE`\ 的系统中，可以在以下目录\
中搜索包含配置文件的框架或应用包：

=============================================================== ==========
 Entry                                                          Convention
=============================================================== ==========
 ``<prefix>/<name>.framework/Versions/*/Resources/CPS/`` [#p3]_    A
 ``<prefix>/<name>.framework/Resources/CPS/`` [#p3]_               A
 ``<prefix>/<name>.framework/Resources/``                          A
 ``<prefix>/<name>.framework/Resources/CMake/``                    A
 ``<prefix>/<name>.framework/Versions/*/Resources/``               A
 ``<prefix>/<name>.framework/Versions/*/Resources/CMake/``         A
 ``<prefix>/<name>.app/Contents/Resources/CPS/`` [#p3]_            A
 ``<prefix>/<name>.app/Contents/Resources/``                       A
 ``<prefix>/<name>.app/Contents/Resources/CMake/``                 A
=============================================================== ==========

.. [#p3] .. versionadded:: 4.3

在搜索上述路径时，\ ``find_package``\ 仅会在包含\ ``/cps/``\ 的搜索路径中查找\ ``.cps``\
文件，在其他路径中则仅查找\ ``.cmake``\ 文件。（这仅适用于指定的路径，不考虑\ ``<prefix>``\
或\ ``<name>``\ 的内容。）

在所有情况下，\ ``<name>``\ 都是不区分大小写的，对应于指定的任何名称（\ ``<PackageName>``\
或由\ ``NAMES``\ 给出的名称）

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

  .. include:: include/FIND_XXX_REGISTRY_VIEW.rst

如果指定了\ ``PATH_SUFFIXES``，则后缀将逐个添加到每个（\ ``W``\ ）或（\ ``U``\ )目录项。

这组目录旨在与在其安装树中提供配置文件的项目协同工作。上面标有（\ ``W``\ ）的目录用于Windows\
上的安装，其中前缀可能指向应用程序安装目录的顶部。标记为（\ ``U``\ ）的用于UNIX平台上的安装，\
其中前缀由多个包共享。这只是一种约定，因此所有（\ ``W``\ ）和（\ ``U``\ ）目录仍然会在所有\
平台上被搜索。标有（\ ``A``\ ）的目录用于在Apple平台上安装。:variable:`CMAKE_FIND_FRAMEWORK`\
和\ :variable:`CMAKE_FIND_APPBUNDLE`\ 变量决定了偏好的顺序。

.. warning::

  将\ :variable:`CMAKE_FIND_FRAMEWORK`\ 或\ :variable:`CMAKE_FIND_APPBUNDLE`\
  设置为除\ ``FIRST``\ （默认值）之外的值，将会导致CMake搜索\ |CPS|\ 文件的顺序与规范中\
  规定的顺序不同。

安装前缀的集合使用以下步骤构建。如果指定\ ``NO_DEFAULT_PATH``，则启用所有\ ``NO_*``\ 选项。

1. 搜索当前找到的\ ``<PackageName>``\ 的唯一前缀。参见策略\ :policy:`CMP0074`。

   .. versionadded:: 3.12

   具体来说，按照以下变量指定的顺序搜索前缀：

   a. :variable:`<PackageName>_ROOT` CMake变量，其中\ ``<PackageName>``\ 是保留大小\
      写的包名。

   b. :variable:`<PACKAGENAME>_ROOT` CMake变量，其中\ ``<PACKAGENAME>``\ 为大写的\
      包名。参见策略\ :policy:`CMP0144`。

      .. versionadded:: 3.27

   c. :envvar:`<PackageName>_ROOT`\ 环境变量，其中\ ``<PackageName>``\ 是保留大小写\
      的包名。

   d. :envvar:`<PACKAGENAME>_ROOT`\ 环境变量，其中\ ``<PACKAGENAME>``\ 为大写的包名。\
      参见策略\ :policy:`CMP0144`。

      .. versionadded:: 3.27

   包根变量作为栈维护，因此如果从查找模块中调用，则父查找模块的根路径也将搜索当前包的路径。\
   如果传递了\ ``NO_PACKAGE_ROOT_PATH``，或者将\
   :variable:`CMAKE_FIND_USE_PACKAGE_ROOT_PATH`\ 设置为\ ``FALSE``，则可以跳过该操作。

2. 搜索指定在CMake专用缓存变量中的路径。它们通常在命令行中使用\ :option:`-DVAR=VALUE <cmake -D>`。\
   这些值被解释为\ :ref:`以分号分隔的列表 <CMake Language Lists>`。如果传递了\
   ``NO_CMAKE_PATH``\ 参数，或者将\ :variable:`CMAKE_FIND_USE_CMAKE_PATH`\ 设置为\
   ``FALSE``，则可以跳过该操作：

   * :variable:`CMAKE_PREFIX_PATH`
   * :variable:`CMAKE_FRAMEWORK_PATH`
   * :variable:`CMAKE_APPBUNDLE_PATH`

3. 在CMake特定的环境变量中搜索指定的路径。这些分隔符需要在用户的shell配置中设置，因此要使用\
   主机的本地路径分隔符（在Windows上为\ ``;``，而在UNIX上则为\ ``:``）。如果传递了\
   ``NO_CMAKE_ENVIRONMENT_PATH``，或者将\
   :variable:`CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH`\ 设置为\ ``FALSE``，则可以跳过：

   * ``<PackageName>_DIR``
   * :envvar:`CMAKE_PREFIX_PATH`
   * :envvar:`CMAKE_FRAMEWORK_PATH`
   * :envvar:`CMAKE_APPBUNDLE_PATH`

4. 搜索路径指定的\ ``HINTS``\ 选项。这些路径应该是由系统自省计算出来的，例如由已经找到的另\
   一项的位置提供的提示。硬编码的猜测应该用\ ``PATHS``\ 选项指定。

5. 搜索标准系统环境变量。如果传递了\ ``NO_SYSTEM_ENVIRONMENT_PATH``，或者将\
   :variable:`CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH`\ 设置为\ ``FALSE``，就可以跳\
   过这一步。以\ ``/bin``\ 或\ ``/sbin``\ 结尾的路径项会自动转换到它们的父目录：

   * ``PATH``

6. 搜索存储在CMake\ :ref:`User Package Registry`\ 的路径。如果传递了\
   ``NO_CMAKE_PACKAGE_REGISTRY``，这可以跳过，或者将变量\
   :variable:`CMAKE_FIND_USE_PACKAGE_REGISTRY`\ 设置为\ ``FALSE``，或者将已弃用的变\
   量\ :variable:`CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY`\ 设置为\ ``TRUE``。

   有关用户包注册表的详细信息，请参阅\ :manual:`cmake-packages(7)`\ 手册。

   :variable:`CMAKE_FIND_USE_CMAKE_SYSTEM_PATH` to ``FALSE``:
7. 在平台文件中搜索当前系统中定义的CMake变量。如果传递了\ ``NO_CMAKE_INSTALL_PREFIX``\
   或将\ :variable:`CMAKE_FIND_USE_INSTALL_PREFIX`\ 设置为\ ``FALSE``，可以跳过对\
   :variable:`CMAKE_INSTALL_PREFIX`\ 和\ :variable:`CMAKE_STAGING_PREFIX`\ 的搜索。\
   如果传递了\ ``NO_CMAKE_SYSTEM_PATH``，或者将\
   :variable:`CMAKE_FIND_USE_CMAKE_SYSTEM_PATH`\ 设置为\ ``FALSE``，那么可以跳过所\
   有这些位置：

   * :variable:`CMAKE_SYSTEM_PREFIX_PATH`
   * :variable:`CMAKE_SYSTEM_FRAMEWORK_PATH`
   * :variable:`CMAKE_SYSTEM_APPBUNDLE_PATH`

   这些变量包含的平台路径通常包含已安装软件的位置。一个例子是基于UNIX平台的\ ``/usr/local``。

8. 搜索存储在CMake\ :ref:`System Package Registry`\ 中的路径。如果传递了\
   ``NO_CMAKE_SYSTEM_PACKAGE_REGISTRY``，这可以跳过，或者将\
   :variable:`CMAKE_FIND_USE_SYSTEM_PACKAGE_REGISTRY`\ 变量设置为\ ``FALSE``，或者\
   将已弃用的变量\ :variable:`CMAKE_FIND_PACKAGE_NO_SYSTEM_PACKAGE_REGISTRY`\ 设置\
   为\ ``TRUE``。

   有关系统包注册表的详细信息，请参阅\ :manual:`cmake-packages(7)`\ 手册。

9. 搜索由\ ``PATHS``\ 选项指定的路径。这些通常是硬编码的猜测。

:variable:`CMAKE_IGNORE_PATH`、\ :variable:`CMAKE_IGNORE_PREFIX_PATH`、\
:variable:`CMAKE_SYSTEM_IGNORE_PATH`\ 和\
:variable:`CMAKE_SYSTEM_IGNORE_PREFIX_PATH`\ 变量也可能导致上述一些位置被忽略。

按上述顺序搜索路径。使用找到的第一个可行的包配置文件，即使较新的包版本位于搜索路径列表的后面。

For search paths which contain glob expressions (``*``), directories matching
the glob are searched in natural, descending order by default. This behavior
can be overridden by setting variables :variable:`CMAKE_FIND_PACKAGE_SORT_ORDER`
and :variable:`CMAKE_FIND_PACKAGE_SORT_DIRECTION` accordingly. Those variables
determine the order in which CMake considers glob matches. For example, if the
file system contains the package configuration files

::

  <prefix>/example-1.2/example-config.cmake
  <prefix>/example-1.10/example-config.cmake
  <prefix>/share/example-2.0/example-config.cmake

then ``find_package(example)`` will (when the aforementioned variables are
unset) pick ``example-1.10`` (assuming both ``example-1.2`` and ``example-1.10``
are viable). Note however that ``find_package`` will *not* find ``example-2.0``,
because one of the other two will be found first.

要控制 ``find_package`` 搜索匹配glob表达式的目录的顺序，可以使用\
:variable:`CMAKE_FIND_PACKAGE_SORT_ORDER`\ 和\
:variable:`CMAKE_FIND_PACKAGE_SORT_DIRECTION`。例如，要使上面的示例选择\
``example-1.12``，可以设置

.. code-block:: cmake

  set(CMAKE_FIND_PACKAGE_SORT_ORDER NATURAL)
  set(CMAKE_FIND_PACKAGE_SORT_DIRECTION ASC)

在调用\ ``find_package``\ 之前。

.. versionadded:: 3.16
   添加了\ ``CMAKE_FIND_USE_<CATEGORY>``\ 变量来全局禁用各种搜索位置。

.. versionchanged:: 4.0
   变量\ :variable:`CMAKE_FIND_PACKAGE_SORT_ORDER`\ 和\
   :variable:`CMAKE_FIND_PACKAGE_SORT_DIRECTION`\ 现在还控制着\ ``find_package``\
   在搜索路径\ ``<prefix>/<name>.framework/Versions/*/Resources/``\ 和\
   ``<prefix>/<name>.framework/Versions/*/Resources/CMake``\ 中搜索与通配符表达式\
   匹配的目录的顺序。在以前的 CMake 版本中，这个顺序是未指定的。

.. versionchanged:: 4.2
   When encountering multiple viable matches, ``find_package`` now picks the
   one with the most recent version by default. In previous versions of CMake,
   the result was unspecified. Accordingly, the default of
   :variable:`CMAKE_FIND_PACKAGE_SORT_ORDER` has changed from ``NONE`` to
   ``NATURAL`` and :variable:`CMAKE_FIND_PACKAGE_SORT_DIRECTION`
   now defaults to ``DEC`` (descending) instead of ``ASC`` (ascending).


.. include:: include/FIND_XXX_ROOT.rst
.. include:: include/FIND_XXX_ORDER.rst

默认情况下，保存在结果变量中的值是找到文件的路径。在调用\ ``find_package``\ 之前，可以将\
:variable:`CMAKE_FIND_PACKAGE_RESOLVE_SYMLINKS`\ 变量设置为\ ``TRUE``，以便解析符号\
链接并存储文件的真实路径。

每个非必需的\ ``find_package``\ 调用都可以禁用或变为必需：

* 设置\ :variable:`CMAKE_DISABLE_FIND_PACKAGE_<PackageName>`\ 变量为\ ``TRUE``\
  禁用包。这也禁用了重定向到\ :module:`FetchContent`\ 提供的包。

* 将\ :variable:`CMAKE_REQUIRE_FIND_PACKAGE_<PackageName>`\ 变量设置为\ ``TRUE``\
  使该包是必需的。

将这两个变量同时设置为\ ``TRUE``\ 将导致错误。

在确定某个包是否为必需项时，:variable:`CMAKE_REQUIRE_FIND_PACKAGE_<PackageName>`\
变量的优先级高于\ ``OPTIONAL``\ 关键字。

.. _`version selection`:

配置模式版本选择
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note::
  当使用配置模式时，无论给出的是\ :ref:`完整 <full signature>`\ 签名还是\
  :ref:`基础 <basic signature>`\ 签名，都会执行这个版本选择过程。

当提供了\ ``<version>``\ 参数时，配置模式将仅查找声明与所请求版本兼容的包版本（请参阅\
:ref:`格式规范 <FIND_PACKAGE_VERSION_FORMAT>`）。如果指定了\ ``EXACT``\ 选项，则仅会\
查找声明与所请求版本完全匹配的包版本。CMake并未为版本号的含义建立任何约定。

.. _`cmake script version selection`:

CMake脚本
""""""""""""

对于CMake脚本包配置文件\
``<config-file>.cmake``\ 对应的版本文件位于它旁边，并命名为\
``<config-file>-version.cmake``\ 或\ ``<config-file>Version.cmake``。如果没有可用\
的版本文件，则假定没有可用的配置文件与任何请求的版本兼容。创建包含通用版本匹配代码的基本版本\
文件的方法是使用\ :module:`CMakePackageConfigHelpers`\ 模块。当找到一个版本文件时，将\
加载它以检查所请求的版本号。版本文件在一个嵌套作用域中加载，其中定义了以下变量：

``PACKAGE_FIND_NAME``
  ``<PackageName>``
``PACKAGE_FIND_VERSION``
  完整请求的版本字符串
``PACKAGE_FIND_VERSION_MAJOR``
  如果请求，则为主版本，否则为0
``PACKAGE_FIND_VERSION_MINOR``
  如果请求，则为次版本，否则为0
``PACKAGE_FIND_VERSION_PATCH``
  如果请求，则为补丁版本，否则为0
``PACKAGE_FIND_VERSION_TWEAK``
  如果请求，则为调整版本，否则为0
``PACKAGE_FIND_VERSION_COUNT``
  版本组件数量，0至4

如果指定了版本范围，上述版本变量中的值将基于版本范围的下限。这是为了保持与未实现的包的兼容性，\
以期望的版本范围。此外，版本范围由以下变量描述：

``PACKAGE_FIND_VERSION_RANGE``
  完整请求的版本范围字符串
``PACKAGE_FIND_VERSION_RANGE_MIN``
  这指定了应该包含还是不包含版本范围的下限。目前，这个变量唯一支持的值是\ ``INCLUDE``。

``PACKAGE_FIND_VERSION_RANGE_MAX``
  这指定了应该包含还是不包含版本范围的上限端点。该变量支持的值\ ``INCLUDE``\ 和\ ``EXCLUDE``。

``PACKAGE_FIND_VERSION_MIN``
  完整请求的下限版本字符串范围的
``PACKAGE_FIND_VERSION_MIN_MAJOR``
  如有请求，则为低端点的主版本，否则为0
``PACKAGE_FIND_VERSION_MIN_MINOR``
  如有请求，则为低端点的次版本，否则为0
``PACKAGE_FIND_VERSION_MIN_PATCH``
  如有请求，则为低端点的补丁版本，否则为0
``PACKAGE_FIND_VERSION_MIN_TWEAK``
  如有请求，则为低端点的调整版本，否则为0
``PACKAGE_FIND_VERSION_MIN_COUNT``
  分量数目的下限，0到4

``PACKAGE_FIND_VERSION_MAX``
  完整请求的版本字符串范围的上限
``PACKAGE_FIND_VERSION_MAX_MAJOR``
  如有请求，则为上端点的主版本号，否则为0
``PACKAGE_FIND_VERSION_MAX_MINOR``
  如有请求，则为上端点的次版本号，否则为0
``PACKAGE_FIND_VERSION_MAX_PATCH``
  如有请求，则为上端点的补丁版本号，否则为0
``PACKAGE_FIND_VERSION_MAX_TWEAK``
  如有请求，则为上端点的调整版本号，否则为0
``PACKAGE_FIND_VERSION_MAX_COUNT``
  上端点的版本分量数目，0到4

不管指定的是一个版本号还是一个版本范围，变量\ ``PACKAGE_FIND_VERSION_COMPLETE``\ 将保存\
指定的完整版本号字符串。

版本文件检查它是否满足要求的版本号，并设置以下变量：

``PACKAGE_VERSION``
  完整提供的版本字符串
``PACKAGE_VERSION_EXACT``
  如果版本完全匹配，返回True
``PACKAGE_VERSION_COMPATIBLE``
  如果版本兼容，返回True
``PACKAGE_VERSION_UNSUITABLE``
  如果不适合任何版本，则为True

``find_package``\ 命令检查这些变量，以确定配置文件是否提供了可接受的版本。在\ ``find_package``\
调用返回后，它们就不可用了。如果版本可以接受，则设置以下变量：

``<PackageName>_VERSION``
  完整提供的版本字符串
``<PackageName>_VERSION_MAJOR``
  如果提供了，为主版本，否则为0
``<PackageName>_VERSION_MINOR``
  如果提供了，为次版本，否则为0
``<PackageName>_VERSION_PATCH``
  如果提供了，为补丁版本，否则为0
``<PackageName>_VERSION_TWEAK``
  如果提供了，为调整版本，否则为0
``<PackageName>_VERSION_COUNT``
  版本分量数目，0至4

并加载相应的包配置文件。

.. note::
  虽然版本匹配的确切行为由各个包自行决定，但许多包会使用\
  :command:`write_basic_package_version_file`\ 命令来提供这一逻辑。该命令生成的版本\
  检查脚本在处理版本范围时存在一些值得注意的事项：

  * 版本范围的上限对可接受的版本起到严格限制作用。因此，当请求版本为\ ``1.4.0``\ 时，版本为\
    ``1.6.0``\ 且宣称具备“主版本相同”兼容性的包可能会满足需求；但如果请求的版本范围是\
    ``1.4.0...1.5.0``，则同样的包会被拒绝。

  * 版本范围的两端都必须与包所宣称的兼容级别相匹配。例如，如果一个包宣称具备“主版本和次版本相同”\
    的兼容性，那么请求版本范围为\ ``1.4.0...<1.5.5``\ 或\ ``1.4.0...1.5.0``\ 时，即便\
    该包的版本是\ ``1.4.1``，也会被拒绝。

  因此，无法使用版本范围来扩大可接受的兼容包版本范围。

.. _`cps version selection`:

|CPS|
"""""

对于符合\ |CPS|\ 的包配置文件，CMake会依据一组已知的版本模式来检查包的版本号。目前，认可的\
版本模式如下：

  ``simple``
    版本号是一个整数元组，后面可跟一个可选的尾随段，在进行版本比较时会忽略该尾随段。

  ``custom``
    版本号的解释机制未作明确规定。要使包被接受，版本字符串必须完全匹配。

有关每种版本模式的更详细解释以及如何进行相应比较，请参考\ |cps-version_schema|_。请注意，\
该规范中可能包含CMake不支持的版本模式。

除了包的\ ``version``\ 之外，CPS（通用包规范）允许包可选地指定一个\ |cps-compat_version|_，\
它是该包能够提供兼容支持的最旧版本。也就是说，该包保证期望使用\ ``compat_version``\ 的使用者\
即使在包的实际版本更新的情况下也应该能够使用这个包。如果未指定\ ``compat_version``，则默认\
其值等于包的版本号，即不提供向后兼容性。

.. TODO Rework the preceding paragraph when COMPAT_VERSION has broader support
        in CMake.

当一个包使用了已知的版本模式时，CMake将根据以下规则来确定该包是否可接受：

* 如果指定了\ ``EXACT``\ 选项，或者该包未提供\ ``compat_version``，则该包的\ ``version``\
  必须与所请求的版本完全相等。

* 否则：

  * 该包的\ ``version``\ 必须大于或等于所请求的（最低）版本，并且

  * 该包的\ ``compat_version``\ 必须小于或等于所请求的（最低）版本，并且

  * 如果指定了请求的最大版本号，那么它必须大于（或者等于，具体取决于最大版本号指定的是包含\
    还是排除）该包的\ ``version``。

.. note::
  选择这种范围匹配的实现方式，是为了尽可能贴近\ :command:`write_basic_package_version_file`\
  命令的行为，不过不会出现范围过宽而匹配不到任何内容的情况。

对于使用\ ``simple``\ 版本模式的包，如果其版本号符合要求，则会设置以下变量：

``<PackageName>_VERSION``
  完整提供的版本字符串
``<PackageName>_VERSION_MAJOR``
  如果提供了主版本号，则为该主版本号，否则为0
``<PackageName>_VERSION_MINOR``
  如果提供了次版本号，则为该次版本号，否则为0
``<PackageName>_VERSION_PATCH``
  如果提供了补丁版本号，则为该补丁版本号，否则为0
``<PackageName>_VERSION_TWEAK``
  如果提供了微调版本号，则为该微调版本号，否则为0
``<PackageName>_VERSION_COUNT``
  版本组件的数量，非负整数

包文件接口变量
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

在加载查找模块或CMake脚本配置文件时，\ ``find_package``\ 定义了一些变量来提供调用参数的信息（并在\
返回之前恢复它们的原始状态）：

``CMAKE_FIND_PACKAGE_NAME``
  要搜索的\ ``<PackageName>``
``<PackageName>_FIND_REQUIRED``
  如果提供了\ ``REQUIRED``\ 选项，则为True
``<PackageName>_FIND_QUIETLY``
  如果提供了\ ``QUIET``\ 选项，则为True
``<PackageName>_FIND_REGISTRY_VIEW``
  如果指定了\ ``REGISTRY_VIEW``\ 选项，则返回请求视图
``<PackageName>_FIND_VERSION``
  完整请求的版本字符串
``<PackageName>_FIND_VERSION_MAJOR``
  如有请求，为主版本，否则为0
``<PackageName>_FIND_VERSION_MINOR``
  如有请求，为次版本，否则为0
``<PackageName>_FIND_VERSION_PATCH``
  如有请求，为补丁版本，否则为0
``<PackageName>_FIND_VERSION_TWEAK``
  如有请求，为调整版本，否则为0
``<PackageName>_FIND_VERSION_COUNT``
  版本组件数量，0至4
``<PackageName>_FIND_VERSION_EXACT``
  如果给出了\ ``EXACT``\ 选项，返回True
``<PackageName>_FIND_COMPONENTS``
  指定组件列表（必需和可选）
``<PackageName>_FIND_REQUIRED_<c>``
  如果组件\ ``<c>``\ 必需，返回True；如果组件\ ``<c>``\ 可选，返回false

如果指定了版本范围，上述版本变量中的值将基于版本范围的下限。这是为了保持与未实现的包的兼容性，\
以期望的版本范围。此外，版本范围由以下变量描述：

``<PackageName>_FIND_VERSION_RANGE``
  完整请求的版本范围字符串
``<PackageName>_FIND_VERSION_RANGE_MIN``
  这指定是包含还是排除版本范围的下限。目前，\ ``INCLUDE``\ 是唯一支持的值。

``<PackageName>_FIND_VERSION_RANGE_MAX``
  此参数指定是否包含或排除版本范围的上限。此变量的可能值为\ ``INCLUDE``\ 或\ ``EXCLUDE``。

``<PackageName>_FIND_VERSION_MIN``
  下限版本字符串范围的完整请求
``<PackageName>_FIND_VERSION_MIN_MAJOR``
  如有请求，则为下限的主版本，否则为0
``<PackageName>_FIND_VERSION_MIN_MINOR``
  如有请求，则为下限的次版本，否则为0
``<PackageName>_FIND_VERSION_MIN_PATCH``
  如有请求，则为下限的补丁版本，否则为0
``<PackageName>_FIND_VERSION_MIN_TWEAK``
  如有请求，则为下限的调整版本，否则为0
``<PackageName>_FIND_VERSION_MIN_COUNT``
  下限版本的组件数量，0到4

``<PackageName>_FIND_VERSION_MAX``
  完整请求的版本字符串范围的上限
``<PackageName>_FIND_VERSION_MAX_MAJOR``
  如果需要，则为上限的主版本号，否则为0
``<PackageName>_FIND_VERSION_MAX_MINOR``
  如果需要，则为上限的次版本号，否则为0
``<PackageName>_FIND_VERSION_MAX_PATCH``
  如果需要，则为上限的补丁版本号，否则为0
``<PackageName>_FIND_VERSION_MAX_TWEAK``
  如果需要，则为上限的调整版本号，否则为0
``<PackageName>_FIND_VERSION_MAX_COUNT``
  上限版本的组件数量，0到4

无论指定的是单个版本还是版本范围，都将定义\ ``<PackageName>_FIND_VERSION_COMPLETE``\
变量，该变量将保存指定的完整版本字符串。

在模块模式下，加载的查找模块负责执行由这些变量详细描述的请求；详情参见查找模块。在配置模式下，\
``find_package``\ 自动处理\ ``REQUIRED``、\ ``QUIET``\ 和\ ``<version>``\ 选项，但\
将其留给包配置文件，以对包有意义的方式处理组件。包配置文件可以将\ ``<PackageName>_FOUND``\
设置为false，以告诉\ ``find_package``\ 组件需求不满足。

CPS传递依赖
^^^^^^^^^^^^^^^^^^^^^^^^^^^

一个符合\ |CPS|\ 规范的包描述包含一个或多个组件，这些组件可能依赖于包内部或外部的其他组件。\
当需要外部组件时，提供该组件的包会被记录为包的包级依赖。此外，所需组件的集合通常会在该外部包\
需求中注明。

在CMake脚本包描述中，通常会使用\ :command:`find_dependency`\ 命令来处理传递依赖，而CMake\
本身则通过内部嵌套的\ ``find_package``\ 调用来处理CPS的传递依赖。这个调用可以通过\ *另一个*\
CPS包或CMake脚本包来解析CPS包依赖。处理CPS组件依赖的方式有一些需要注意的事项。

当解析传递依赖的候选者是另一个CPS包时，事情很简单；\ ``COMPONENTS``\ 和CPS的“组件”可以直接\
比较（并且实际上与CMake的“导入目标”是同义词）。然而，CMake脚本包通常会\（并且经常这样做）检查\
是否找到了所需的组件，无论该包是否描述了单独的组件。此外，即使那些确实描述了组件的包，通常也\
不具有与CPS中常见的导入目标相同的关联性。因此，将CPS包声明的所需组件集合传递给\ ``COMPONENTS``\
会导致解析依赖时出现不必要的失败。

为了解决这个问题，如果解析CPS传递依赖的候选者是CMake脚本包，CMake会将消费CPS包声明的所需组件\
作为\ ``OPTIONAL_COMPONENTS``\ 传递，并执行一个单独的内部检查，以确保候选包提供了所需的\
导入目标。这些目标必须命名为\ ``<PackageName>::<ComponentName>``，以符合CPS的约定，否则\
检查会认为该包未找到。

.. _CPS: https://cps-org.github.io/cps/
.. |CPS| replace:: Common Package Specification

.. _cps-compat_version: https://cps-org.github.io/cps/schema.html#compat-version
.. |cps-compat_version| replace:: ``compat_version``

.. _cps-version_schema: https://cps-org.github.io/cps/schema.html#version-schema
.. |cps-version_schema| replace:: ``version_schema``
