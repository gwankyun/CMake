导入导出指南
*****************************

.. only:: html

   .. contents::

引言
============

在本指南中, 我们将介绍 :prop_tgt:`IMPORTED` 目标的概念，并演示如何将现有的可执行文件或库文件从磁盘导入到CMake项目中。然后，我们将展示CMake如何支持从一个基于CMake的项目导出目标，并将其导入到另一个项目中。最后，我们将演示如何用配置文件打包一个项目，以方便集成到其他CMake项目中。本指南和完整的示例源代码可以在CMake源码树的 ``Help/guide/importing-exporting`` 目录中找到。


导入目标
=================

:prop_tgt:`IMPORTED` 目标用于将CMake项目外部的文件转换为项目内部的逻辑目标。:prop_tgt:`IMPORTED` 目标可以由 :command:`add_executable` 和 :command:`add_library` 的 ``IMPORTED`` 选项创建。:prop_tgt:`IMPORTED` 目标不会生成构建文件。一旦导入，:prop_tgt:`IMPORTED` 目标可以像项目中的任何其他目标一样被引用，并提供对外部可执行文件和库的方便、灵活的引用。

默认情况下，:prop_tgt:`IMPORTED` 目标变量在创建它的目录及其下方具有作用域。可以使用 ``GLOBAL`` 选项来扩展可见性，这样就可以在构建系统中全局访问目标。

:prop_tgt:`IMPORTED` 目标的详细信息可以通过设置名称以 ``IMPORTED_`` 及 ``INTERFACE_`` 开头的属性来指定。例如，:prop_tgt:`IMPORTED_LOCATION` 包含到磁盘上目标的完整路径。

导入可执行文件
---------------------

首先，我们将介绍一个简单的示例，该示例创建一个 :prop_tgt:`IMPORTED` 的可执行目标，然后从 :command:`add_custom_command` 命令引用它。

我们需要做一些准备工作来开始。我们希望创建一个可执行文件，在运行时在当前目录中创建一个基本的 ``main.cc`` 文件。这个项目的细节并不重要。导航到 ``Help/guide/importing-exporting/MyExe`` 目录，运行 :manual:`cmake <cmake(1)>` 构建并安装项目。

.. code-block:: console

  $ cd Help/guide/importing-exporting/MyExe
  $ mkdir build
  $ cd build
  $ cmake ..
  $ cmake --build .
  $ cmake --install . --prefix <install location>
  $ <install location>/myexe
  $ ls
  [...] main.cc [...]

现在我们可以将这个可执行文件导入到另一个CMake项目中。本节的源代码可以在 ``Help/guide/importing-exporting/Importing`` 中找到。在CMakeLists文件中，使用 :command:`add_executable` 命令创建一个名为 ``myexe`` 的新目标。使用 ``IMPORTED`` 选项告诉CMake这个目标引用了位于项目外部的一个可执行文件。不要生成任何规则来构建它，并且 :prop_tgt:`IMPORTED` 目标属性将被设置为 ``true``。

.. literalinclude:: Importing/CMakeLists.txt
  :language: cmake
  :start-after: # Add executable
  :end-before: # Set imported location

接下来，使用 :command:`set_property` 命令设置目标的 :prop_tgt:`IMPORTED_LOCATION` 属性。这将告诉CMake目标在磁盘上的位置。该位置可能需要调整到上一步中指定的 ``<install location>``。

.. literalinclude:: Importing/CMakeLists.txt
  :language: cmake
  :start-after: # Set imported location
  :end-before: # Add custom command

现在我们可以引用这个 :prop_tgt:`IMPORTED` 目标，就像项目中构建的任何目标一样。在这个例子中，让我们假设我们想要在我们的项目中使用生成的源文件。在 :command:`add_custom_command` 命令中使用 :prop_tgt:`IMPORTED` 目标：

.. literalinclude:: Importing/CMakeLists.txt
  :language: cmake
  :start-after: # Add custom command
  :end-before: # Use source file

由于 ``COMMAND`` 指定了一个可执行的目标名称，它将自动被上面的 :prop_tgt:`IMPORTED_LOCATION` 属性给出的可执行文件的位置所替换。

最后，使用 :command:`add_custom_command` 的输出：

.. literalinclude:: Importing/CMakeLists.txt
  :language: cmake
  :start-after: # Use source file

导入库
-------------------

以类似的方式，可以通过 :prop_tgt:`IMPORTED` 目标访问其他项目的库。

