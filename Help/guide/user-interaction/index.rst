用户交互指南
**********************

.. only:: html

   .. contents::

引言
============

当软件包为基于CMake的构建系统提供了软件的源代码时，软件的消费者需要运行一个CMake用户交互工具来构建它。

行为良好的基于cmake的构建系统不会在源目录中创建任何输出，所以通常情况下，用户执行一个源外构建并在那里执行构建。首先，必须指示CMake生成一个合适的构建系统，然后用户调用构建工具来处理生成的构建系统。生成的构建系统是特定于用来生成它的机器的，并且是不可再分布的。提供的源软件包的每个消费者都需要使用CMake来生成特定于他们系统的构建系统。

生成的构建系统通常应该被视为只读的。作为主要构件的CMake文件应该完全指定构建系统，并且应该没有理由在IDE中手动填充属性，例如在生成构建系统之后。CMake会定期重写生成的构建系统，因此用户的修改会被覆盖。

通过提供CMake文件，本手册中描述的功能和用户界面可用于所有基于CMake的构建系统。

当处理提供的CMake文件时，CMake工具可能会向用户报告错误，比如报告编译器不受支持，或者编译器不支持必需的编译选项，或者无法找到依赖项。这些错误必须由用户通过选择不同的编译器、:guide:`installing dependencies <Using Dependencies Guide>` 或指示CMake在哪里找到它们来解决。

cmake命令行工具
-----------------------

:manual:`cmake(1)` 的一个简单但典型的用法是创建一个build目录并在那里调用cmake：

.. code-block:: console

  $ cd some_software-1.4.2
  $ mkdir build
  $ cd build
  $ cmake .. -DCMAKE_INSTALL_PREFIX=/opt/the/prefix
  $ cmake --build .
  $ cmake --build . --target install

建议在到源的单独目录中构建，因为这样可以保持源目录的原始状态，允许使用多个工具链构建单个源，并允许通过简单地删除构建目录轻松地清除构建工件。

CMake工具可能会报告针对软件提供商的警告，而不是针对软件消费者的警告。这样的警告以“此警告是给项目开发人员的”结尾。用户可以通过向 :manual:`cmake(1)` 传递 ``-Wno-dev`` 标志来禁用此类警告。

cmake-gui工具
--------------

更习惯GUI界面的用户可以使用 :manual:`cmake-gui(1)` 工具来调用CMake并生成构建系统。

必须首先填充源目录和二进制目录。总是建议为源文件和构建文件使用不同的目录。

.. image:: GUI-Source-Binary.png
   :alt: 选择源码及二进制目录

生成一个构建系统
========================

有一些用户界面工具可以用来从CMake文件生成构建系统。:manual:`ccmake(1)` 和 :manual:`cmake-gui(1)` 工具通过设置各种必要的选项指导用户。可以调用 :manual:`cmake(1)` 工具来在命令行上指定选项。本手册描述了可以使用任何用户界面工具设置的选项，尽管每种工具设置选项的方式不同。

命令行环境
------------------------

当使用命令行构建系统(如 ``Makefiles`` 或 ``Ninja``)调用 :manual:`cmake(1)` 时，有必要使用正确的构建环境以确保构建工具可用。CMake必须能够根据需要找到合适的 :variable:`build tool <CMAKE_MAKE_PROGRAM>`、编译器、链接器和其他必要工具。

在Linux系统上，适当的工具通常在系统范围内的位置提供，并且可以通过系统包管理器随时安装。用户提供的或安装在非默认位置的其他工具链也可以使用。

在交叉编译时，一些平台可能需要设置环境变量，或者可能提供设置环境的脚本。

Visual Studio提供了多个命令提示符和 ``vcvarsall.bat`` 脚本，用于为命令行构建系统设置正确的环境。虽然在使用Visual Studio生成器时并不一定需要使用相应的命令行环境，但这样做无坏处。

