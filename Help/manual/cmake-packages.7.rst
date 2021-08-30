.. cmake-manual-description: CMake Packages Reference

cmake-packages(7)
*****************

.. only:: html

   .. contents::

引言
============

包为基于CMake的构建系统提供依赖信息。包可以通过 :command:`find_package` 命令找到。:command:`find_package` 找到的结果要么是一组 :prop_tgt:`IMPORTED` 目标，要么是一组构建相关信息的对应变量。

使用包
==============

CMake直接支持 `配置文件包`_ 和 `Find模块包`_ 这两种形式的包。还可以通过 :module:`FindPkgConfig` 模块提供对 ``pkg-config`` 包的间接支持。所有情况下调用 :command:`find_package` 的方法都是一样的：

.. code-block:: cmake

  find_package(Qt4 4.7.0 REQUIRED) # CMake provides a Qt4 find-module
  find_package(Qt5Core 5.1.0 REQUIRED) # Qt provides a Qt5 package config file.
  find_package(LibXml2 REQUIRED) # Use pkg-config via the LibXml2 find-module

如果已知upstream提供了一个包配置文件，并且只应该使用这个包配置文件，则 ``CONFIG`` 关键字可以传递给 :command:`find_package`：

.. code-block:: cmake

  find_package(Qt5Core 5.1.0 CONFIG REQUIRED)
  find_package(Qt5Gui 5.1.0 CONFIG)

类似地，``MODULE`` 关键字要求只使用find-module：

.. code-block:: cmake

  find_package(Qt4 4.7.0 MODULE REQUIRED)

如果找不到包，显式指定包类型可以改进显示给用户的错误消息。

这两种类型的包还支持指定包的组件，可以列在 ``REQUIRED`` 关键字的后面：

.. code-block:: cmake

  find_package(Qt5 5.1.0 CONFIG REQUIRED Widgets Xml Sql)

或者作为单独的 ``COMPONENTS`` 列表：

.. code-block:: cmake

  find_package(Qt5 5.1.0 COMPONENTS Widgets Xml Sql)

或者作为单独的 ``OPTIONAL_COMPONENTS`` 列表：

.. code-block:: cmake

  find_package(Qt5 5.1.0 COMPONENTS Widgets
                         OPTIONAL_COMPONENTS Xml Sql
  )

``COMPONENTS`` 和 ``OPTIONAL_COMPONENTS`` 的处理由包定义。

通过将 :variable:`CMAKE_DISABLE_FIND_PACKAGE_<PackageName>` 变量设置为 ``TRUE``，``<PackageName>`` 包将不会被搜索，并且始终为 ``NOTFOUND``。

.. _`Config File Packages`:

配置文件包
--------------------

配置文件包是上游提供给下游使用的一组文件。如 :command:`find_package` 文档所述，CMake会在多个位置搜索包配置文件。若想让 :manual:`cmake(1)` 在非标准前缀中搜索包，最简单方法是设置 ``CMAKE_PREFIX_PATH`` 缓存变量。

配置文件包由上游供应提供，作为开发包的一部分，也就是说，它们由头文件或者其他为帮助下游使用包而提供的任何文件组成。

当使用配置文件包时，还会自动设置一组提供包状态信息的变量。根据是否找到了包，``<PackageName>_FOUND`` 变量被设置为true或者false。而 ``<PackageName>_DIR`` 缓存变量则被设置为包配置文件的位置。

Find模块包
--------------------

find模块是一个包含一组规则的文件，用于查找依赖项所需的部分，主要是头文件和库。通常，当上游不是用CMake构建的，或者没有足够的CMake感知来提供包配置文件时，就需要一个find模块。与包配置文件不同，它不是由上游提供的，而是由下游使用特定于平台的提示来猜测文件的位置。