注意：本节没有提供示例的完整源代码，仅作为读者的练习。

在CMakeLists文件中，添加一个 :prop_tgt:`IMPORTED` 库，并指定它在磁盘上的位置：

.. code-block:: cmake

  add_library(foo STATIC IMPORTED)
  set_property(TARGET foo PROPERTY
               IMPORTED_LOCATION "/path/to/libfoo.a")

然后在我们的项目中使用 :prop_tgt:`IMPORTED` 库：

.. code-block:: cmake

  add_executable(myexe src1.c src2.c)
  target_link_libraries(myexe PRIVATE foo)


在Windows上，.dll文件可以和它的.lib导入库一起导入：

.. code-block:: cmake

  add_library(bar SHARED IMPORTED)
  set_property(TARGET bar PROPERTY
               IMPORTED_LOCATION "c:/path/to/bar.dll")
  set_property(TARGET bar PROPERTY
               IMPORTED_IMPLIB "c:/path/to/bar.lib")
  add_executable(myexe src1.c src2.c)
  target_link_libraries(myexe PRIVATE bar)

带有多个配置的库可以通过单个目标导入：

.. code-block:: cmake

  find_library(math_REL NAMES m)
  find_library(math_DBG NAMES md)
  add_library(math STATIC IMPORTED GLOBAL)
  set_target_properties(math PROPERTIES
    IMPORTED_LOCATION "${math_REL}"
    IMPORTED_LOCATION_DEBUG "${math_DBG}"
    IMPORTED_CONFIGURATIONS "RELEASE;DEBUG"
  )
  add_executable(myexe src1.c src2.c)
  target_link_libraries(myexe PRIVATE math)

生成的构建系统将在发布配置中链接 ``myexe`` 到 ``m.lib``，在调试配置中链接到 ``md.lib``。

导出目标
=================

虽然 :prop_tgt:`IMPORTED` 目标本身很有用，但它们仍然需要导入它们的项目知道目标文件在磁盘上的位置。 :prop_tgt:`IMPORTED` 目标真正的强大之处在于，提供目标文件的项目还提供了一个CMake文件来帮助导入目标文件。可以通过设置一个项目来生成必要的信息，以便其他CMake项目可以很容易地从构建目录、本地安装或打包使用它。

在其余部分中，我们将逐步介绍一组示例项目。第一个项目将创建并安装一个库以及相应的CMake配置和包文件。第二个项目将使用生成的包。

让我们从 ``Help/guide/importing-exporting/MathFunctions`` 目录的 ``MathFunctions`` 项目开始。这里有一个 ``MathFunctions.h`` 头文件，里面声明了一个 ``sqrt`` 函数：

.. literalinclude:: MathFunctions/MathFunctions.h
  :language: c++

以及相关的源文件 ``MathFunctions.cxx``：

.. literalinclude:: MathFunctions/MathFunctions.cxx
  :language: c++

不要担心C++文件的细节，这只是一个简单的示例，可在许多构建系统上编译和运行。

现在我们可以为 ``MathFunctions`` 项目创建一个 ``CMakeLists.txt`` 文件。首先分别使用 :command:`cmake_minimum_required` 和 :command:`project` 指定版本号和名称：

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :end-before: # create library

使用 :command:`add_library` 命令命令创建一个名为 ``MathFunctions`` 的库：

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # create library
  :end-before: # add include directories

然后使用 :command:`target_include_directories` 命令为目标指定包含的目录：

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # add include directories
  :end-before: # install the target and create export-set

我们需要告诉CMake，我们想要使用不同的包含目录，这取决于我们是在构建库还是在安装位置使用它。如果我们不这样做，当CMake创建导出信息时，它将导出一个特定于当前构建目录的路径，对其他项目无效。我们可以使用 :manual:`generator expressions <cmake-generator-expressions(7)>` 指定在构建库时包含当前源目录。否则，在安装时包含 ``include`` 目录。更多有关细节，请参阅 `创建可重定位包`_。

:command:`install(TARGETS)` 命令和 :command:`install(EXPORT)` 命令一起工作，安装两个目标（在我们的例子中是一个库）和一个CMake文件，该文件旨在方便地将目标导入到另一个CMake项目中。

首先，在 :command:`install(TARGETS)` 命令中，我们将指定目标、 ``EXPORT`` 名称和告诉CMake在何处安装这些目标。

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # install the target and create export-set
  :end-before: # install header file

