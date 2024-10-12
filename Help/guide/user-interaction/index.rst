用户交互指南
**********************

.. only:: html

   .. contents::

引言
============

当软件包为基于CMake的构建系统提供了软件的源代码时，软件的消费者需要运行一个CMake用户交互工\
具来构建它。

行为良好的基于CMake的构建系统不会在源目录中创建任何输出，所以通常情况下，用户执行一个源外构\
建并在那里执行构建。首先，必须指示CMake生成一个合适的构建系统，然后用户调用构建工具来处理生\
成的构建系统。生成的构建系统是特定于用来生成它的机器的，并且是不可再分布的。提供的源软件包的\
每个消费者都需要使用CMake来生成特定于他们系统的构建系统。

生成的构建系统通常应该被视为只读的。作为主要构件的CMake文件应该完全指定构建系统，并且应该没\
有理由在IDE中手动填充属性，例如在生成构建系统之后。CMake会定期重写生成的构建系统，因此用户\
的修改会被覆盖。

通过提供CMake文件，本手册中描述的功能和用户界面可用于所有基于CMake的构建系统。

当处理提供的CMake文件时，CMake工具可能会向用户报告错误，比如报告编译器不受支持，或者编译器\
不支持必需的编译选项，或者无法找到依赖项。这些错误必须由用户通过选择不同的编译器、\
:guide:`安装依赖 <使用依赖项指南>`\ 或指示CMake在哪里找到它们来解决。

cmake命令行工具
-----------------------

:manual:`cmake(1)`\ 的一个简单但典型的用法是创建一个build目录并在那里调用cmake：

.. code-block:: console

  $ cd some_software-1.4.2
  $ mkdir build
  $ cd build
  $ cmake .. -DCMAKE_INSTALL_PREFIX=/opt/the/prefix
  $ cmake --build .
  $ cmake --build . --target install

建议在到源的单独目录中构建，因为这样可以保持源目录的原始状态，允许使用多个工具链构建单个源，\
并允许通过简单地删除构建目录轻松地清除构建工件。

CMake工具可能会报告针对软件提供者的警告，而不是针对软件消费者的警告。此类警告以“此警告针对\
项目开发人员”结尾。用户可以通过向\ :manual:`cmake(1)`\ 传递\
:option:`-Wno-dev <cmake -Wno-dev>`\ 标志来禁用此类警告。

cmake-gui工具
--------------

更习惯GUI界面的用户可以使用\ :manual:`cmake-gui(1)`\ 工具来调用CMake并生成构建系统。

必须首先填充源目录和二进制目录。总是建议为源文件和构建文件使用不同的目录。

.. image:: GUI-Source-Binary.png
   :alt: 选择源码及二进制目录

生成一个构建系统
========================

有一些用户界面工具可以用来从CMake文件生成构建系统。:manual:`ccmake(1)`\ 和\
:manual:`cmake-gui(1)`\ 工具通过设置各种必要的选项指导用户。可以调用\ :manual:`cmake(1)`\
工具来在命令行上指定选项。本手册描述了可以使用任何用户界面工具设置的选项，尽管每种工具设置选\
项的方式不同。

命令行环境
------------------------

当使用命令行构建系统(如\ ``Makefiles``\ 或\ ``Ninja``)调用\ :manual:`cmake(1)`\ 时，\
有必要使用正确的构建环境以确保构建工具可用。CMake必须能够根据需要找到合适的\
:variable:`build tool <CMAKE_MAKE_PROGRAM>`、编译器、链接器和其他必要工具。

在Linux系统上，适当的工具通常在系统范围内的位置提供，并且可以通过系统包管理器随时安装。用户\
提供的或安装在非默认位置的其他工具链也可以使用。

在交叉编译时，一些平台可能需要设置环境变量，或者可能提供设置环境的脚本。

Visual Studio提供了多个命令提示符和\ ``vcvarsall.bat``\ 脚本，用于为命令行构建系统设置\
正确的环境。虽然在使用Visual Studio生成器时并不一定需要使用相应的命令行环境，但这样做无坏处。

