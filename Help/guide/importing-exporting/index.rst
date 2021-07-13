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

这些命令生成 ``MathFunctionsTargets.cmake`` 文件并被计划安装在 ``lib/cmake``。该文件包含适合下游使用的代码，用于从安装树中导入安装命令中列出的所有目标。

在写入导出文件时， ``NAMESPACE`` 选项可以在这些目标名前添加 ``MathFunctions::``。双冒号约定会提示CMake当下游项目使用该名称时，该名称是一个 :prop_tgt:`IMPORTED` 的目标。这样，若无法找到提供它的包，CMake可以作出提示。

生成的导出文件包含创建 :prop_tgt:`IMPORTED` 库的代码。

.. code-block:: cmake

  # Create imported target MathFunctions::MathFunctions
  add_library(MathFunctions::MathFunctions STATIC IMPORTED)

  set_target_properties(MathFunctions::MathFunctions PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include"
  )

这段代码与我们在 `导入库`_ 一节中手工创建的示例非常相似。注意 ``${_IMPORT_PREFIX}`` 是相对于文件位置计算的。

外部项目可以使用 :command:`include` 命令加载该文件，并从安装目录中引用 ``MathFunctions`` 库，就像在自己的目录中构建一样。例如：

.. code-block:: cmake
  :linenos:

   include(${INSTALL_PREFIX}/lib/cmake/MathFunctionTargets.cmake)
   add_executable(myexe src1.c src2.c )
   target_link_libraries(myexe PRIVATE MathFunctions::MathFunctions)

第1行加载目标CMake文件。尽管我们只导出了一个目标，但该文件可以导入任意数量的目标。它们的位置是相对于文件位置计算的，以便可以容易地移动安装树。第3行引用了导入的 ``MathFunctions`` 库。生成的构建系统将从库的安装位置链接到库。

可执行文件也可以使用相同的过程导出和导入。

任意数量的目标安装都可以与相同的导出名称相关联。导出名称被认为是全局的，因此任何目录都可以提供目标安装。:command:`install(EXPORT)` 命令只需要调用一次，就可以安装一个引用所有目标的文件。下面是一个示例，演示了如何将多个导出组合成一个导出文件，即使它们位于项目的不同子目录中。

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

创建包
-----------------

与此同时， ``MathFunctions`` 项目正在导出其他项目需要使用的目标信息。我们可以通过生成一个配置文件使这个项目更容易被其他项目使用，这样CMake的 :command:`find_package` 命令就可以找到我们的项目。

一开始，我们需要向 ``CMakeLists.txt`` 文件添加一些内容。首先，包含 :module:`CMakePackageConfigHelpers` 模块，以访问一些用于创建配置文件的helper函数。

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # include CMakePackageConfigHelpers macro
  :end-before: # set version

然后，我们将创建一个包配置文件和一个包版本文件。

创建包配置文件
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

使用 :module:`CMakePackageConfigHelpers` 提供的  :command:`configure_package_config_file` 命令来生成包配置文件。注意，应该使用这个命令而不是普通的 :command:`configure_file` 命令。通过避免安装的配置文件中的硬编码路径，它有助于确保生成的包是可重定位的。提供给 ``INSTALL_DESTINATION`` 的路径必须是 ``MathFunctionsConfig.cmake`` 文件将安装的目标。我们将在下一节中研究包配置文件的内容。

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # create config file
  :end-before: # install config files

使用 :command:`INSTALL(files)` 命令安装生成的配置文件。``MathFunctionsConfigVersion.cmake`` 和 ``MathFunctionsConfig.cmake`` 都安装在相同的位置，组成一个包。

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # install config files
  :end-before: # generate the export targets for the build tree

现在我们需要创建包配置文件本身。在本例中，``Config.cmake.in`` 文件非常简单，但足以允许下游使用 :prop_tgt:`IMPORTED` 目标。

.. literalinclude:: MathFunctions/Config.cmake.in

文件的第一行只包含字符串 ``@PACKAGE_INIT@``。这将在配置文件时展开，并允许使用以 ``@PACKAGE_INIT@`` 为前缀的可重定位路径。它还提供了 ``set_and_check()`` 和 ``check_required_components()`` 两个宏。

