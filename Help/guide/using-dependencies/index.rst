使用依赖项指南
************************

.. only:: html

   .. contents::

引言
============

项目将经常依赖于其他项目、资产和工件。\
CMake提供了许多方法来将这些内容合并到构建中。\
项目和用户可以灵活地选择最适合他们需求的方法。

将依赖项引入构建的主要方法是\ :command:`find_package`\ 命令和\ :module:`FetchContent`\ 模块。\
有时也会使用\ :module:`FindPkgConfig`\ 模块，尽管它缺少其他两个模块的一些集成，在本指南中不会进一步讨论。

依赖项也可以由自定义\ :ref:`依赖提供器 <dependency_providers>`\ 提供。\
这可能是第三方的包管理器，也可能是由开发人员实现的定制代码。依赖提供器与上面提到的主要方法合作以扩展它们的灵活性。

.. _prebuilt_find_package:

利用\ ``find_package()``\ 来使用预构建包
================================================

项目所需的包可能已经构建好，并且在用户系统的某些位置可用。这个包可能也是由CMake构建的，也可能使用完全不同的构建系统。\
它甚至可能只是一个根本不需要构建的文件集合。CMake为这些场景提供了\ :command:`find_package`\ 命令。\
它搜索知名的位置，以及项目或用户提供的其他提示和路径。它还支持可选包组件和包。结果变量允许项目根据是否找到包或特定组件来定制其自己的行为。

在大多数情况下，项目通常应该使用\ :ref:`basic signature`。\
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
  不是所有的包都是CMake感知的。许多不提供支持配置模式所需的文件。对于这种情况，Find模块文件可以由项目或CMake单独提供。\
  Find模块通常是一种启发式实现，它知道包通常提供什么以及如何将包呈现给项目。因为Find模块通常是独立于包分发的，所以它们不那么可靠。\
  它们通常是分开维护的，它们可能遵循不同的发布计划，所以它们很容易过时。

根据所使用的参数，:command:`find_package`\ 可以使用上述方法中的一个或两个。\
通过将选项限制为基本签名，配置模式和模块模式都可以用来满足依赖关系。其他选项的存在可能会限制调用只能使用这两种方法中的一种，这可能会降低命令查找依赖项的能力。\
有关这个复杂主题的详细信息，请参阅\ :command:`find_package`\ 文档。

对于这两种搜索方法，用户还可以在\ :manual:`cmake(1)`\ 命令行或\ :manual:`ccmake(1)`\ 或\ :manual:`cmake-gui(1)` UI工具中设置缓存变量，以影响和覆盖查找包的位置。\
有关如何设置缓存变量的更多信息，请参阅\ :ref:`用户交互指南 <Setting Build Variables>`。

.. _Libraries providing Config-file packages:

配置文件包
--------------------

第三方提供与CMake一起使用的可执行文件、库、头文件和其他文件的首选方式是提供\ :ref:`配置文件 <Config File Packages>`。\
这些是包附带的文本文件，它们定义了CMake目标、变量、命令等。配置文件是一个普通的CMake脚本，由\ :command:`find_package`\ 命令读入。

配置文件通常可以在名称与模式\ ``lib/cmake/<PackageName>``\ 匹配的目录中找到，尽管它们可能在其他位置（参见\ :ref:`search procedure`）。\
``<PackageName>``\ 通常是\ :command:`find_package`\ 命令的第一个参数，甚至可能是唯一的参数。备选名称也可以用\ ``NAMES``\ 选项指定：

.. code-block:: cmake
  :caption: Providing alternative names when finding a package

  find_package(SomeThing
    NAMES
      SameThingOtherName   # Another name for the package
      SomeThing            # Also still look for its canonical name
  )

配置文件必须命名为\ ``<PackageName>Config.cmake``\ 或者\ ``<LowercasePackageName>-config.cmake``\ （前者用于本指南的其余部分，但两者都支持）。\
这个文件是CMake包的入口点。一个名为\ ``<PackageName>ConfigVersion.cmake``\ 的单独可选文件或\ ``<LowercasePackageName>-config-version.cmake``\ 也可能存在于同一个目录中。\
CMake使用此文件来确定包的版本是否满足调用\ :command:`find_package`\ 中包含的任何版本约束。\
调用\ :command:`find_package`\ 时指定版本是可选的，即使是\ ``<PackageName>ConfigVersion.cmake``\ 文件存在。

