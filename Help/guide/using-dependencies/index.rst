使用依赖项指南
************************

.. only:: html

   .. contents::

引言
============

项目将经常依赖于其他项目、资产和工件。
CMake提供了许多方法来将这些内容合并到构建中。
项目和用户可以灵活地选择最适合他们需求的方法。

将依赖项引入构建的主要方法是\ :command:`find_package`\ 命令和\ :module:`FetchContent`\ 模块。
有时也会使用\ :module:`FindPkgConfig`\ 模块，尽管它缺少其他两个模块的一些集成，在本指南中不会进一步讨论。

依赖项也可以由自定义\ :ref:`依赖提供器 <dependency_providers>`\ 提供。
这可能是第三方的包管理器，也可能是由开发人员实现的定制代码。依赖提供器与上面提到的主要方法合作以扩展它们的灵活性。

.. _prebuilt_find_package:

利用\ ``find_package()``\ 来使用预构建包
================================================

项目所需的包可能已经构建好，并且在用户系统的某些位置可用。这个包可能也是由CMake构建的，也可能使用完全不同的构建系统。
它甚至可能只是一个根本不需要构建的文件集合。CMake为这些场景提供了\ :command:`find_package`\ 命令。
它搜索知名的位置，以及项目或用户提供的其他提示和路径。它还支持可选包组件和包。结果变量允许项目根据是否找到包或特定组件来定制其自己的行为。

在大多数情况下，项目通常应该使用\ :ref:`basic signature`。
大多数时候，这将只涉及包名，可能是版本约束，如果依赖不是可选的，则需要\ ``REQUIRED``\ 关键字。还可以指定一组包组件。

.. code-block:: cmake
  :caption: Examples of ``find_package()`` basic signature

  find_package(Catch2)
  find_package(GTest REQUIRED)
  find_package(Boost 1.79 COMPONENTS date_time)

:command:`find_package`\ 命令支持两种主要的搜索方法：

**配置模式**
  使用此方法，该命令将查找包本身通常提供的文件。这是两种方法中更可靠的一种，因为包的详细信息应该始终与包保持同步。

**模块模式**
  不是所有的包都是CMake感知的。许多不提供支持配置模式所需的文件。对于这种情况，Find模块文件可以由项目或CMake单独提供。
  Find模块通常是一种启发式实现，它知道包通常提供什么以及如何将包呈现给项目。因为Find模块通常是独立于包分发的，所以它们不那么可靠。
  它们通常是分开维护的，它们可能遵循不同的发布计划，所以它们很容易过时。

根据所使用的参数，:command:`find_package`\ 可以使用上述方法中的一个或两个。
通过将选项限制为基本签名，配置模式和模块模式都可以用来满足依赖关系。其他选项的存在可能会限制调用只能使用这两种方法中的一种，这可能会降低命令查找依赖项的能力。
有关这个复杂主题的详细信息，请参阅\ :command:`find_package`\ 文档。

对于这两种搜索方法，用户还可以在\ :manual:`cmake(1)`\ 命令行或\ :manual:`ccmake(1)`\ 或\ :manual:`cmake-gui(1)` UI工具中设置缓存变量，以影响和覆盖查找包的位置。
有关如何设置缓存变量的更多信息，请参阅\ :ref:`用户交互指南 <Setting Build Variables>`。

.. _Libraries providing Config-file packages:

配置文件包
--------------------

第三方提供与CMake一起使用的可执行文件、库、头文件和其他文件的首选方式是提供\ :ref:`配置文件 <Config File Packages>`。
这些是包附带的文本文件，它们定义了CMake目标、变量、命令等。配置文件是一个普通的CMake脚本，由\ :command:`find_package`\ 命令读入。

配置文件通常可以在名称与模式\ ``lib/cmake/<PackageName>``\ 匹配的目录中找到，尽管它们可能在其他位置（参见\ :ref:`search procedure`）。
``<PackageName>``\ 通常是\ :command:`find_package`\ 命令的第一个参数，甚至可能是唯一的参数。备选名称也可以用\ ``NAMES``\ 选项指定：

.. code-block:: cmake
  :caption: Providing alternative names when finding a package

  find_package(SomeThing
    NAMES
      SameThingOtherName   # Another name for the package
      SomeThing            # Also still look for its canonical name
  )