与上游提供的包配置文件的情况不同，没有单个引用点标识正在找到的包，因此 :command:`find_package` 命令不会自动设置 ``<PackageName>_FOUND`` 变量。但是，它仍然可以依约定设置，并且应该由Find模块的作者设置。类似地，没有 ``<PackageName>_DIR`` 变量，但是每个构件，例如库位置和头文件位置，将提供一个单独的缓存变量。

有关创建Find模块文件的更多信息，请参考 :manual:`cmake-developer(7)` 手册。

包布局
==============

配置文件包由 `包配置文件`_ 和可选的由项目分发方提供的 `包版本文件`_ 组成。

包配置文件
--------------------------

考虑一个安装了以下文件的项目 ``Foo``： ::

  <prefix>/include/foo-1.2/foo.h
  <prefix>/lib/foo-1.2/libfoo.a

它还可以提供一个CMake包配置文件： ::

  <prefix>/lib/cmake/foo-1.2/FooConfig.cmake

内容是定义  :prop_tgt:`IMPORTED` 目标，或定义变量，如：

.. code-block:: cmake

  # ...
  # (compute PREFIX relative to file location)
  # ...
  set(Foo_INCLUDE_DIRS ${PREFIX}/include/foo-1.2)
  set(Foo_LIBRARIES ${PREFIX}/lib/foo-1.2/libfoo.a)

如果另一个项目希望使用 ``Foo``，它只需要找到 ``FooConfig.cmake`` 文件，并加载它以获得它所需要的关于包内容位置的所有信息。因为包配置文件是由包安装提供的，所以它已经知道所有文件的位置。

可以用 :command:`find_package` 命令搜索包配置文件。该命令构造一组安装前缀，并在几个位置的每个前缀下搜索。给定名称 ``Foo``，它查找名为 ``FooConfig.cmake`` 或 ``foo-config.cmake`` 的文件。完整的位置集合在 :command:`find_package` 命令文档中指定。其中一个地方是： ::

 <prefix>/lib/cmake/Foo*/

其中 ``Foo*`` 是不区分大小写的通配符表达式。在我们的示例中，通配符表达式将匹配 ``<prefix>/lib/cmake/foo-1.2``，并将找到包配置文件。

一旦找到，立即加载包配置文件。它和一个包版本文件一起包含了项目使用该包所需的所有信息。

包版本文件
--------------------

当 :command:`find_package` 命令找到一个候选包配置文件时，它会在它旁边查找版本文件。加载版本文件以测试包版本是否与所请求的版本匹配。如果版本文件有版本要求，则接受配置文件。否则将被忽略。

包版本文件的名称必须与包配置文件的名称匹配，但是在扩展名 ``.cmake`` 之前附加 ``-version`` 或 ``Version``。例如，文件： ::

 <prefix>/lib/cmake/foo-1.3/foo-config.cmake
 <prefix>/lib/cmake/foo-1.3/foo-config-version.cmake

和： ::

 <prefix>/lib/cmake/bar-4.2/BarConfig.cmake
 <prefix>/lib/cmake/bar-4.2/BarConfigVersion.cmake

是每对包配置文件和对应的包版本文件。

当 :command:`find_package` 命令加载一个版本文件时，会首先设置以下变量：

``PACKAGE_FIND_NAME``
 ``<包名>``

``PACKAGE_FIND_VERSION``
 获取的完整版本字符串

``PACKAGE_FIND_VERSION_MAJOR``
 获取成功时为主版本号，失败则为0

``PACKAGE_FIND_VERSION_MINOR``
 获取成功时为次版本号，失败则为0

``PACKAGE_FIND_VERSION_PATCH``
 获取成功时为补丁版本号，失败则为0

``PACKAGE_FIND_VERSION_TWEAK``
 获取成功时为修订版本号，失败则为0

``PACKAGE_FIND_VERSION_COUNT``
 版本号数量，取值范围0至4

版本文件必须使用这些变量来检查它是否与请求的版本兼容或完全匹配，并设置以下变量：

``PACKAGE_VERSION``
 完整提供的版本字符串

``PACKAGE_VERSION_EXACT``
 如果版本完全匹配则为True