如果找到\ ``<PackageName>Config.cmake``\ 配置文件并且满足任何版本约束，:command:`find_package`\ 命令会认为找到的包是完整的，并假定整个包按照设计的那样完整。

可能有其他文件提供CMake命令或\ :ref:`imported targets`\ 供你使用。CMake不强制这些文件的任何命名约定。\
它们与使用CMake的\ :command:`include`\命令创建的主\ ``<PackageName>Config.cmake``\ 文件相关。\
``<PackageName>Config.cmake``\ 文件通常会为你包含这些，所以它们通常不需要任何额外的步骤，除了调用\ :command:`find_package`。

如果包的位置在\ :ref:`CMake知道的目录 <search procedure>`\ 中，那么\ :command:`find_package`\ 调用应该会成功。\
CMake知道的目录是特定于平台的。例如，使用标准系统包管理器在Linux上安装的包将自动在\ ``/usr``\ 前缀中找到。安装在Windows的\ ``Program Files``\ 中的包也会自动找到。

如果包在CMake不知道的位置，例如\ ``/opt/mylib``\ 或\ ``$HOME/dev/prefix``，将不会在没有帮助的情况下自动找到它们。\
这是一种正常的情况，CMake为用户提供了几种方法来指定在哪里找到这样的库。

:variable:`CMAKE_PREFIX_PATH`\ 变量可以\ :ref:`在调用CMake时设置 <Setting Build Variables>`。它被视为搜索\ :ref:`配置文件 <Config File Packages>`\ 的基本路径列表。\
安装在\ ``/opt/somepackage``\ 中的包通常会安装配置文件，如\ ``/opt/somepackage/lib/cmake/somePackage/SomePackageConfig.cmake``。\
在这种情况下，应该将\ ``/opt/somepackage``\ 添加到\ :variable:`CMAKE_PREFIX_PATH`\ 中。

环境变量\ ``CMAKE_PREFIX_PATH``\ 也可以用前缀填充，以搜索包。\
与\ ``PATH``\ 环境变量一样，这是一个列表，但它需要使用特定于平台的环境变量列表项分隔符（``:``\ 在Unix和\ ``;``\ 在Windows上）。

:variable:`CMAKE_PREFIX_PATH`\ 变量在需要指定多个前缀的情况下提供了方便，或者在同一个前缀下可以使用多个包。\
包的路径也可以通过设置匹配\ ``<PackageName>_DIR``\ 的变量来指定，例如\ ``SomePackage_DIR``。\
注意，这不是一个前缀，而是一个包含配置风格包文件的目录的完整路径，例如上面的例子中的\ ``/opt/somepackage/lib/cmake/SomePackage``。\
有关可能影响搜索的其他CMake变量和环境变量，请参阅\ :command:`find_package`\ 文档。

.. _Libraries not Providing Config-file Packages:

Find模块文件
-----------------

不提供配置文件的包仍然可以通过\ :command:`find_package`\ 命令找到，如果已获取\ ``FindSomePackage.cmake``\ 文件。\
这些Find模块文件与配置文件不同：

#. 查找模块文件不应该由包本身提供。
#. ``Find<PackageName>.cmake``\ 文件不指示包的可用性，也不指示包的任何特定部分。
#. CMake不会搜索在\ :variable:`CMAKE_PREFIX_PATH`\ 变量中为Find指定的\ ``Find<PackageName>.cmake``\ 文件位置。\
   相反，CMake会在\ :variable:`CMAKE_MODULE_PATH`\ 变量给出的位置中搜索这些文件。\
   用户在运行CMake时设置\ :variable:`CMAKE_MODULE_PATH`\ 是很常见的，\
   而且CMake项目通常会将\ :variable:`CMAKE_MODULE_PATH`\ 附加到\ :variable:`CMAKE_MODULE_PATH`\ 中，以允许使用本地Find模块文件。
#. CMake搭载一些\ :manual:`第三方包 <cmake-modules(7)>`\ 的\ ``Find<PackageName>.cmake``
   文件。这些文件由CMake维护负担，它们落后于与它们相关的包的最新版本是很正常的。\
   一般来说，新的Find模块不再添加到CMake中。项目应该鼓励上游包在可能的情况下提供配置文件。\
   如果不成功，项目应该为包提供自己的Find模块。