这里，``EXPORT`` 选项告诉CMake创建一个名为 ``MathFunctionsTargets`` 的导出。生成的 :prop_tgt:`IMPORTED` 目标设置了适当的属性来定义它们的 :ref:`usage requirements <Target Usage Requirements>`，例如 :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`、:prop_tgt:`INTERFACE_COMPILE_DEFINITIONS` 和其他相关的内置 ``INTERFACE_`` 属性。在 :prop_tgt:`COMPATIBLE_INTERFACE_STRING` 中列出的用户定义属性的 ``INTERFACE`` 变体和其他 :ref:`Compatible Interface Properties` 也会传播到生成的 :prop_tgt:`IMPORTED` 目标。例如，在本例中，:prop_tgt:`IMPORTED` 目标将使用 :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` 属性指定的目录填充其 ``INCLUDES DESTINATION`` 属性。由于给出了一个相对路径，它被视为相对于 :variable:`CMAKE_INSTALL_PREFIX`。

注意，我们还 *没有* 要求CMake安装导出。

我们不希望忘记使用 :command:`install(FILES)` 命令安装 ``MathFunctions.h`` 头文件。头文件应该安装到 ``include`` 目录中，如上面的 :command:`target_include_directories` 命令所指定的那样。

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # install header file
  :end-before: # generate and install export file

现在 ``MathFunctions`` 库和头文件已经安装好了，我们还需要显式安装 ``MathFunctionsTargets`` 导出详细信息。按照 :command:`install(TARGETS)` 命令的定义，使用 :command:`install(EXPORT)` 命令导出 ``MathFunctionsTargets`` 中的目标。

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # generate and install export file
  :end-before: # include CMakePackageConfigHelpers macro

This command generates the ``MathFunctionsTargets.cmake`` file and arranges
to install it to ``lib/cmake``. The file contains code suitable for
use by downstreams to import all targets listed in the install command from
the installation tree.

The ``NAMESPACE`` option will prepend ``MathFunctions::`` to  the target names
as they are written to the export file. This convention of double-colons
gives CMake a hint that the name is an  :prop_tgt:`IMPORTED` target when it
is used by downstream projects. This way, CMake can issue a diagnostic
message if the package providing it was not found.

The generated export file contains code that creates an :prop_tgt:`IMPORTED` library.

.. code-block:: cmake

  # Create imported target MathFunctions::MathFunctions
  add_library(MathFunctions::MathFunctions STATIC IMPORTED)

  set_target_properties(MathFunctions::MathFunctions PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include"
  )

This code is very similar to the example we created by hand in the
`导入库`_ section. Note that ``${_IMPORT_PREFIX}`` is computed
relative to the file location.

An outside project may load this file with the :command:`include` command and
reference the ``MathFunctions`` library from the installation tree as if it
were built in its own tree. For example:

.. code-block:: cmake
  :linenos:

   include(${INSTALL_PREFIX}/lib/cmake/MathFunctionTargets.cmake)
   add_executable(myexe src1.c src2.c )
   target_link_libraries(myexe PRIVATE MathFunctions::MathFunctions)

Line 1 loads the target CMake file. Although we only exported a single
target, this file may import any number of targets. Their locations are
computed relative to the file location so that the install tree may be
easily moved. Line 3 references the imported ``MathFunctions`` library. The
resulting build system will link to the library from its installed location.

Executables may also be exported and imported using the same process.

Any number of target installations may be associated with the same
export name. Export names are considered global so any directory may
contribute a target installation. The :command:`install(EXPORT)` command only
needs to be called once to install a file that references all targets. Below
is an example of how multiple exports may be combined into a single
export file, even if they are in different subdirectories of the project.

.. code-block:: cmake

  # A/CMakeLists.txt
  add_executable(myexe src1.c)
  install(TARGETS myexe DESTINATION lib/myproj
          EXPORT myproj-targets)

  # B/CMakeLists.txt
  add_library(foo STATIC foo1.c)
  install(TARGETS foo DESTINATION lib EXPORTS myproj-targets)

  # Top CMakeLists.txt
  add_subdirectory (A)
  add_subdirectory (B)
  install(EXPORT myproj-targets DESTINATION lib/myproj)

Creating Packages
-----------------

At this point, the ``MathFunctions`` project is exporting the target
information required to be used by other projects. We can make this project
even easier for other projects to use by generating a configuration file so
that the CMake :command:`find_package` command can find our project.

To start, we will need to make a few additions to the ``CMakeLists.txt``
file. First, include the :module:`CMakePackageConfigHelpers` module to get
access to some helper functions for creating config files.

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # include CMakePackageConfigHelpers macro
  :end-before: # set version