当使用Xcode时，可以安装多个Xcode版本。使用哪种方法可以有很多不同的选择，但最常见的方法是：

* 在Xcode IDE的首选项中设置默认版本。
* 通过 ``xcode-select`` 命令行工具设置默认版本。
* 在运行CMake和构建工具时，通过设置 ``DEVELOPER_DIR`` 环境变量来覆盖默认版本。

为了方便起见，:manual:`cmake-gui(1)` 提供了一个环境变量编辑器。

命令行 ``-G`` 选项
--------------------------

CMake根据平台默认选择一个生成器。通常，默认生成器足以允许用户继续构建软件。

The user may override the default generator with
the ``-G`` option:

.. code-block:: console

  $ cmake .. -G Ninja

The output of ``cmake --help`` includes a list of
:manual:`generators <cmake-generators(7)>` available
for the user to choose from.  Note that generator
names are case sensitive.

On Unix-like systems (including Mac OS X), the
:generator:`Unix Makefiles` generator is used by
default.  A variant of that generator can also be used
on Windows in various environments, such as the
:generator:`NMake Makefiles` and
:generator:`MinGW Makefiles` generator.  These generators
generate a ``Makefile`` variant which can be executed
with ``make``, ``gmake``, ``nmake`` or similar tools.
See the individual generator documentation for more
information on targeted environments and tools.

The :generator:`Ninja` generator is available on all
major platforms. ``ninja`` is a build tool similar
in use-cases to ``make``, but with a focus on
performance and efficiency.

On Windows, :manual:`cmake(1)` can be used to generate
solutions for the Visual Studio IDE.  Visual Studio
versions may be specified by the product name of the
IDE, which includes a four-digit year.  Aliases are
provided for other means by which Visual Studio
versions are sometimes referred to, such as two
digits which correspond to the product version of the
VisualC++ compiler, or a combination of the two:

.. code-block:: console

  $ cmake .. -G "Visual Studio 2019"
  $ cmake .. -G "Visual Studio 16"
  $ cmake .. -G "Visual Studio 16 2019"

Visual Studio generators can target different architectures.
One can specify the target architecture using the `-A` option:

.. code-block:: console

  cmake .. -G "Visual Studio 2019" -A x64
  cmake .. -G "Visual Studio 16" -A ARM
  cmake .. -G "Visual Studio 16 2019" -A ARM64

On Apple, the :generator:`Xcode` generator may be used to
generate project files for the Xcode IDE.

Some IDEs such as KDevelop4, QtCreator and CLion have
native support for CMake-based buildsystems.  Those IDEs
provide user interface for selecting an underlying
generator to use, typically a choice between a ``Makefile``
or a ``Ninja`` based generator.

Note that it is not possible to change the generator
with ``-G`` after the first invocation of CMake.  To
change the generator, the build directory must be
deleted and the build must be started from scratch.

When generating Visual Studio project and solutions
files several other options are available to use when
initially running :manual:`cmake(1)`.

The Visual Studio toolset can be specified with the
``-T`` option:

.. code-block:: console

    $ # Build with the clang-cl toolset
    $ cmake.exe .. -G "Visual Studio 16 2019" -A x64 -T ClangCL
    $ # Build targeting Windows XP
    $ cmake.exe .. -G "Visual Studio 16 2019" -A x64 -T v120_xp

Whereas the ``-A`` option specifies the _target_
architecture, the ``-T`` option can be used to specify
details of the toolchain used.  For example, `-Thost=x64`
can be given to select the 64-bit version of the host
tools.  The following demonstrates how to use 64-bit
tools and also build for a 64-bit target architecture:

.. code-block:: console

    $ cmake .. -G "Visual Studio 16 2019" -A x64 -Thost=x64

Choosing a generator in cmake-gui
---------------------------------

The "Configure" button triggers a new dialog to
select the CMake generator to use.

.. image:: GUI-Configure-Dialog.png
   :alt: Configuring a generator

All generators available on the command line are also
available in :manual:`cmake-gui(1)`.