``PACKAGE_VERSION_COMPATIBLE``
 如果版本兼容则为True

``PACKAGE_VERSION_UNSUITABLE``
 如果不适配任何版本，则为True

版本文件被加载在一个嵌套的作用域中，因此他们可以自由地设置任何他们想要的变量作为计算的一部分。当版本文件完成并检查了输出变量后，find_package命令会清空作用域。当版本文件声明与请求的版本匹配可接受时，find_package命令设置以下变量供项目使用：

``<包名>_VERSION``
 完整的版本字符串

``<包名>_VERSION_MAJOR``
 主版本号，若未提供，则为0

``<包名>_VERSION_MINOR``
 次版本号，若未提供，则为0

``<包名>_VERSION_PATCH``
 补丁版本号，若未提供，则为0

``<包名>_VERSION_TWEAK``
 修订版本号，若未提供，则为0

``<包名>_VERSION_COUNT``
 提供的版本号数量，取值范围0至4

这些变量报告实际找到的包的版本。其名称中的 ``<包名>`` 部分与 :command:`find_package` 命令的参数相匹配。

.. _`Creating Packages`:

创建包
=================

通常，上游依赖于CMake本身，可以使用一些CMake工具来创建包文件。譬如一个提供单个共享库的上流：

.. code-block:: cmake

  project(UpstreamLib)

  set(CMAKE_INCLUDE_CURRENT_DIR ON)
  set(CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE ON)

  set(Upstream_VERSION 3.4.1)

  include(GenerateExportHeader)

  add_library(ClimbingStats SHARED climbingstats.cpp)
  generate_export_header(ClimbingStats)
  set_property(TARGET ClimbingStats PROPERTY VERSION ${Upstream_VERSION})
  set_property(TARGET ClimbingStats PROPERTY SOVERSION 3)
  set_property(TARGET ClimbingStats PROPERTY
    INTERFACE_ClimbingStats_MAJOR_VERSION 3)
  set_property(TARGET ClimbingStats APPEND PROPERTY
    COMPATIBLE_INTERFACE_STRING ClimbingStats_MAJOR_VERSION
  )

  install(TARGETS ClimbingStats EXPORT ClimbingStatsTargets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include
  )
  install(
    FILES
      climbingstats.h
      "${CMAKE_CURRENT_BINARY_DIR}/climbingstats_export.h"
    DESTINATION
      include
    COMPONENT
      Devel
  )

  include(CMakePackageConfigHelpers)
  write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/ClimbingStats/ClimbingStatsConfigVersion.cmake"
    VERSION ${Upstream_VERSION}
    COMPATIBILITY AnyNewerVersion
  )

  export(EXPORT ClimbingStatsTargets
    FILE "${CMAKE_CURRENT_BINARY_DIR}/ClimbingStats/ClimbingStatsTargets.cmake"
    NAMESPACE Upstream::
  )
  configure_file(cmake/ClimbingStatsConfig.cmake
    "${CMAKE_CURRENT_BINARY_DIR}/ClimbingStats/ClimbingStatsConfig.cmake"
    COPYONLY
  )

  set(ConfigPackageLocation lib/cmake/ClimbingStats)
  install(EXPORT ClimbingStatsTargets
    FILE
      ClimbingStatsTargets.cmake
    NAMESPACE
      Upstream::
    DESTINATION
      ${ConfigPackageLocation}
  )
  install(
    FILES
      cmake/ClimbingStatsConfig.cmake
      "${CMAKE_CURRENT_BINARY_DIR}/ClimbingStats/ClimbingStatsConfigVersion.cmake"
    DESTINATION
      ${ConfigPackageLocation}
    COMPONENT
      Devel
  )