Then we will create a package configuration file and a package version file.

Creating a Package Configuration File
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the :command:`configure_package_config_file` command provided by the
:module:`CMakePackageConfigHelpers` to generate the package configuration
file. Note that this command should be used instead of the plain
:command:`configure_file` command. It helps to ensure that the resulting
package is relocatable by avoiding hardcoded paths in the installed
configuration file. The path given to ``INSTALL_DESTINATION`` must  be the
destination where the ``MathFunctionsConfig.cmake`` file will be installed.
We will examine the contents of the package configuration file in the next
section.

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # create config file
  :end-before: # install config files

Install the generated configuration files with the :command:`INSTALL(files)`
command. Both ``MathFunctionsConfigVersion.cmake`` and
``MathFunctionsConfig.cmake`` are installed to the same location, completing
the package.

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # install config files
  :end-before: # generate the export targets for the build tree

Now we need to create the package configuration file itself. In this case, the
``Config.cmake.in`` file is very simple but sufficient to allow downstreams
to use the :prop_tgt:`IMPORTED` targets.

.. literalinclude:: MathFunctions/Config.cmake.in

The first line of the file contains only the string ``@PACKAGE_INIT@``. This
expands when the file is configured and allows the use of relocatable paths
prefixed with ``PACKAGE_``. It also provides the ``set_and_check()`` and
``check_required_components()`` macros.

The ``check_required_components`` helper macro ensures that all requested,
non-optional components have been found by checking the
``<Package>_<Component>_FOUND`` variables for all required components. This
macro should be called at the end of the package configuration file even if the
package does not have any components. This way, CMake can make sure that the
downstream project hasn't specified any non-existent components. If
``check_required_components`` fails, the ``<Package>_FOUND`` variable is set to
FALSE, and the package is considered to be not found.

The ``set_and_check()`` macro should be used in configuration files instead
of the normal ``set()`` command for setting directories and file locations.
If a referenced file or directory does not exist, the macro will fail.

If any macros should be provided by the ``MathFunctions`` package, they should
be in a separate file which is installed to the same location as the
``MathFunctionsConfig.cmake`` file, and included from there.

**All required dependencies of a package must also be found in the package
configuration file.** Let's imagine that we require the ``Stats`` library in
our project. In the CMakeLists file, we would add:

.. code-block:: cmake

  find_package(Stats 2.6.4 REQUIRED)
  target_link_libraries(MathFunctions PUBLIC Stats::Types)

As the ``Stats::Types`` target is a ``PUBLIC`` dependency of ``MathFunctions``,
downstreams must also find the ``Stats`` package and link to the
``Stats::Types`` library.  The ``Stats`` package should be found in the
configuration file to ensure this.

.. code-block:: cmake

  include(CMakeFindDependencyMacro)
  find_dependency(Stats 2.6.4)

The ``find_dependency`` macro from the :module:`CMakeFindDependencyMacro`
module helps by propagating  whether the package is ``REQUIRED``, or
``QUIET``, etc. The ``find_dependency`` macro also sets
``MathFunctions_FOUND`` to ``False`` if the dependency is not found, along
with a diagnostic that the ``MathFunctions`` package cannot be used without
the ``Stats`` package.

**Exercise:** Add a required library to the ``MathFunctions`` project.

Creating a Package Version File
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The :module:`CMakePackageConfigHelpers` module provides the
:command:`write_basic_package_version_file` command for creating a simple
package version file.  This file is read by CMake when :command:`find_package`
is called to determine the compatibility with the requested version, and to set
some version-specific variables such as ``<PackageName>_VERSION``,
``<PackageName>_VERSION_MAJOR``, ``<PackageName>_VERSION_MINOR``, etc. See
:manual:`cmake-packages <cmake-packages(7)>` documentation for more details.

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # set version
  :end-before: # create config file

In our example, ``MathFunctions_MAJOR_VERSION`` is defined as a
:prop_tgt:`COMPATIBLE_INTERFACE_STRING` which means that it must be
compatible among the dependencies of any depender. By setting this
custom defined user property in this version and in the next version of
``MathFunctions``, :manual:`cmake <cmake(1)>` will issue a diagnostic if
there is an attempt to use version 3 together with version 4.  Packages can
choose to employ such a pattern if different major versions of the package
are designed to be incompatible.


Exporting Targets from the Build Tree
-------------------------------------