.. image:: GUI-Choose-Generator.png
   :alt: Choosing a generator

When choosing a Visual Studio generator, further options
are available to set an architecture to generate for.

.. image:: VS-Choose-Arch.png
   :alt: Choosing an architecture for Visual Studio generators

.. _`Setting Build Variables`:

Setting Build Variables
=======================

Software projects often require variables to be
set on the command line when invoking CMake.  Some of
the most commonly used CMake variables are listed in
the table below:

========================================== ============================================================
 Variable                                   Meaning
========================================== ============================================================
 :variable:`CMAKE_PREFIX_PATH`              Path to search for
                                            :guide:`dependent packages <Using Dependencies Guide>`
 :variable:`CMAKE_MODULE_PATH`              Path to search for additional CMake modules
 :variable:`CMAKE_BUILD_TYPE`               Build configuration, such as
                                            ``Debug`` or ``Release``, determining
                                            debug/optimization flags.  This is only
                                            relevant for single-configuration buildsystems such
                                            as ``Makefile`` and ``Ninja``.  Multi-configuration
                                            buildsystems such as those for Visual Studio and Xcode
                                            ignore this setting.
 :variable:`CMAKE_INSTALL_PREFIX`           Location to install the
                                            software to with the
                                            ``install`` build target
 :variable:`CMAKE_TOOLCHAIN_FILE`           File containing cross-compiling
                                            data such as
                                            :manual:`toolchains and sysroots <cmake-toolchains(7)>`.
 :variable:`BUILD_SHARED_LIBS`              Whether to build shared
                                            instead of static libraries
                                            for :command:`add_library`
                                            commands used without a type
 :variable:`CMAKE_EXPORT_COMPILE_COMMANDS`  Generate a ``compile_commands.json``
                                            file for use with clang-based tools
========================================== ============================================================

Other project-specific variables may be available
to control builds, such as enabling or disabling
components of the project.

There is no convention provided by CMake for how
such variables are named between different
provided buildsystems, except that variables with
the prefix ``CMAKE_`` usually refer to options
provided by CMake itself and should not be used
in third-party options, which should use
their own prefix instead.  The
:manual:`cmake-gui(1)` tool can display options
in groups defined by their prefix, so it makes
sense for third parties to ensure that they use a
self-consistent prefix.

Setting variables on the command line
-------------------------------------

CMake variables can be set on the command line either
when creating the initial build:

.. code-block:: console

    $ mkdir build
    $ cd build
    $ cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Debug

or later on a subsequent invocation of
:manual:`cmake(1)`:

.. code-block:: console

    $ cd build
    $ cmake . -DCMAKE_BUILD_TYPE=Debug

The ``-U`` flag may be used to unset variables
on the :manual:`cmake(1)` command line:

.. code-block:: console

    $ cd build
    $ cmake . -UMyPackage_DIR

A CMake buildsystem which was initially created
on the command line can be modified using the
:manual:`cmake-gui(1)` and vice-versa.

The :manual:`cmake(1)` tool allows specifying a
file to use to populate the initial cache using
the ``-C`` option.  This can be useful to simplify
commands and scripts which repeatedly require the
same cache entries.

Setting variables with cmake-gui
--------------------------------

Variables may be set in the cmake-gui using the "Add Entry"
button.  This triggers a new dialog to set the value of
the variable.

.. image:: GUI-Add-Entry.png
   :alt: Editing a cache entry

The main view of the :manual:`cmake-gui(1)` user interface
can be used to edit existing variables.

The CMake Cache
---------------

When CMake is executed, it needs to find the locations of
compilers, tools and dependencies.  It also needs to be
able to consistently re-generate a buildsystem to use the
same compile/link flags and paths to dependencies.  Such
parameters are also required to be configurable by the
user because they are paths and options specific to the
users system.