:module:`CMakePackageConfigHelpers` 模块提供了一个宏来创建一个简单的 ``ConfigVersion.cmake`` 文件，作用是设置包的版本。当调用 :command:`find_package` 时，CMake读取它，以确定与请求版本的兼容性，并设置一些版本特定变量如 ``<PackageName>_VERSION``、``<PackageName>_VERSION_MAJOR``、``<PackageName>_VERSION_MINOR`` 等。:command:`install(EXPORT)` 命令用于导出 ``ClimbingStatsTargets.cmake`` 导出集中的目标，该导出集之前由 :command:`install(TARGETS)` 命令定义。这个命令生成的 ``ClimbingStatsTargets.cmake`` 文件包含适用于下游的 :prop_tgt:`IMPORTED` 目标，并会安装到 ``lib/cmake/ClimbingStats``。生成的 ``ClimbingStatsConfigVersion.cmake`` 和 ``cmake/ClimbingStatsConfig.cmake`` 会安装到相同的位置以完成包的安装。

生成的 :prop_tgt:`IMPORTED` 目标设置了适当的属性来定义它们的 :ref:`使用需求 <Target Usage Requirements>`，例如 :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`、:prop_tgt:`INTERFACE_COMPILE_DEFINITIONS` 及其他相关的内置 ``INTERFACE_`` 属性。在 :prop_tgt:`COMPATIBLE_INTERFACE_STRING` 和其他 :ref:`Compatible Interface Properties` 中列出的自定义属性的 ``INTERFACE`` 变体也会传播到生成的 :prop_tgt:`IMPORTED` 目标。在上面的例子中，``ClimbingStats_MAJOR_VERSION`` 被定义为一个字符串，它必须在任何依赖的依赖项之间兼容。在 ``ClimbingStats`` 的这个和下一个版本中都设置这个自定义属性的情况下，如果试图同时使用版本3和版本4，:manual:`cmake(1)` 将发出诊断。如果包的不同主要版本互不兼容，就可以选择使用这种模式。

导出用于安装的目标时指定一个带双冒号的 ``NAMESPACE`` 。当下游使用 :command:`target_link_libraries` 命令时，这种双冒号的约定给CMake一个提示：该名称是一个 :prop_tgt:`IMPORTED` 目标。这样，如果找不到相应的包，CMake就可以发出诊断。

在本例中，当使用 :command:`install(TARGETS)` 时指定了 ``INCLUDES DESTINATION``。这将会令 ``IMPORTED`` 目标的 :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` 属性被 :variable:`CMAKE_INSTALL_PREFIX` 中的 ``include`` 目录填充。当下游使用 ``IMPORTED`` 目标时，它会自动使用来自该属性的项。

创建包配置文件
-------------------------------------

在这种情况下，``ClimbingStatsConfig.cmake`` 文件可以像下面那样简单：

.. code-block:: cmake

  include("${CMAKE_CURRENT_LIST_DIR}/ClimbingStatsTargets.cmake")

因为这允许下游使用 ``IMPORTED`` 的目标。如果 ``ClimbingStats`` 包需要提供任何宏，那么它们应该在一个单独的文件中，该文件与 ``ClimbingStatsConfig.cmake`` 安装在相同的位置，并在那里被引用。

这也可以扩展到覆盖的依赖项：

.. code-block:: cmake

  # ...
  add_library(ClimbingStats SHARED climbingstats.cpp)
  generate_export_header(ClimbingStats)

  find_package(Stats 2.6.4 REQUIRED)
  target_link_libraries(ClimbingStats PUBLIC Stats::Types)

由于 ``Stats::Types`` 目标是 ``ClimbingStats`` 的 ``PUBLIC`` 依赖项，下游也必须找到 ``Stats`` 包并链接到 ``Stats::Types`` 库。 ``Stats`` 包应该在 ``ClimbingStatsConfig.cmake`` 文件中找到，以此确保这一点。来自 :module:`CMakeFindDependencyMacro`  的 ``find_dependency`` 宏可以通过传播包是 ``REQUIRED`` 还是 ``QUIET`` 等来帮助解决这个问题。一个包的所有 ``REQUIRED`` 依赖项都应该在 ``Config.cmake`` 文件中找到：