``check_required_components`` 帮助宏通过检查所有必需的组件的 ``<Package>_<Component>_FOUND`` 变量来确保所有被请求的、非可选的组件都已经找到。这个宏应该在包配置文件的末尾调用，即使包没有任何组件。通过这种方式，CMake可以确保下游项目没有指定任何不存在的组件。如果 ``check_required_components`` 失败，``<Package>_FOUND`` 变量被设置为FALSE，就表明这个包没有找到。

宏 ``set_and_check()`` 应该在配置文件中使用，而不是用于设置目录和文件位置的常规 ``set()`` 命令。如果引用的文件或目录不存在，宏将失败。

如果 ``MathFunctions`` 包应该提供任何宏，那么这些宏应该放在单独的文件中，该文件安装在与 ``MathFunctionsConfig.cmake`` 文件相同的位置，并包含在该文件中。

**包的所有必需依赖项也必须在包配置文件中找到。** 假设项目中需要 ``Stats`` 库。在CMakeLists文件中，我们将添加：

.. code-block:: cmake

  find_package(Stats 2.6.4 REQUIRED)
  target_link_libraries(MathFunctions PUBLIC Stats::Types)

由于 ``Stats::Types`` 目标是 ``MathFunctions`` 的 ``PUBLIC`` 依赖项，下流也必须找到 ``Stats`` 包并链接到 ``Stats::Types`` 库。应该在配置文件中找到 ``Stats`` 包以确保这一点。

.. code-block:: cmake

  include(CMakeFindDependencyMacro)
  find_dependency(Stats 2.6.4)

:module:`CMakeFindDependencyMacro` 模块中的  ``find_dependency`` 宏可以传播这个包是 ``REQUIRED`` 还是 ``QUIET``， 等等。如果没有找到依赖项，``find_dependency`` 宏还将 ``MathFunctions_FOUND`` 设置为 ``False``。并提示 ``MathFunctions`` 包不能在没有 ``Stats`` 包的情况下使用。

**练习：** 向 ``MathFunctions`` 项目添加所需的库。

创建包版本文件
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:module:`CMakePackageConfigHelpers` 模块提供了 :command:`write_basic_package_version_file` 命令来创建一个简单的包版本文件。当调用 :command:`find_package` 来确定与请求版本的兼容性，并设置一些特定于版本的变量，如 ``<PackageName>_VERSION``、``<PackageName>_VERSION_MAJOR``、``<PackageName>_VERSION_MINOR``，等等时，CMake将读取该文件。更多细节请参阅 :manual:`cmake-packages <cmake-packages(7)>` 文档。

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # set version
  :end-before: # create config file

在我们的示例中，``MathFunctions_MAJOR_VERSION`` 被定义为一个 :prop_tgt:`COMPATIBLE_INTERFACE_STRING`，这意味着它必须在任何依赖项的依赖项之间兼容。通过在这个版本和下一个版本的 ``MathFunctions`` 中设置这个自定义的user属性，如果试图使用版本3和版本4，:manual:`cmake <cmake(1)>` 将发出诊断。如果包的不同主要版本被设计成不兼容的，那么包可以选择使用这种模式。


从构建目录导出目标
-------------------------------------

通常，在由外部项目使用之前，先构建和安装项目。但是，在某些情况下，最好直接从构建树导出目标。然后，这些目标可以由引用构建树的外部项目使用，而不涉及安装。:command:`export` 命令用于从项目构建树生成导出目标的文件。

如果我们想要我们的示例项目也从一个构建目录使用，我们只需要添加以下至  ``CMakeLists.txt``：

.. literalinclude:: MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # generate the export targets for the build tree

这里，我们使用 :command:`export` 命令为构建树生成导出目标。在本例中，我们将在构建目录的 ``cmake`` 子目录中创建一个名为 ``MathFunctionsTargets.cmake`` 的文件。生成的文件包含导入目标所需的代码，并且可以由知道项目构建树的外部项目加载。这个文件是特定于构建树的，并且 **是不可重定位的**。

可以创建一个合适的包配置文件和包版本文件，为构建树定义一个包，可以在不安装的情况下使用。构建树的使用者可以简单地确保 :variable:`CMAKE_PREFIX_PATH` 包含构建目录，或者将缓存中的 ``MathFunctions_DIR`` 设置为 ``<build_dir>/MathFunctions``。