有关如何编写Find模块文件的详细讨论，请参见\ :ref:`Find Modules`。

.. _Imported Targets from Packages:

导入目标
----------------

配置文件和查找模块文件都可以定义\ :ref:`Imported targets`。它们通常具有\ ``SomePrefix::ThingName``\ 形式的名称。\
在可用的情况下，项目应该更倾向于使用它们，而不是可能还提供的任何CMake变量。\
这样的目标通常携带使用需求，并自动将诸如头搜索路径、编译器定义等应用到链接到它们的其他目标（例如使用\ :command:`target_link_libraries`\ ）。\
这比试图手动使用变量应用相同的东西更健壮，也更方便。检查包或Find模块的文档，查看它定义的导入目标（如果有的话）。

导入的目标还应该封装任何特定于配置的路径。这包括二进制文件（库、可执行文件）、编译器标志和任何其他依赖于配置的数量的位置。\
在提供这些细节方面，Find模块可能不如配置文件可靠。

一个完整的找到第三方包并使用其中的库的示例可能如下所示：

.. code-block:: cmake

  cmake_minimum_required(VERSION 3.10)
  project(MyExeProject VERSION 1.0.0)

  # Make project-provided Find modules available
  list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

  find_package(SomePackage REQUIRED)
  add_executable(MyExe main.cpp)
  target_link_libraries(MyExe PRIVATE SomePrefix::LibName)

注意，上面对\ :command:`find_package`\ 的调用可以通过配置文件或Find模块解析。\
它只使用\ :ref:`basic signature`\ 支持的基本参数。\
例如，\ ``${CMAKE_CURRENT_SOURCE_DIR}/cmake``\ 目录中的\ ``FindSomePackage.cmake``\ 文件将允许\ :command:`find_package`\ 命令使用模块模式成功执行。\
如果不存在这样的模块文件，系统将搜索配置文件。


使用\ ``FetchContent``\ 从源代码下载和构建
==========================================================

在CMake中使用依赖关系不一定要预先构建。它们可以作为主项目的一部分从源代码构建。\
:module:`FetchContent`\ 模块提供了下载内容（通常是源代码，但也可以是任何内容）并将其添加到主项目（如果依赖项也使用CMake）的功能。\
依赖项的源码将与项目的其余部分一起构建，就好像这些源码是项目自己的源码的一部分一样。

一般的模式是，项目应该首先声明它想要使用的所有依赖项，然后要求它们可用。\
下面演示了原理（更多信息请参见\ :ref:`fetch-content-examples`）：

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
    GIT_TAG        605a34765aa5d5ecbf476b4598a862ada971b0cc # v3.0.1
  )
  FetchContent_MakeAvailable(googletest Catch2)

支持各种下载方法，包括从URL下载和提取存档（支持一系列存档格式），以及许多存储库格式，包括Git、Subversion和Mercurial。\
还可以使用自定义下载、更新和补丁命令来支持任意用例。

当使用\ :module:`FetchContent`\ 将依赖项添加到项目中时，项目将链接到依赖项的目标，就像项目中的任何其他目标一样。\
如果依赖项提供了\ ``SomePrefix::ThingName``\ 形式的命名空间目标，项目应该链接到这些目标，而不是任何非命名空间目标。\
请参阅下一节了解为什么推荐这样做。

并不是所有的依赖关系都可以通过这种方式引入项目。一些依赖项定义的目标名称与项目或其他依赖项中的其他目标冲突。\
由\ :command:`add_executable`\ 和\ :command:`add_library`\ 创建的具体可执行文件和库目标是全局的，\
因此在整个构建过程中每个目标都必须是唯一的。如果依赖项将添加冲突的目标名称，则不能使用此方法将其直接带入构建中。

``FetchContent``\ 和\ ``find_package()``\ 集成
===================================================

.. versionadded:: 3.24

一些依赖项支持由\ :command:`find_package`\ 或\ :module:`FetchContent`\ 添加。\
这样的依赖关系必须确保它们在安装和从源代码构建的场景中定义相同的名称空间目标。\
然后，消费项目链接到这些名称空间的目标，并且可以透明地处理这两种场景，只要项目不使用这两种方法之外的任何东西。