.. code-block:: cmake

  include(CMakeFindDependencyMacro)
  find_dependency(Stats 2.6.4)

  include("${CMAKE_CURRENT_LIST_DIR}/ClimbingStatsTargets.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/ClimbingStatsMacros.cmake")

如果没有找到依赖项，``find_dependency`` 宏还会将 ``ClimbingStats_FOUND`` 设置为 ``False`` ，并同时抛出一个诊断：没有 ``Stats`` 包就不能使用 ``ClimbingStats`` 包。

如果在下游使用 :command:`find_package` 时指定了 ``COMPONENTS`` ，它们将在 ``<PackageName>_FIND_COMPONENTS`` 变量中列出。如果一个特定的组件是非可选的，那么 ``<PackageName>_FIND_REQUIRED_<comp>``  将为真。这可以通过包配置文件中的逻辑进行测试：

.. code-block:: cmake

  include(CMakeFindDependencyMacro)
  find_dependency(Stats 2.6.4)

  include("${CMAKE_CURRENT_LIST_DIR}/ClimbingStatsTargets.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/ClimbingStatsMacros.cmake")

  set(_supported_components Plot Table)

  foreach(_comp ${ClimbingStats_FIND_COMPONENTS})
    if (NOT ";${_supported_components};" MATCHES _comp)
      set(ClimbingStats_FOUND False)
      set(ClimbingStats_NOT_FOUND_MESSAGE "Unsupported component: ${_comp}")
    endif()
    include("${CMAKE_CURRENT_LIST_DIR}/ClimbingStats${_comp}Targets.cmake")
  endforeach()

此处，``ClimbingStats_NOT_FOUND_MESSAGE`` 被设置为一个诊断，意思是由于指定了无效组件而无法找到包。在 ``_FOUND`` 变量设置为 ``False`` 的任何情况下，都可以设置此消息变量，并显示给用户。

Creating a Package Configuration File for the Build Tree
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The :command:`export(EXPORT)` command creates an :prop_tgt:`IMPORTED` targets
definition file which is specific to the build-tree, and is not relocatable.
This can similarly be used with a suitable package configuration file and
package version file to define a package for the build tree which may be used
without installation.  Consumers of the build tree can simply ensure that the
:variable:`CMAKE_PREFIX_PATH` contains the build directory, or set the
``ClimbingStats_DIR`` to ``<build_dir>/ClimbingStats`` in the cache.

.. _`Creating Relocatable Packages`:

Creating Relocatable Packages
-----------------------------

A relocatable package must not reference absolute paths of files on
the machine where the package is built that will not exist on the
machines where the package may be installed.

Packages created by :command:`install(EXPORT)` are designed to be relocatable,
using paths relative to the location of the package itself.  When defining
the interface of a target for ``EXPORT``, keep in mind that the include
directories should be specified as relative paths which are relative to the
:variable:`CMAKE_INSTALL_PREFIX`:

.. code-block:: cmake

  target_include_directories(tgt INTERFACE
    # Wrong, not relocatable:
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/include/TgtName>
  )

  target_include_directories(tgt INTERFACE
    # Ok, relocatable:
    $<INSTALL_INTERFACE:include/TgtName>
  )

The ``$<INSTALL_PREFIX>``
:manual:`generator expression <cmake-generator-expressions(7)>` may be used as
a placeholder for the install prefix without resulting in a non-relocatable
package.  This is necessary if complex generator expressions are used:

.. code-block:: cmake

  target_include_directories(tgt INTERFACE
    # Ok, relocatable:
    $<INSTALL_INTERFACE:$<$<CONFIG:Debug>:$<INSTALL_PREFIX>/include/TgtName>>
  )