当使用Xcode时，可以安装多个Xcode版本。使用哪种方法可以有很多不同的选择，但最常见的方法是：

* 在Xcode IDE的首选项中设置默认版本。
* 通过\ ``xcode-select``\ 命令行工具设置默认版本。
* 在运行CMake和构建工具时，通过设置\ ``DEVELOPER_DIR``\ 环境变量来覆盖默认版本。

为了方便起见，:manual:`cmake-gui(1)`\ 提供了一个环境变量编辑器。

命令行\ ``-G``\ 选项
--------------------------

CMake根据平台默认选择一个生成器。通常，默认生成器足以允许用户继续构建软件。

用户可以使用\ :option:`-G <cmake -G>`\ 选项覆盖默认生成器：

.. code-block:: console

  $ cmake .. -G Ninja

:option:`cmake --help`\ 的输出包括一个可供用户选择的\
:manual:`生成器 <cmake-generators(7)>`\ 列表。注意，生成器名称是区分大小写的。

在类Unix系统（包括Mac OS X）上，默认情况下使用\ :generator:`Unix Makefiles`\ 生成器。\
该生成器的一个变体也可以在各种环境的Windows上使用，比如\ :generator:`NMake Makefiles`\
和\ :generator:`MinGW Makefiles`\ 生成器。这些生成器生成一个\ ``Makefile``\ 变体，可\
以用\ ``make``、``gmake``、``nmake``\ 或类似工具执行。有关目标环境和工具的更多信息，请\
参见单个生成器文档。

:generator:`Ninja`\ 生成器适用于所有主要平台。``ninja``\ 是一个用法类似于\ ``make``\
的构建工具，但侧重于性能和效率。

在Windows平台上，可以使用\ :manual:`cmake(1)`\ 为Visual Studio IDE生成解决方案。\
Visual Studio版本可以通过IDE的产品名来指定，其中包含一个四位数字的年份。别名也可以用来表\
示Visual Studio版本，比如两个数字对应于VisualC++编译器的产品版本，或者两者的组合：

.. code-block:: console

  $ cmake .. -G "Visual Studio 2019"
  $ cmake .. -G "Visual Studio 16"
  $ cmake .. -G "Visual Studio 16 2019"

Visual Studio生成器可以针对不同的体系结构。可以使用\ :option:`-A <cmake -A>`\ 选项指\
定目标架构：

.. code-block:: console

  cmake .. -G "Visual Studio 2019" -A x64
  cmake .. -G "Visual Studio 16" -A ARM
  cmake .. -G "Visual Studio 16 2019" -A ARM64

在苹果平台上，:generator:`Xcode`\ 生成器可能被用来为Xcode IDE生成项目文件。

一些IDE，如KDevelop4, QtCreator和CLion，对基于CMake的构建系统有本地支持。这些IDE提供了\
选择要使用的底层生成器的用户界面，通常是在\ ``Makefile``\ 或基于\ ``Ninja``\ 的生成器之\
间进行选择。

请注意，在第一次调用CMake之后，不可能再使用\ :option:`-G <cmake -G>`\ 更改生成器。要更\
改生成器，必须先删除生成目录，并且必须从头开始生成。

当生成Visual Studio项目和解决方案文件时，在最初运行\ :manual:`cmake(1)`\ 时，可以使用其\
他几个选项。

Visual Studio工具集可以通过\ :option:`cmake -T`\ 选项指定：

.. code-block:: console

    $ # Build with the clang-cl toolset
    $ cmake.exe .. -G "Visual Studio 16 2019" -A x64 -T ClangCL
    $ # Build targeting Windows XP
    $ cmake.exe .. -G "Visual Studio 16 2019" -A x64 -T v120_xp

虽然\ :option:`-A <cmake -A>`\ 选项指定\ _target_\ 体系结构，但\
:option:`-T <cmake -T>`\ 选项可用于指定所使用的工具链的详细信息。例如，\ ``-Thost=x64``\
可用于选择64位版本的主机工具。下面演示如何使用64位工具，以及如何构建64位目标体系结构:

.. code-block:: console

    $ cmake .. -G "Visual Studio 16 2019" -A x64 -Thost=x64

在cmake-gui选择生成器
---------------------------------

“Configure”按钮会触发一个新的对话框来选择要使用的CMake生成器。

.. image:: GUI-Configure-Dialog.png
   :alt: 配置一个生成器

命令行中可用的所有生成器在\ :manual:`cmake-gui(1)`\ 中也可用。

.. image:: GUI-Choose-Generator.png
   :alt: 选择一个生成器

当选择生成器时，可以使用更多选项来设置要生成的体系结构。

.. image:: VS-Choose-Arch.png
   :alt: 选择Visual Studio生成器的体系结构

.. _`Setting Build Variables`:

设置构建变量
=======================

软件项目在调用CMake时通常需要在命令行上设置变量。下表列出了一些最常用的CMake变量：

========================================== ============================================================
 变量                                       意义
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
 :variable:`CMAKE_EXPORT_BUILD_DATABASE`    Generate a ``build_database.json``
                                            file for use with clang-based tools
========================================== ============================================================

其他特定于项目的变量可以用于控制构建，例如启用或禁用项目的组件。

对于这些变量如何在不同的构建系统之间命名，CMake没有约定，除了前缀为\ ``CMAKE_``\ 的变量通\
常引用CMake本身提供的选项，不应该在第三方选项中使用，第三方选项应该使用自己的前缀。\
:manual:`cmake-gui(1)`\ 工具可以显示由前缀定义的组中的选项，因此第三方确保使用自一致的前\
缀是有意义的。

在命令行设置变量
-------------------------------------

CMake变量可以在创建初始构建时在命令行中设置：

.. code-block:: console

    $ mkdir build
    $ cd build
    $ cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Debug

或者稍后调用\ :manual:`cmake(1)`：

.. code-block:: console

    $ cd build
    $ cmake . -DCMAKE_BUILD_TYPE=Debug

:option:`-U <cmake -U>`\ 标志可以用来取消\ :manual:`cmake(1)`\ 命令行的变量设置：

.. code-block:: console

    $ cd build
    $ cmake . -UMyPackage_DIR

最初在命令行上创建的CMake构建系统可以使用\ :manual:`cmake-gui(1)`\ 进行修改，反之亦然。

:manual:`cmake(1)`\ 工具允许使用\ :option:`-C <cmake -C>`\ 选项指定用于填充初始缓存\
的文件。这对于简化重复需要相同缓存项的命令和脚本非常有用。

在cmake-gui设置变量
--------------------------------

变量可以在cmake-gui中使用“Add Entry”按钮进行设置。这会触发一个新的对话框来设置变量的值。

.. image:: GUI-Add-Entry.png
   :alt: 编辑一个缓存项

:manual:`cmake-gui(1)`\ 用户界面的主视图可以用来编辑现有的变量。

CMake缓存
---------------

当CMake执行时，它需要找到编译器、工具和依赖项的位置。它还需要能够一致地重新生成构建系统，以\
使用相同的编译/链接标志和依赖项路径。用户还需要配置这些参数，因为它们是特定于用户系统的路径和选项。

当它第一次被执行时，CMake会在构建目录中生成一个\ ``CMakeCache.txt``\ 文件，其中包含此类\
工件的键值对。用户可以通过运行\ :manual:`cmake-gui(1)`\ 或\ :manual:`ccmake(1)`\ 工\
具查看或编辑缓存文件。这些工具提供了一个交互界面，用于重新配置所提供的软件并重新生成构建系统，\
这是在编辑缓存值之后所需要的。每个缓存条目可能都有一个相关的简短帮助文本，显示在用户界面工具中。