该特性的一个应用示例是在交叉编译时在宿主平台上构建可执行文件。包含可执行文件的项目可以在宿主平台上构建，然后正在为另一个平台交叉编译的项目可以加载它。

构建并安装一个包
---------------------------------

至此，我们已经为我们的项目生成了一个可重定位的CMake配置，可以在项目安装后使用。让我们尝试构建 ``MathFunctions`` 项目：

.. code-block:: console

  mkdir MathFunctions_build
  cd MathFunctions_build
  cmake ../MathFunctions
  cmake --build .

在构建目录中，注意已经在 ``cmake`` 子目录中创建了 ``MathFunctionsTargets.cmake`` 文件。

现在安装项目：

.. code-block:: console

    $ cmake --install . --prefix "/home/myuser/installdir"

创建可重定位包
=============================

由 :command:`install(EXPORT)` 创建的包被设计为可重定位的，使用相对于包本身位置的路径。它们不能引用构建包的机器上的文件的绝对路径，这些文件在可能安装包的机器上不存在。

当定义 ``EXPORT`` 目标的接口时，请记住，include目录应该指定为 :variable:`CMAKE_INSTALL_PREFIX` 的相对路径，但不应该显式包含 :variable:`CMAKE_INSTALL_PREFIX`：

.. code-block:: cmake

  target_include_directories(tgt INTERFACE
    # Wrong, not relocatable:
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/include/TgtName>
  )

  target_include_directories(tgt INTERFACE
    # Ok, relocatable:
    $<INSTALL_INTERFACE:include/TgtName>
  )

``$<INSTALL_PREFIX>`` :manual:`generator expression <cmake-generator-expressions(7)>` 可以用作安装前缀的占位符，而不会导致不可重定位的包。
如果使用复杂的生成器表达式，这是必要的：

.. code-block:: cmake

  target_include_directories(tgt INTERFACE
    # Ok, relocatable:
    $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/include/TgtName>
  )

这也适用于引用外部依赖项的路径。不建议使用与依赖项相关的路径填充任何可能包含路径的属性，例如 :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` 或者 :prop_tgt:`INTERFACE_LINK_LIBRARIES`。例如，这段代码可能不适用于可重定位的包：

.. code-block:: cmake

  target_link_libraries(MathFunctions INTERFACE
    ${Foo_LIBRARIES} ${Bar_LIBRARIES}
    )
  target_include_directories(MathFunctions INTERFACE
    "$<INSTALL_INTERFACE:${Foo_INCLUDE_DIRS};${Bar_INCLUDE_DIRS}>"
    )

引用的变量可能包含到库的绝对路径及包含 **生成包的机器上** 的引用目录。这将创建一个包，其中包含指向不适合重定位的依赖项的硬编码路径。

理想情况下，这些依赖项应该通过它们自己的 :ref:`IMPORTED targets <Imported Targets>` 来使用，这些导入目标具有自己的 :prop_tgt:`IMPORTED_LOCATION` 和使用需求属性，如适当填充的 :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`。可以用  :command:`target_link_libraries` 命令让这些导入的目标和  ``MathFunctions`` 一起使用：

.. code-block:: cmake

  target_link_libraries(MathFunctions INTERFACE Foo::Foo Bar::Bar)

使用这种方法，包仅通过 :ref:`IMPORTED targets <Imported Targets>` 目标的名称引用其外部依赖项。当使用者使用已安装的包时，使用者将运行适当的 :command:`find_package` 命令（通过上面描述的 ``find_dependency`` 宏）来查找依赖项，并在自己的机器上用适当的路径填充导入的目标。

使用包配置文件
====================================

现在，我们准备创建一个项目来使用已安装的 ``MathFunctions`` 库。在本节中，我们将使用来自 ``Help\guide\importing-exporting\Downstream`` 的源代码。在这个目录中，有一个名为 ``main.cc`` 的源文件，它使用 ``MathFunctions`` 库计算给定数字的平方根，然后打印结果：

.. literalinclude:: Downstream/main.cc
  :language: c++

与前面一样，我们将从 ``CMakeLists.txt`` 文件中的 :command:`cmake_minimum_required` 命令和 :command:`project` 命令开始。对于这个项目，我们还将指定c++标准。