This also applies to paths referencing external dependencies.
It is not advisable to populate any properties which may contain
paths, such as :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` and
:prop_tgt:`INTERFACE_LINK_LIBRARIES`, with paths relevant to dependencies.
For example, this code may not work well for a relocatable package:

.. code-block:: cmake

  target_link_libraries(ClimbingStats INTERFACE
    ${Foo_LIBRARIES} ${Bar_LIBRARIES}
    )
  target_include_directories(ClimbingStats INTERFACE
    "$<INSTALL_INTERFACE:${Foo_INCLUDE_DIRS};${Bar_INCLUDE_DIRS}>"
    )

The referenced variables may contain the absolute paths to libraries
and include directories **as found on the machine the package was made on**.
This would create a package with hard-coded paths to dependencies and not
suitable for relocation.

Ideally such dependencies should be used through their own
:ref:`IMPORTED targets <Imported Targets>` that have their own
:prop_tgt:`IMPORTED_LOCATION` and usage requirement properties
such as :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` populated
appropriately.  Those imported targets may then be used with
the :command:`target_link_libraries` command for ``ClimbingStats``:

.. code-block:: cmake

  target_link_libraries(ClimbingStats INTERFACE Foo::Foo Bar::Bar)

With this approach the package references its external dependencies
only through the names of :ref:`IMPORTED targets <Imported Targets>`.
When a consumer uses the installed package, the consumer will run the
appropriate :command:`find_package` commands (via the ``find_dependency``
macro described above) to find the dependencies and populate the
imported targets with appropriate paths on their own machine.

Unfortunately many :manual:`modules <cmake-modules(7)>` shipped with
CMake do not yet provide :ref:`IMPORTED targets <Imported Targets>`
because their development pre-dated this approach.  This may improve
incrementally over time.  Workarounds to create relocatable packages
using such modules include:

* When building the package, specify each ``Foo_LIBRARY`` cache
  entry as just a library name, e.g. ``-DFoo_LIBRARY=foo``.  This
  tells the corresponding find module to populate the ``Foo_LIBRARIES``
  with just ``foo`` to ask the linker to search for the library
  instead of hard-coding a path.

* Or, after installing the package content but before creating the
  package installation binary for redistribution, manually replace
  the absolute paths with placeholders for substitution by the
  installation tool when the package is installed.

.. _`Package Registry`:

Package Registry
================

CMake provides two central locations to register packages that have
been built or installed anywhere on a system:

* `User Package Registry`_
* `System Package Registry`_

The registries are especially useful to help projects find packages in
non-standard install locations or directly in their own build trees.
A project may populate either the user or system registry (using its own
means, see below) to refer to its location.
In either case the package should store at the registered location a
`包配置文件`_ (``<PackageName>Config.cmake``) and optionally a
`包版本文件`_ (``<PackageName>ConfigVersion.cmake``).

The :command:`find_package` command searches the two package registries
as two of the search steps specified in its documentation.  If it has
sufficient permissions it also removes stale package registry entries
that refer to directories that do not exist or do not contain a matching
package configuration file.

.. _`User Package Registry`:

User Package Registry
---------------------

The User Package Registry is stored in a per-user location.
The :command:`export(PACKAGE)` command may be used to register a project
build tree in the user package registry.  CMake currently provides no
interface to add install trees to the user package registry.  Installers
must be manually taught to register their packages if desired.

On Windows the user package registry is stored in the Windows registry
under a key in ``HKEY_CURRENT_USER``.

A ``<PackageName>`` may appear under registry key::

  HKEY_CURRENT_USER\Software\Kitware\CMake\Packages\<PackageName>

as a ``REG_SZ`` value, with arbitrary name, that specifies the directory
containing the package configuration file.

On UNIX platforms the user package registry is stored in the user home
directory under ``~/.cmake/packages``.  A ``<PackageName>`` may appear under
the directory::

  ~/.cmake/packages/<PackageName>

as a file, with arbitrary name, whose content specifies the directory
containing the package configuration file.

.. _`System Package Registry`:

System Package Registry
-----------------------

The System Package Registry is stored in a system-wide location.
CMake currently provides no interface to add to the system package registry.
Installers must be manually taught to register their packages if desired.