缓存项也可以有一种类型来表示它应该如何在用户界面中显示。例如，\ ``BOOL``\ 类型的缓存条目可\
以通过用户界面中的复选框进行编辑，``STRING``\ 可以在文本字段中进行编辑，而与\ ``STRING``\
类似的\ ``FILEPATH``\ 也应该提供一种使用文件对话框定位文件系统路径的方法。一个\ ``STRING``\
类型的条目可以提供一个允许值的限制列表，然后在\ :manual:`cmake-gui(1)`\ 用户界面的下拉菜\
单中提供(参见\ :prop_cache:`STRINGS`\ 缓存属性)。

软件包附带的CMake文件也可以使用\ :command:`option`\ 命令定义布尔切换选项。该命令创建一个\
缓存条目，该条目具有帮助文本和默认值。这类缓存条目通常特定于所提供的软件，并影响构建的配置，\
例如是否构建测试和示例，是否启用异常构建等。

预设
=======

CMake理解一个文件，\ ``CMakePresets.json``，以及它的用户特定对等体\
``CMakeUserPresets.json``，用于保存常用配置设置的预设。这些预设可以设置构建目录、生成器、\
缓存变量、环境变量和其他命令行选项。所有这些选项都可以被用户覆盖。\ ``CMakePresets.json``\
格式的详细信息在\ :manual:`cmake-presets(7)`\ 手册中列出。

在命令行使用预设
---------------------------------

当使用\ :manual:`cmake(1)`\ 命令行工具时，可以使用\ :option:`--preset <cmake --preset>`\
选项来调用预设。如果指定了\ :option:`--preset <cmake --preset>`，则不需要生成器和生成\
目录，但可以指定重写它们。例如，如果你有以下\ ``CMakePresets.json``\ 文件：

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

然后运行以下命令:

.. code-block:: console

  cmake -S /path/to/source --preset=ninja-release

这将使用\ :generator:`Ninja`\ 生成器在\ ``/path/to/source/build/ninja-release``\
中生成一个构建目录，并将\ :variable:`CMAKE_BUILD_TYPE`\ 设置为\ ``Release``。

如果你想查看可用预设的列表，你可以运行:

.. code-block:: console

  cmake -S /path/to/source --list-presets

这将列出\ ``/path/to/source/CMakePresets.json``\ 及\
``/path/to/source/CMakeUsersPresets.json``\ 中可用的预设，而不是生成构建树。

在cmake-gui使用预设
--------------------------

如果一个项目有可用的预设，包括\ ``CMakePresets.json``\ 或\ ``CMakeUserPresets.json``，\
预设列表将出现在 :manual:`cmake-gui(1)`\ 的下拉菜单中，在源目录和二进制目录之间。选择预\
置会设置二进制目录、生成器、环境变量和缓存变量，但是在选择预置之后，可以覆盖所有这些选项。

调用构建系统
========================

生成构建系统之后，可以通过调用特定的构建工具来构建软件。在IDE生成器的情况下，这可能涉及将生\
成的项目文件加载到IDE中以调用构建。

CMake知道调用构建所需的特定构建工具，所以一般来说，要在生成后从命令行构建构建系统或项目，可\
以在构建目录中调用以下命令：

.. code-block:: console

  $ cmake --build .

:option:`--build <cmake --build>`\ 标志为\ :manual:`cmake(1)`\ 工具启用了一种特定的\
操作模式。它调用与\ :manual:`生成器 <cmake-generators(7)>`\ 相关联的\
:variable:`CMAKE_MAKE_PROGRAM`\ 命令，或者调用用户配置的构建工具。

:option:`--build <cmake --build>`\ 模式还接受参数\
:option:`--target <cmake--build --target>`\ 来指定要构建的特定目标，例如特定的库、可\
执行文件或自定义目标，或者特定的特殊目标，如\ ``install``：

.. code-block:: console

  $ cmake --build . --target myexe

在多配置生成器的情况下，:option:`--build <cmake --build>`\ 模式还接受\
:option:`--config <cmake--build --config>`\ 参数来指定要构建的特定配置：

.. code-block:: console

  $ cmake --build . --target myexe --config Release

如果生成器在使用\ :variable:`CMAKE_BUILD_TYPE`\ 变量调用cmake时生成特定于配置的构建系统，\
则\ :option:`--config <cmake--build --config>`\ 选项无效。