When it is first executed, CMake generates a
``CMakeCache.txt`` file in the build directory containing
key-value pairs for such artifacts.  The cache file can be
viewed or edited by the user by running the
:manual:`cmake-gui(1)` or :manual:`ccmake(1)` tool.  The
tools provide an interactive interface for re-configuring
the provided software and re-generating the buildsystem,
as is needed after editing cached values.  Each cache
entry may have an associated short help text which is
displayed in the user interface tools.

The cache entries may also have a type to signify how it
should be presented in the user interface.  For example,
a cache entry of type ``BOOL`` can be edited by a
checkbox in a user interface, a ``STRING`` can be edited
in a text field, and a ``FILEPATH`` while similar to a
``STRING`` should also provide a way to locate filesystem
paths using a file dialog.  An entry of type ``STRING``
may provide a restricted list of allowed values which are
then provided in a drop-down menu in the
:manual:`cmake-gui(1)` user interface (see the
:prop_cache:`STRINGS` cache property).

The CMake files shipped with a software package may also
define boolean toggle options using the :command:`option`
command.  The command creates a cache entry which has a
help text and a default value.  Such cache entries are
typically specific to the provided software and affect
the configuration of the build, such as whether tests
and examples are built, whether to build with exceptions
enabled etc.

Presets
=======

CMake understands a file, ``CMakePresets.json``, and its
user-specific counterpart, ``CMakeUserPresets.json``, for
saving presets for commonly-used configure settings. These
presets can set the build directory, generator, cache
variables, environment variables, and other command-line
options. All of these options can be overridden by the
user. The full details of the ``CMakePresets.json`` format
are listed in the :manual:`cmake-presets(7)` manual.

Using presets on the command-line
---------------------------------

When using the :manual:`cmake(1)` command line tool, a
preset can be invoked by using the ``--preset`` option. If
``--preset`` is specified, the generator and build
directory are not required, but can be specified to
override them. For example, if you have the following
``CMakePresets.json`` file:

.. code-block:: json

  {
    "version": 1,
    "configurePresets": [
      {
        "name": "ninja-release",
        "binaryDir": "${sourceDir}/build/${presetName}",
        "generator": "Ninja",
        "cacheVariables": {
          "CMAKE_BUILD_TYPE": "Release"
        }
      }
    ]
  }

and you run the following:

.. code-block:: console

  cmake -S /path/to/source --preset=ninja-release

This will generate a build directory in
``/path/to/source/build/ninja-release`` with the
:generator:`Ninja` generator, and with
:variable:`CMAKE_BUILD_TYPE` set to ``Release``.

If you want to see the list of available presets, you can
run:

.. code-block:: console

  cmake -S /path/to/source --list-presets

This will list the presets available in
``/path/to/source/CMakePresets.json`` and
``/path/to/source/CMakeUsersPresets.json`` without
generating a build tree.

Using presets in cmake-gui
--------------------------

If a project has presets available, either through
``CMakePresets.json`` or ``CMakeUserPresets.json``, the
list of presets will appear in a drop-down menu in
:manual:`cmake-gui(1)` between the source directory and
the binary directory. Choosing a preset sets the binary
directory, generator, environment variables, and cache
variables, but all of these options can be overridden after
a preset is selected.

Invoking the Buildsystem
========================

After generating the buildsystem, the software can be
built by invoking the particular build tool.  In the
case of the IDE generators, this can involve loading
the generated project file into the IDE to invoke the
build.

CMake is aware of the specific build tool needed to invoke
a build so in general, to build a buildsystem or project
from the command line after generating, the following
command may be invoked in the build directory:

.. code-block:: console

  $ cmake --build .

The ``--build`` flag enables a particular mode of
operation for the :manual:`cmake(1)` tool.  It invokes
the  :variable:`CMAKE_MAKE_PROGRAM` command associated
with the :manual:`generator <cmake-generators(7)>`, or
the build tool configured by the user.

The ``--build`` mode also accepts the parameter
``--target`` to specify a particular target to build,
for example a particular library, executable or
custom target, or a particular special target like
``install``:

.. code-block:: console

  $ cmake --build . --target myexe

The ``--build`` mode also accepts a ``--config`` parameter
in the case of multi-config generators to specify which
particular configuration to build:

.. code-block:: console

  $ cmake --build . --target myexe --config Release

The ``--config`` option has no effect if the generator
generates a buildsystem specific to a configuration which
is chosen when invoking cmake with the
:variable:`CMAKE_BUILD_TYPE` variable.

Some buildsystems omit details of command lines invoked
during the build.  The ``--verbose`` flag can be used to
cause those command lines to be shown:

.. code-block:: console

  $ cmake --build . --target myexe --verbose

The ``--build`` mode can also pass particular command
line options to the underlying build tool by listing
them after ``--``.  This can be useful to specify
options to the build tool, such as to continue the
build after a failed job, where CMake does not
provide a high-level user interface.

For all generators, it is possible to run the underlying
build tool after invoking CMake.  For example, ``make``
may be executed after generating with the
:generator:`Unix Makefiles` generator to invoke the build,
or ``ninja`` after generating with the :generator:`Ninja`
generator etc.  The IDE buildsystems usually provide
command line tooling for building a project which can
also be invoked.

Selecting a Target
------------------

Each executable and library described in the CMake files
is a build target, and the buildsystem may describe
custom targets, either for internal use, or for user
consumption, for example to create documentation.

CMake provides some built-in targets for all buildsystems
providing CMake files.

``all``
  The default target used by ``Makefile`` and ``Ninja``
  generators.  Builds all targets in the buildsystem,
  except those which are excluded by their
  :prop_tgt:`EXCLUDE_FROM_ALL` target property or
  :prop_dir:`EXCLUDE_FROM_ALL` directory property.  The
  name ``ALL_BUILD`` is used for this purpose for the
  Xcode and Visual Studio generators.
``help``
  Lists the targets available for build.  This target is
  available when using the :generator:`Unix Makefiles` or
  :generator:`Ninja` generator, and the exact output is
  tool-specific.
``clean``
  Delete built object files and other output files.  The
  ``Makefile`` based generators create a ``clean`` target
  per directory, so that an individual directory can be
  cleaned.  The ``Ninja`` tool provides its own granular
  ``-t clean`` system.
``test``
  Runs tests.  This target is only automatically available
  if the CMake files provide CTest-based tests.  See also
  `Running Tests`_.
``install``
  Installs the software.  This target is only automatically
  available if the software defines install rules with the
  :command:`install` command.  See also
  `Software Installation`_.
``package``
  Creates a binary package.  This target is only
  automatically available if the CMake files provide
  CPack-based packages.
``package_source``
  Creates a source package.  This target is only
  automatically available if the CMake files provide
  CPack-based packages.

For ``Makefile`` based systems, ``/fast`` variants of binary
build targets are provided. The ``/fast`` variants are used
to build the specified target without regard for its
dependencies.  The dependencies are not checked and
are not rebuilt if out of date.  The :generator:`Ninja`
generator is sufficiently fast at dependency checking that
such targets are not provided for that generator.

``Makefile`` based systems also provide build-targets to
preprocess, assemble and compile individual files in a
particular directory.

.. code-block:: console

  $ make foo.cpp.i
  $ make foo.cpp.s
  $ make foo.cpp.o

The file extension is built into the name of the target
because another file with the same name but a different
extension may exist.  However, build-targets without the
file extension are also provided.

.. code-block:: console

  $ make foo.i
  $ make foo.s
  $ make foo.o

In buildsystems which contain ``foo.c`` and ``foo.cpp``,
building the ``foo.i`` target will preprocess both files.

Specifying a Build Program
--------------------------

The program invoked by the ``--build`` mode is determined
by the :variable:`CMAKE_MAKE_PROGRAM` variable.  For most
generators, the particular program does not need to be
configured.

===================== =========================== ===========================
      Generator           Default make program           Alternatives