配置文件必须命名为\ ``<PackageName>Config.cmake``\ 或者\ ``<LowercasePackageName>-config.cmake``\ （前者用于本指南的其余部分，但两者都支持）。这个文件是CMake包的入口点。一个名为\ ``<PackageName>ConfigVersion.cmake``\ 的单独可选文件或\ ``<LowercasePackageName>-config-version.cmake``\ 也可能存在于同一个目录中。CMake使用此文件来确定包的版本是否满足调用\ :command:`find_package`\ 中包含的任何版本约束。调用\ :command:`find_package`\ 时指定版本是可选的，即使是\ ``<PackageName>ConfigVersion.cmake``\ 文件存在。

如果找到\ ``<PackageName>Config.cmake``\ 配置文件并且满足任何版本约束，:command:`find_package`\ 命令会认为找到的包是完整的，并假定整个包按照设计的那样完整。

可能有其他文件提供CMake命令或\ :ref:`imported targets`\ 供你使用。CMake不强制这些文件的任何命名约定。它们与使用CMake的\ :command:`include`\命令创建的主\ ``<PackageName>Config.cmake``\ 文件相关。``<PackageName>Config.cmake``\ 文件通常会为你包含这些，所以它们通常不需要任何额外的步骤，除了调用\ :command:`find_package`。

If the location of the package is in a
:ref:`directory known to CMake <search procedure>`, the
:command:`find_package` call should succeed.  The directories known to CMake
are platform-specific.  For example, packages installed on Linux with a
standard system package manager will be found in the ``/usr`` prefix
automatically.  Packages installed in ``Program Files`` on Windows will
similarly be found automatically.

Packages will not be found automatically without help if they are in
locations not known to CMake, such as ``/opt/mylib`` or ``$HOME/dev/prefix``.
This is a normal situation, and CMake provides several ways for users to
specify where to find such libraries.

The :variable:`CMAKE_PREFIX_PATH` variable may be
:ref:`set when invoking CMake <Setting Build Variables>`.
It is treated as a list of base paths in which to search for
:ref:`config files <Config File Packages>`.  A package installed in
``/opt/somepackage`` will typically install config files such as
``/opt/somepackage/lib/cmake/somePackage/SomePackageConfig.cmake``.
In that case, ``/opt/somepackage`` should be added to
:variable:`CMAKE_PREFIX_PATH`.

The environment variable ``CMAKE_PREFIX_PATH`` may also be populated with
prefixes to search for packages.  Like the ``PATH`` environment variable,
this is a list, but it needs to use the platform-specific environment variable
list item separator (``:`` on Unix and ``;`` on Windows).

The :variable:`CMAKE_PREFIX_PATH` variable provides convenience in cases
where multiple prefixes need to be specified, or when multiple packages
are available under the same prefix.  Paths to packages may also be
specified by setting variables matching ``<PackageName>_DIR``, such as
``SomePackage_DIR``.  Note that this is not a prefix, but should be a full
path to a directory containing a config-style package file, such as
``/opt/somepackage/lib/cmake/SomePackage`` in the above example.
See the :command:`find_package` documentation for other CMake variables and
environment variables that can affect the search.

.. _Libraries not Providing Config-file Packages:

Find Module Files
-----------------

Packages which do not provide config files can still be found with the
:command:`find_package` command, if a ``FindSomePackage.cmake`` file is
available.  These Find module files are different to config files in that:

#. Find module files should not be provided by the package itself.
#. The availability of a ``Find<PackageName>.cmake`` file does not indicate
   the availability of the package, or any particular part of the package.
#. CMake does not search the locations specified in the
   :variable:`CMAKE_PREFIX_PATH` variable for ``Find<PackageName>.cmake``
   files.  Instead, CMake searches for such files in the locations given
   by the :variable:`CMAKE_MODULE_PATH` variable.  It is common for users to
   set the :variable:`CMAKE_MODULE_PATH` when running CMake, and it is common
   for CMake projects to append to :variable:`CMAKE_MODULE_PATH` to allow use
   of local Find module files.