一些构建系统省略了构建期间调用的命令行细节。:option:`--verbose <cmake--build --verbose>`\
标志可用于显示这些命令行：

.. code-block:: console

  $ cmake --build . --target myexe --verbose

:option:`--build <cmake --build>`\ 模式还可以通过在\ ``--``\ 之后列出特定的命令行选项，\
将它们传递给底层的构建工具。这对于为构建工具指定选项非常有用，例如在任务失败后继续构建，当\
CMake不提供高级用户界面时。

对于所有生成器，在调用CMake之后都可以运行底层构建工具。\
例如，\ ``make``\ 可能在使用\ :generator:`Unix Makefiles`\ 生成器生成后执行，以调用构建，\
或者\ ``ninja``\ 在使用\ :generator:`Ninja`\ 生成器生成后执行。IDE构建系统通常为构建项\
目提供命令行工具，该项目也可以被调用。

选择一个目标
------------------

CMake文件中描述的每个可执行文件和库都是一个构建目标，构建系统可以描述定制的目标，要么供内部使用，\
要么供用户使用，例如用于创建文档。

CMake为提供CMake文件的所有构建系统提供了一些内置目标。

``all``
  ``Makefile``\ 和\ ``Ninja``\ 生成器使用的默认目标。构建构建系统中的所有目标，除了那些\
  被它们的\ :prop_tgt:`EXCLUDE_FROM_ALL`\ 目标属性或\ :prop_dir:`EXCLUDE_FROM_ALL`\
  目录属性排除的目标。名称\ ``ALL_BUILD``\ 用于Xcode和Visual Studio生成器。
``help``
  列出可用于生成的目标。当使用\ :generator:`Unix Makefiles`\ 或\ :generator:`Ninja`\
  生成器时，可以使用此目标，并且确切的输出是特定于工具的。
``clean``
  删除已构建的目标文件和其他输出文件。基于\ ``Makefile``\ 的生成器为每个目录创建一个\
  ``clean``\ 目标，以便可以清理单个目录。``Ninja``\ 工具提供了自己的颗粒\ ``-t clean``\
  系统。
``test``
  运行测试。只有在CMake文件提供基于CTest的测试时，此目标才自动可用。请参见\ `运行测试`_。
``install``
  安装软件。这个目标只有在软件使用\ :command:`install`\ 命令定义安装规则时才自动可用。请\
  参见\ `软件安装`_。
``package``
  创建一个二进制包。这个目标只有在CMake文件提供基于CPack的包时才自动可用。
``package_source``
  创建源包。这个目标只有在CMake文件提供基于CPack的包时才自动可用。

对于基于\ ``Makefile``\ 的系统，提供了二进制构建目标的\ ``/fast``\ 变体。\ ``/fast``\
变体用于构建指定的目标，而不考虑其依赖关系。不检查依赖项，如果过期也不会重新生成依赖项。\
:generator:`Ninja`\ 生成器在检查依赖项时速度足够快，以确保没有为该生成器提供此类目标。

基于\ ``Makefile``\ 的系统还提供构建目标来预处理、组装和编译特定目录中的单个文件。

.. code-block:: console

  $ make foo.cpp.i
  $ make foo.cpp.s
  $ make foo.cpp.o

文件扩展名内置到目标名称中，因为可能存在另一个具有相同名称但扩展名不同的文件。但是，还提供了\
没有文件扩展名的构建目标。

.. code-block:: console

  $ make foo.i
  $ make foo.s
  $ make foo.o

在包含\ ``foo.c``\ 和\ ``foo.cpp``\ 的构建系统中，构建\ ``foo.i``\ 将预处理这两个文件。

指定一个构建程序
--------------------------

:option:`--build <cmake --build>`\ 模式调用的程序由\ :variable:`CMAKE_MAKE_PROGRAM`\
变量决定。对于大多数生成器，不需要配置特定的程序。

===================== =========================== ===========================
      生成器              默认构建程序                    其他替代     
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