.. literalinclude:: Downstream/CMakeLists.txt
  :language: cmake
  :end-before: # find MathFunctions

我们可以使用 :command:`find_package` 命令：

.. literalinclude:: Downstream/CMakeLists.txt
  :language: cmake
  :start-after: # find MathFunctions
  :end-before: # create executable

创建一个可执行文件：

.. literalinclude:: Downstream/CMakeLists.txt
  :language: cmake
  :start-after: # create executable
  :end-before: # use MathFunctions library

并链接 ``MathFunctions`` 库：

.. literalinclude:: Downstream/CMakeLists.txt
  :language: cmake
  :start-after: # use MathFunctions library

就是这样！现在让我们来构建 ``Downstream`` 项目：

.. code-block:: console

  mkdir Downstream_build
  cd Downstream_build
  cmake ../Downstream
  cmake --build .

CMake配置过程中可能会出现警告：

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

将 ``CMAKE_PREFIX_PATH`` 设置为先前安装MathFunctions的位置，然后再试一次。确保新创建的可执行文件按预期运行。

添加组件
=================

让我们编辑 ``MathFunctions`` 项目以使用组件。本节的源代码可以在 ``Help\guide\importing-exporting\MathFunctionsComponents`` 中找到。这个项目的CMakeLists文件添加了两个子目录：``Addition`` 和 ``SquareRoot``。

.. literalinclude:: MathFunctionsComponents/CMakeLists.txt
  :language: cmake
  :end-before: # include CMakePackageConfigHelpers macro

生成并安装包配置文件和包版本文件：

.. literalinclude:: MathFunctionsComponents/CMakeLists.txt
  :language: cmake
  :start-after: # include CMakePackageConfigHelpers macro

如果在下游使用 :command:`find_package` 时指定了 ``COMPONENTS`` ，则它们将列在 ``<PackageName>_FIND_COMPONENTS`` 变量中。我们可以使用这个变量来验证所有必要的组件目标都包含在 ``Config.cmake.in`` 中。同时，这个函数将充当一个自定义的 ``check_required_components`` 宏，以确保下游只尝试使用受支持的组件。

.. literalinclude:: MathFunctionsComponents/Config.cmake.in

在这里， ``MathFunctions_NOT_FOUND_MESSAGE`` 被设置为由于指定了无效组件而无法找到包的诊断。当 ``_FOUND`` 变量设置为 ``False`` 时，可以设置此消息变量，并将其显示给用户。

``Addition`` 和 ``SquareRoot`` 目录是类似的。让我们看看其中一个CMakeLists文件：

.. literalinclude:: MathFunctionsComponents/SquareRoot/CMakeLists.txt
  :language: cmake

现在我们可以按照前面章节中描述的方式构建项目。要使用这个包进行测试，我们可以在 ``Help\guide\importing-exporting\DownstreamComponents`` 中使用这个项目。与之前的 ``Downstream`` 项目有两点不同。首先，我们需要找到包组件。将 ``find_package`` 行从：

.. literalinclude:: Downstream/CMakeLists.txt
  :language: cmake
  :start-after: # find MathFunctions
  :end-before: # create executable

改为：

.. literalinclude:: DownstreamComponents/CMakeLists.txt
  :language: cmake
  :start-after: # find MathFunctions
  :end-before: # create executable

并将 ``target_link_libraries`` 行从：

.. literalinclude:: Downstream/CMakeLists.txt
  :language: cmake
  :start-after: # use MathFunctions library

改为：

.. literalinclude:: DownstreamComponents/CMakeLists.txt
  :language: cmake
  :start-after: # use MathFunctions library
  :end-before: # Workaround for GCC on AIX to avoid -isystem

将 ``main.cc`` 文件中的 ``#include MathFunctions.h`` 替换为：

.. literalinclude:: DownstreamComponents/main.cc
  :language: c
  :start-after: #include <string>
  :end-before: int main

最后，使用 ``Addition`` 库：

.. literalinclude:: DownstreamComponents/main.cc
  :language: c
  :start-after: // calculate sum
  :end-before: return 0;

构建 ``Downstream`` 项目，并确认它能够找到并使用包组件。