#. CMake ships ``Find<PackageName>.cmake`` files for some
   :manual:`third party packages <cmake-modules(7)>`.  These files are a
   maintenance burden for CMake, and it is not unusual for these to fall
   behind the latest releases of the packages they are associated with.
   In general, new Find modules are not added to CMake any more.  Projects
   should encourage the upstream packages to provide a config file where
   possible.  If that is unsuccessful, the project should provide its own
   Find module for the package.

See :ref:`Find Modules` for a detailed discussion of how to write a
Find module file.

.. _Imported Targets from Packages:

Imported Targets
----------------

Both config files and Find module files can define :ref:`Imported targets`.
These will typically have names of the form ``SomePrefix::ThingName``.
Where these are available, the project should prefer to use them instead of
any CMake variables that may also be provided.  Such targets typically carry
usage requirements and apply things like header search paths, compiler
definitions, etc. automatically to other targets that link to them (e.g. using
:command:`target_link_libraries`).  This is both more robust and more
convenient than trying to apply the same things manually using variables.
Check the documentation for the package or Find module to see what imported
targets it defines, if any.

Imported targets should also encapsulate any configuration-specific paths.
This includes the location of binaries (libraries, executables), compiler
flags, and any other configuration-dependent quantities.  Find modules may
be less reliable in providing these details than config files.

A complete example which finds a third party package and uses a library
from it might look like the following:

.. code-block:: cmake

  cmake_minimum_required(VERSION 3.10)
  project(MyExeProject VERSION 1.0.0)

  # Make project-provided Find modules available
  list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

  find_package(SomePackage REQUIRED)
  add_executable(MyExe main.cpp)
  target_link_libraries(MyExe PRIVATE SomePrefix::LibName)

Note that the above call to :command:`find_package` could be resolved by
a config file or a Find module.  It uses only the basic arguments supported
by the :ref:`basic signature`.  A ``FindSomePackage.cmake`` file in the
``${CMAKE_CURRENT_SOURCE_DIR}/cmake`` directory would allow the
:command:`find_package` command to succeed using module mode, for example.
If no such module file is present, the system would be searched for a config
file.


Downloading And Building From Source With ``FetchContent``
==========================================================

Dependencies do not necessarily have to be pre-built in order to use them
with CMake.  They can be built from sources as part of the main project.
The :module:`FetchContent` module provides functionality to download
content (typically sources, but can be anything) and add it to the main
project if the dependency also uses CMake.  The dependency's sources will
be built along with the rest of the project, just as though the sources were
part of the project's own sources.

The general pattern is that the project should first declare all the
dependencies it wants to use, then ask for them to be made available.
The following demonstrates the principle (see :ref:`fetch-content-examples`
for more):

.. code-block:: cmake

  include(FetchContent)
  FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        703bd9caab50b139428cea1aaff9974ebee5742e # release-1.10.0
  )
  FetchContent_Declare(
    Catch2
    GIT_REPOSITORY https://github.com/catchorg/Catch2.git
    GIT_TAG        de6fe184a9ac1a06895cdd1c9b437f0a0bdf14ad # v2.13.4
  )
  FetchContent_MakeAvailable(googletest Catch2)

Various download methods are supported, including downloading and extracting
archives from a URL (a range of archive formats are supported), and a number
of repository formats including Git, Subversion, and Mercurial.
Custom download, update, and patch commands can also be used to support
arbitrary use cases.

When a dependency is added to the project with :module:`FetchContent`, the
project links to the dependency's targets just like any other target from the
project.  If the dependency provides namespaced targets of the form
``SomePrefix::ThingName``, the project should link to those rather than to
any non-namespaced targets.  See the next section for why this is recommended.

Not all dependencies can be brought into the project this way.  Some
dependencies define targets whose names clash with other targets from the
project or other dependencies.  Concrete executable and library targets
created by :command:`add_executable` and :command:`add_library` are global,
so each one must be unique across the whole build.  If a dependency would
add a clashing target name, it cannot be brought directly into the build
with this method.

``FetchContent`` And ``find_package()`` Integration
===================================================

.. versionadded:: 3.24

Some dependencies support being added by either :command:`find_package` or
:module:`FetchContent`.  Such dependencies must ensure they define the same
namespaced targets in both installed and built-from-source scenarios.
A consuming project then links to those namespaced targets and can handle
both scenarios transparently, as long as the project does not use anything
else that isn't provided by both methods.