On Windows the system package registry is stored in the Windows registry
under a key in ``HKEY_LOCAL_MACHINE``.  A ``<PackageName>`` may appear under
registry key::

  HKEY_LOCAL_MACHINE\Software\Kitware\CMake\Packages\<PackageName>

as a ``REG_SZ`` value, with arbitrary name, that specifies the directory
containing the package configuration file.

There is no system package registry on non-Windows platforms.

.. _`Disabling the Package Registry`:

Disabling the Package Registry
------------------------------

In some cases using the Package Registries is not desirable. CMake
allows one to disable them using the following variables:

* The :command:`export(PACKAGE)` command does not populate the user
  package registry when :policy:`CMP0090` is set to ``NEW`` unless the
  :variable:`CMAKE_EXPORT_PACKAGE_REGISTRY` variable explicitly enables it.
  When :policy:`CMP0090` is *not* set to ``NEW`` then
  :command:`export(PACKAGE)` populates the user package registry unless
  the :variable:`CMAKE_EXPORT_NO_PACKAGE_REGISTRY` variable explicitly
  disables it.
* :variable:`CMAKE_FIND_USE_PACKAGE_REGISTRY` disables the
  User Package Registry in all the :command:`find_package` calls when
  set to ``FALSE``.
* Deprecated :variable:`CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY` disables the
  User Package Registry in all the :command:`find_package` calls when set
  to ``TRUE``. This variable is ignored when
  :variable:`CMAKE_FIND_USE_PACKAGE_REGISTRY` has been set.
* :variable:`CMAKE_FIND_PACKAGE_NO_SYSTEM_PACKAGE_REGISTRY` disables
  the System Package Registry in all the :command:`find_package` calls.

Package Registry Example
------------------------

A simple convention for naming package registry entries is to use content
hashes.  They are deterministic and unlikely to collide
(:command:`export(PACKAGE)` uses this approach).
The name of an entry referencing a specific directory is simply the content
hash of the directory path itself.

If a project arranges for package registry entries to exist, such as::

 > reg query HKCU\Software\Kitware\CMake\Packages\MyPackage
 HKEY_CURRENT_USER\Software\Kitware\CMake\Packages\MyPackage
  45e7d55f13b87179bb12f907c8de6fc4 REG_SZ c:/Users/Me/Work/lib/cmake/MyPackage
  7b4a9844f681c80ce93190d4e3185db9 REG_SZ c:/Users/Me/Work/MyPackage-build

or::

 $ cat ~/.cmake/packages/MyPackage/7d1fb77e07ce59a81bed093bbee945bd
 /home/me/work/lib/cmake/MyPackage
 $ cat ~/.cmake/packages/MyPackage/f92c1db873a1937f3100706657c63e07
 /home/me/work/MyPackage-build

then the ``CMakeLists.txt`` code:

.. code-block:: cmake

  find_package(MyPackage)

will search the registered locations for package configuration files
(``MyPackageConfig.cmake``).  The search order among package registry
entries for a single package is unspecified and the entry names
(hashes in this example) have no meaning.  Registered locations may
contain package version files (``MyPackageConfigVersion.cmake``) to
tell :command:`find_package` whether a specific location is suitable
for the version requested.

Package Registry Ownership
--------------------------

Package registry entries are individually owned by the project installations
that they reference.  A package installer is responsible for adding its own
entry and the corresponding uninstaller is responsible for removing it.

The :command:`export(PACKAGE)` command populates the user package registry
with the location of a project build tree.  Build trees tend to be deleted by
developers and have no "uninstall" event that could trigger removal of their
entries.  In order to keep the registries clean the :command:`find_package`
command automatically removes stale entries it encounters if it has sufficient
permissions.  CMake provides no interface to remove an entry referencing an
existing build tree once :command:`export(PACKAGE)` has been invoked.
However, if the project removes its package configuration file from the build
tree then the entry referencing the location will be considered stale.