``jom``\ 工具能够读取\ ``NMake``\ 风格的makefile并并行构建，而\ ``nmake``\ 工具总是串\
行构建。在使用\ :generator:`NMake Makefiles`\ 生成器生成后，用户可以运行\ ``jom``\ 而\
不是\ ``nmake``。在使用\ :generator:`NMake Makefiles`\ 生成器时，如果\
:variable:`CMAKE_MAKE_PROGRAM`\ 被设置为\ ``jom``，:option:`--build <cmake --build>`\
模式也会使用\ ``jom``，为了方便起见，提供了\ :generator:`NMake Makefiles JOM`\ 生成器\
以正常的方式找到\ ``jom``\ 并将其用作\ :variable:`CMAKE_MAKE_PROGRAM`。为了完整起见，\
``nmake``\ 是一个替代工具，它可以处理\ :generator:`NMake Makefiles JOM`\ 生成器的输出，\
但这样做将是一种悲观。

软件安装
=====================

可以在CMake缓存中设置\ :variable:`CMAKE_INSTALL_PREFIX`\ 变量，以指定在何处安装所提供\
的软件。如果提供的软件具有使用\ :command:`install`\ 命令指定的安装规则，它们将把工件安装\
到该前缀中。在Windows上，默认安装位置对应于\ ``ProgramFiles``\ 系统目录，该目录可能是特\
定于体系结构的。在Unix主机上，\ ``/usr/local``\ 是默认的安装位置。

:variable:`CMAKE_INSTALL_PREFIX`\ 变量总是指向目标文件系统上的安装前缀。

在交叉编译或打包的场景中，sysroot是只读的，或者sysroot应该保持原始状态，可以将\
:variable:`CMAKE_STAGING_PREFIX`\ 变量设置为实际安装文件的位置。

这些命令：

.. code-block:: console

  $ cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_SYSROOT=$HOME/root \
    -DCMAKE_STAGING_PREFIX=/tmp/package
  $ cmake --build .
  $ cmake --build . --target install

导致文件被安装到机器的\ ``/tmp/package/lib/libfoo.so``\ 等路径下。机器上的\
``/usr/local``\ 位置不受影响。

一些提供的软件可能会指定\ ``uninstall``\ 规则，但CMake本身默认不生成这样的规则。

运行测试
=============

:manual:`ctest(1)`\ 工具随CMake发行版一起提供，用于执行所提供的测试并报告结果。尽管提供了\
``test``\ 构建目标以运行所有可用的测试，但\ :manual:`ctest(1)`\ 工具也允许对运行哪些测\
试、如何运行它们以及如何报告结果进行细粒度控制。在构建目录中执行\ :manual:`ctest(1)`\ 相\
当于运行\ ``test``\ 目标：

.. code-block:: console

  $ ctest

可以传递正则表达式来只运行与该表达式匹配的测试。只运行以\ ``Qt``\ 命名的测试：

.. code-block:: console

  $ ctest -R Qt

正则表达式也可以排除测试。只运行名称中没有\ ``Qt``\ 的测试：

.. code-block:: console

  $ ctest -E Qt

通过向\ :manual:`ctest(1)`\ 传递\ :option:`-j <ctest -j>`\参数，可以并行运行测试：

.. code-block:: console

  $ ctest -R Qt -j8

也可以设置环境变量\ :envvar:`CTEST_PARALLEL_LEVEL`，以避免需要传递\ :option:`-j <ctest -j>`。

默认情况下，:manual:`ctest(1)`\ 不打印测试的输出。\
命令行参数\ :option:`-V <ctest -V>`\ （或\ ``--verbose``）启用verbose模式打印所有测\
试的输出。:option:`--output-on-failure <ctest --output-on-failure>`\ 选项仅打印失败\
测试的测试输出。环境变量\ :envvar:`CTEST_OUTPUT_ON_FAILURE`\ 可以设置为\ ``1``，作为将\
:option:`--output-on-failure <ctest --output-on-failure>`\ 选项传递给\
:manual:`ctest(1)`\ 的替代方法。