The project can indicate it is happy to accept a dependency by either method
using the ``FIND_PACKAGE_ARGS`` option to :command:`FetchContent_Declare`.
This allows :command:`FetchContent_MakeAvailable` to try satisfying the
dependency with a call to :command:`find_package` first, using the arguments
after the ``FIND_PACKAGE_ARGS`` keyword, if any.  If that doesn't find the
dependency, it is built from source as described previously instead.

.. code-block:: cmake

  include(FetchContent)
  FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        703bd9caab50b139428cea1aaff9974ebee5742e # release-1.10.0
    FIND_PACKAGE_ARGS NAMES GTest
  )
  FetchContent_MakeAvailable(googletest)

  add_executable(ThingUnitTest thing_ut.cpp)
  target_link_libraries(ThingUnitTest GTest::gtest_main)

The above example calls
:command:`find_package(googletest NAMES GTest) <find_package>` first.
CMake provides a :module:`FindGTest` module, so if that finds a GTest package
installed somewhere, it will make it available, and the dependency will not be
built from source.  If no GTest package is found, it *will* be built from
source.  In either case, the ``GTest::gtest_main`` target is expected to be
defined, so we link our unit test executable to that target.

High-level control is also available through the
:variable:`FETCHCONTENT_TRY_FIND_PACKAGE_MODE` variable.  This can be set to
``NEVER`` to disable all redirection to :command:`find_package`.  It can be
set to ``ALWAYS`` to try :command:`find_package` even if ``FIND_PACKAGE_ARGS``
was not specified (this should be used with caution).

The project might also decide that a particular dependency must be built from
source.  This might be needed if a patched or unreleased version of the
dependency is required, or to satisfy some policy that requires all
dependencies to be built from source.  The project can enforce this by adding
the ``OVERRIDE_FIND_PACKAGE`` keyword to :command:`FetchContent_Declare`.
A call to :command:`find_package` for that dependency will then be redirected
to :command:`FetchContent_MakeAvailable` instead.

.. code-block:: cmake

  include(FetchContent)
  FetchContent_Declare(
    Catch2
    URL https://intranet.mycomp.com/vendored/Catch2_2.13.4_patched.tgz
    URL_HASH MD5=abc123...
    OVERRIDE_FIND_PACKAGE
  )

  # The following is automatically redirected to FetchContent_MakeAvailable(Catch2)
  find_package(Catch2)

For more advanced use cases, see the
:variable:`CMAKE_FIND_PACKAGE_REDIRECTS_DIR` variable.

.. _dependency_providers_overview:

Dependency Providers
====================

.. versionadded:: 3.24

The preceding section discussed techniques that projects can use to specify
their dependencies.  Ideally, the project shouldn't really care where a
dependency comes from, as long as it provides the things it expects (often
just some imported targets).  The project says what it needs and may also
specify where to get it from, in the absence of any other details, so that it
can still be built out-of-the-box.

The developer, on the other hand, may be much more interested in controlling
*how* a dependency is provided to the project.  You might want to use a
particular version of a package that you built yourself.  You might want
to use a third party package manager.  You might want to redirect some
requests to a different URL on a system you control for security or
performance reasons.  CMake supports these sort of scenarios through
:ref:`dependency_providers`.

A dependency provider can be set to intercept :command:`find_package` and
:command:`FetchContent_MakeAvailable` calls.  The provider is given an
opportunity to satisfy such requests before falling back to the built-in
implementation if the provider doesn't fulfill it.

Only one dependency provider can be set, and it can only be set at a very
specific point early in the CMake run.
The :variable:`CMAKE_PROJECT_TOP_LEVEL_INCLUDES` variable lists CMake files
that will be read while processing the first :command:`project()` call (and
only that call).  This is the only time a dependency provider may be set.
At most, one single provider is expected to be used throughout the whole
project.

For some scenarios, the user wouldn't need to know the details of how the
dependency provider is set.  A third party may provide a file that can be
added to :variable:`CMAKE_PROJECT_TOP_LEVEL_INCLUDES`, which will set up
the dependency provider on the user's behalf.  This is the recommended
approach for package managers.  The developer can use such a file like so::

  cmake -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=/path/to/package_manager/setup.cmake ...

For details on how to implement your own custom dependency provider, see the
:command:`cmake_language(SET_DEPENDENCY_PROVIDER)` command.