Typically, projects are built and installed before being used by an outside
project. However, in some cases, it is desirable to export targets directly
from a build tree. The targets may then be used by an outside project that
references the build tree with no installation involved. The :command:`export`
command is used to generate a file exporting targets from a project build tree.

If we want our example project to also be used from a build directory we only
have to add the following to ``CMakeLists.txt``:

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # generate the export targets for the build tree

Here we use the :command:`export` command to generate the export targets for
the build tree. In this case, we'll create a file called
``MathFunctionsTargets.cmake`` in the ``cmake`` subdirectory of the build
directory. The generated file contains the required code to import the target
and may be loaded by an outside project that is aware of the project build
tree. This file is specific to the build-tree, and **is not relocatable**.

It is possible to create a suitable package configuration file and package
version file to define a package for the build tree which may be used without
installation.  Consumers of the build tree can simply ensure that the
:variable:`CMAKE_PREFIX_PATH` contains the build directory, or set the
``MathFunctions_DIR`` to ``<build_dir>/MathFunctions`` in the cache.

An example application of this feature is for building an executable on a host
platform when cross-compiling. The project containing the executable may be
built on the host platform and then the project that is being cross-compiled
for another platform may load it.

Building and Installing a Package
---------------------------------

At this point, we have generated a relocatable CMake configuration for our
project that can be used after the project has been installed. Let's try to
build the ``MathFunctions`` project:

.. code-block:: console

  mkdir MathFunctions_build
  cd MathFunctions_build
  cmake ../MathFunctions
  cmake --build .

In the build directory, notice that the file ``MathFunctionsTargets.cmake``
has been created in the ``cmake`` subdirectory.

Now install the project:

.. code-block:: console

    $ cmake --install . --prefix "/home/myuser/installdir"

创建可重定位包
=============================

Packages created by :command:`install(EXPORT)` are designed to be relocatable,
using paths relative to the location of the package itself. They must not
reference absolute paths of files on the machine where the package is built
that will not exist on the machines where the package may be installed.

When defining the interface of a target for ``EXPORT``, keep in mind that the
include directories should be specified as relative paths to the
:variable:`CMAKE_INSTALL_PREFIX` but should not explicitly include the
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
    $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/include/TgtName>
  )

This also applies to paths referencing external dependencies.
It is not advisable to populate any properties which may contain
paths, such as :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` or
:prop_tgt:`INTERFACE_LINK_LIBRARIES`, with paths relevant to dependencies.
For example, this code may not work well for a relocatable package:

.. code-block:: cmake

  target_link_libraries(MathFunctions INTERFACE
    ${Foo_LIBRARIES} ${Bar_LIBRARIES}
    )
  target_include_directories(MathFunctions INTERFACE
    "$<INSTALL_INTERFACE:${Foo_INCLUDE_DIRS};${Bar_INCLUDE_DIRS}>"
    )

The referenced variables may contain the absolute paths to libraries
and include directories **as found on the machine the package was made on**.
This would create a package with hard-coded paths to dependencies not
suitable for relocation.

Ideally such dependencies should be used through their own
:ref:`IMPORTED targets <Imported Targets>` that have their own
:prop_tgt:`IMPORTED_LOCATION` and usage requirement properties
such as :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` populated
appropriately.  Those imported targets may then be used with
the :command:`target_link_libraries` command for ``MathFunctions``:

.. code-block:: cmake

  target_link_libraries(MathFunctions INTERFACE Foo::Foo Bar::Bar)

With this approach the package references its external dependencies
only through the names of :ref:`IMPORTED targets <Imported Targets>`.
When a consumer uses the installed package, the consumer will run the
appropriate :command:`find_package` commands (via the ``find_dependency``
macro described above) to find the dependencies and populate the
imported targets with appropriate paths on their own machine.

Using the Package Configuration File
====================================

Now we're ready to create a project to use the installed ``MathFunctions``
library. In this section we will be using source code from
``Help\guide\importing-exporting\Downstream``. In this directory, there is a
source file called ``main.cc`` that uses the ``MathFunctions`` library to
calculate the square root of a given number and then prints the results:

.. literalinclude:: Downstream/main.cc
  :language: c++

As before, we'll start with the :command:`cmake_minimum_required` and
:command:`project` commands in the ``CMakeLists.txt`` file. For this project,
we'll also specify the C++ standard.

.. literalinclude:: Downstream/CMakeLists.txt
  :language: cmake
  :end-before: # find MathFunctions