项目可以通过使用\ ``FIND_PACKAGE_ARGS``\ 选项的\ :command:`FetchContent_Declare`\ 来表示它乐意接受依赖项。\
这允许\ :command:`FetchContent_MakeAvailable`\ 尝试先调用\ :command:`find_package`\ 来满足依赖关系，\
使用\ ``FIND_PACKAGE_ARGS``\ 关键字后面的参数（如果有的话）。如果没有找到依赖项，则按照前面所述从源代码构建依赖项。

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

上面的例子首先调用\ :command:`find_package(googletest NAMES GTest) <find_package>`。\
CMake提供了一个\ :module:`FindGTest`\ 模块，所以如果它发现了一个安装在某处的GTest包，\
它将使其可用，并且依赖关系不会从源代码构建。如果没有找到GTest包，\ *将*\ 从源代码构建它。\
在任何一种情况下，\ ``GTest::gtest_main``\ 目标都需要被定义，因此我们将单元测试可执行文件链接到该目标。

高级控件也可以通过\ :variable:`FETCHCONTENT_TRY_FIND_PACKAGE_MODE`\ 变量获得。\
可以将其设置为\ ``NEVER``\ 以禁用所有对\ :command:`find_package`\ 的重定向。\
即使没有指定\ ``FIND_PACKAGE_ARGS``，也可以将其设置为\ ``ALWAYS``\ 以尝试\ :command:`find_package`\ （这应该谨慎使用）。

项目还可能决定必须从源代码构建特定的依赖项。如果需要补丁或未发布的依赖项版本，\
或者满足某些要求从源代码构建所有依赖项的策略，则可能需要这样做。\
项目可以通过向\ :command:`FetchContent_Declare`\ 添加\ ``OVERRIDE_FIND_PACKAGE``\ 关键字来强制执行这一点。\
对该依赖项的\ :command:`find_package`\ 调用将被重定向到\ :command:`FetchContent_MakeAvailable`。

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

有关更高级的用例，请参阅\ :variable:`CMAKE_FIND_PACKAGE_REDIRECTS_DIR`\ 变量。

.. _dependency_providers_overview:

依赖提供器
====================

.. versionadded:: 3.24

上一节讨论了项目可用于指定其依赖项的技术。理想情况下，项目不应该真正关心依赖项来自何处，\
只要它提供了它所期望的东西（通常只是一些导入的目标）。在没有任何其他细节的情况下，\
项目说明了它需要什么，还可能指定从哪里获得它，因此它仍然可以开箱即用。

另一方面，开发人员可能更感兴趣的是控制\ *如何*\ 向项目提供依赖项。你可能希望使用自己构建的包的特定版本。\
你可能希望使用第三方包管理器。出于安全性或性能原因，你可能希望将一些请求重定向到你控制的系统上的不同URL。\
CMake通过\ :ref:`依赖提供器 <dependency_providers>`\ 支持这类场景。

依赖提供器可以设置为拦截\ :command:`find_package`\ 和\ :command:`FetchContent_MakeAvailable`\ 调用。\
提供器有机会满足这些请求，如果提供器不能满足这些请求，就会返回到内置实现。

只能设置一个依赖提供器，并且只能在CMake运行早期的一个非常特定的位置设置它。\
:variable:`CMAKE_PROJECT_TOP_LEVEL_INCLUDES`\ 变量列出了将在处理第一个\ :command:`project()`\ 调用（并且仅该调用）时读取的CMake文件。\
这是唯一可以设置依赖项提供器的时间。在整个项目中，最多只能使用一个单一的提供者。

对于某些场景，用户不需要知道依赖提供器是如何设置的细节。\
第三方可能会提供一个可以添加到\ :variable:`CMAKE_PROJECT_TOP_LEVEL_INCLUDES`\ 的文件，\
该文件将代表用户建立依赖提供器。这是包管理器的推荐方法。开发人员可以像这样使用这样的文件::

  cmake -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=/path/to/package_manager/setup.cmake ...

有关如何实现你自己的自定义依赖提供器的详细信息，请参阅\ :command:`cmake_language(SET_DEPENDENCY_PROVIDER)`\ 命令。