===================== =========================== ===========================
 XCode                 ``xcodebuild``
 Unix Makefiles        ``make``
 NMake Makefiles       ``nmake``                   ``jom``
 NMake Makefiles JOM   ``jom``                     ``nmake``
 MinGW Makefiles       ``mingw32-make``
 MSYS Makefiles        ``make``
 Ninja                 ``ninja``
 Visual Studio         ``msbuild``
 Watcom WMake          ``wmake``
===================== =========================== ===========================

The ``jom`` tool is capable of reading makefiles of the
``NMake`` flavor and building in parallel, while the
``nmake`` tool always builds serially.  After generating
with the :generator:`NMake Makefiles` generator a user
can run ``jom`` instead of ``nmake``.  The ``--build``
mode would also use ``jom`` if the
:variable:`CMAKE_MAKE_PROGRAM` was set to ``jom`` while
using the :generator:`NMake Makefiles` generator, and
as a convenience, the :generator:`NMake Makefiles JOM`
generator is provided to find ``jom`` in the normal way
and use it as the :variable:`CMAKE_MAKE_PROGRAM`. For
completeness, ``nmake`` is an alternative tool which
can process the output of the
:generator:`NMake Makefiles JOM` generator, but doing
so would be a pessimisation.

Software Installation
=====================

The :variable:`CMAKE_INSTALL_PREFIX` variable can be
set in the CMake cache to specify where to install the
provided software.  If the provided software has install
rules, specified using the :command:`install` command,
they will install artifacts into that prefix.  On Windows,
the default installation location corresponds to the
``ProgramFiles`` system directory which may be
architecture specific.  On Unix hosts, ``/usr/local`` is
the default installation location.

The :variable:`CMAKE_INSTALL_PREFIX` variable always
refers to the installation prefix on the target
filesystem.

In cross-compiling or packaging scenarios where the
sysroot is read-only or where the sysroot should otherwise
remain pristine, the :variable:`CMAKE_STAGING_PREFIX`
variable can be set to a location to actually install
the files.

The commands:

.. code-block:: console

  $ cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_SYSROOT=$HOME/root \
    -DCMAKE_STAGING_PREFIX=/tmp/package
  $ cmake --build .
  $ cmake --build . --target install

result in files being installed to paths such
as ``/tmp/package/lib/libfoo.so`` on the host machine.
The ``/usr/local`` location on the host machine is
not affected.

Some provided software may specify ``uninstall`` rules,
but CMake does not generate such rules by default itself.

Running Tests
=============

The :manual:`ctest(1)` tool is shipped with the CMake
distribution to execute provided tests and report
results.  The ``test`` build-target is provided to run
all available tests, but the :manual:`ctest(1)` tool
allows granular control over which tests to run, how to
run them, and how to report results.  Executing
:manual:`ctest(1)` in the build directory is equivalent
to running the ``test`` target:

.. code-block:: console

  $ ctest

A regular expression can be passed to run only tests
which match the expression.  To run only tests with
``Qt`` in their name:

.. code-block:: console

  $ ctest -R Qt

Tests can be excluded by regular expression too.  To
run only tests without ``Qt`` in their name:

.. code-block:: console

  $ ctest -E Qt

Tests can be run in parallel by passing ``-j`` arguments
to :manual:`ctest(1)`:

.. code-block:: console

  $ ctest -R Qt -j8

The environment variable :envvar:`CTEST_PARALLEL_LEVEL`
can alternatively be set to avoid the need to pass
``-j``.

By default :manual:`ctest(1)` does not print the output
from the tests. The command line argument ``-V`` (or
``--verbose``) enables verbose mode to print the
output from all tests.
The ``--output-on-failure`` option prints the test
output for failing tests only.  The environment variable
:envvar:`CTEST_OUTPUT_ON_FAILURE`
can be set to ``1`` as an alternative to passing the
``--output-on-failure`` option to :manual:`ctest(1)`.