We can use the :command:`find_package` command:

.. literalinclude:: Downstream/CMakeLists.txt
  :language: cmake
  :start-after: # find MathFunctions
  :end-before: # create executable

Create an exectuable:

.. literalinclude:: Downstream/CMakeLists.txt
  :language: cmake
  :start-after: # create executable
  :end-before: # use MathFunctions library

And link to the ``MathFunctions`` library:

.. literalinclude:: Downstream/CMakeLists.txt
  :language: cmake
  :start-after: # use MathFunctions library

That's it! Now let's try to build the ``Downstream`` project.

.. code-block:: console

  mkdir Downstream_build
  cd Downstream_build
  cmake ../Downstream
  cmake --build .

A warning may have appeared during CMake configuration:

.. code-block:: console

  CMake Warning at CMakeLists.txt:4 (find_package):
    By not providing "FindMathFunctions.cmake" in CMAKE_MODULE_PATH this
    project has asked CMake to find a package configuration file provided by
    "MathFunctions", but CMake did not find one.

    Could not find a package configuration file provided by "MathFunctions"
    with any of the following names:

      MathFunctionsConfig.cmake
      mathfunctions-config.cmake

    Add the installation prefix of "MathFunctions" to CMAKE_PREFIX_PATH or set
    "MathFunctions_DIR" to a directory containing one of the above files.  If
    "MathFunctions" provides a separate development package or SDK, be sure it
    has been installed.

Set the ``CMAKE_PREFIX_PATH`` to where MathFunctions was installed previously
and try again. Ensure that the newly created executable runs as expected.

Adding Components
=================

Let's edit the ``MathFunctions`` project to use components. The source code for
this section can be found in
``Help\guide\importing-exporting\MathFunctionsComponents``. The CMakeLists file
for this project adds two subdirectories: ``Addition`` and ``SquareRoot``.

.. literalinclude:: MathFunctionsComponents/CMakeLists.txt
  :language: cmake
  :end-before: # include CMakePackageConfigHelpers macro

Generate and install the package configuration and package version files:

.. literalinclude:: MathFunctionsComponents/CMakeLists.txt
  :language: cmake
  :start-after: # include CMakePackageConfigHelpers macro

If ``COMPONENTS`` are specified when the downstream uses
:command:`find_package`, they are listed in the
``<PackageName>_FIND_COMPONENTS`` variable. We can use this variable to verify
that all necessary component targets are included in ``Config.cmake.in``. At
the same time, this function will act as a custom ``check_required_components``
macro to ensure that the downstream only attempts to use supported components.

.. literalinclude:: MathFunctionsComponents/Config.cmake.in

Here, the ``MathFunctions_NOT_FOUND_MESSAGE`` is set to a diagnosis that the
package could not be found because an invalid component was specified. This
message variable can be set for any case where the ``_FOUND`` variable is set
to ``False``, and will be displayed to the user.

The ``Addition`` and ``SquareRoot`` directories are similar. Let's look at one
of the CMakeLists files:

.. literalinclude:: MathFunctionsComponents/SquareRoot/CMakeLists.txt
  :language: cmake

Now we can build the project as described in earlier sections. To test using
this package, we can use the project in
``Help\guide\importing-exporting\DownstreamComponents``. There's two
differences from the previous ``Downstream`` project. First, we need to find
the package components. Change the ``find_package`` line from:

.. literalinclude:: Downstream/CMakeLists.txt
  :language: cmake
  :start-after: # find MathFunctions
  :end-before: # create executable

To:

.. literalinclude:: DownstreamComponents/CMakeLists.txt
  :language: cmake
  :start-after: # find MathFunctions
  :end-before: # create executable

and the ``target_link_libraries`` line from:

.. literalinclude:: Downstream/CMakeLists.txt
  :language: cmake
  :start-after: # use MathFunctions library

To:

.. literalinclude:: DownstreamComponents/CMakeLists.txt
  :language: cmake
  :start-after: # use MathFunctions library
  :end-before: # Workaround for GCC on AIX to avoid -isystem

In ``main.cc``, replace ``#include MathFunctions.h`` with:

.. literalinclude:: DownstreamComponents/main.cc
  :language: c
  :start-after: #include <string>
  :end-before: int main

Finally, use the ``Addition`` library:

.. literalinclude:: DownstreamComponents/main.cc
  :language: c
  :start-after: // calculate sum
  :end-before: return 0;

Build the ``Downstream`` project and confirm that it can find and use the
package components.
