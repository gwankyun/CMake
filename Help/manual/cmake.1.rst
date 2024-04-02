.. cmake-manual-description: CMake Command-Line Reference

cmake(1)
********

概要
========

.. parsed-literal::

 `生成一个项目构建系统`_
  cmake [<options>] -B <path-to-build> [-S <path-to-source>]
  cmake [<options>] <path-to-source | path-to-existing-build>

 `构建一个项目`_
  cmake --build <dir> [<options>] [-- <build-tool-options>]

 `安装一个项目`_
  cmake --install <dir> [<options>]

 `打开一个项目`_
  cmake --open <dir>

 `运行脚本`_
  cmake [-D <var>=<value>]... -P <cmake-script-file>

 `运行命令行工具`_
  cmake -E <command> [<options>]

 `运行包查找工具`_
  cmake --find-package [<options>]

 `运行工作流预设`_
  cmake --workflow [<options>]

 `查看帮助`_
  cmake --help[-<topic>]

描述
===========

:program:`cmake`\ 可执行文件是跨平台构建系统生成器CMake的命令行界面。上面\ `概要`_\ 列出\
了工具可以执行的各种操作，如下面的部分所述。

要用CMake构建一个软件项目，请\ `生成一个项目构建系统`_。可以选择使用\ :program:`cmake`\ 来\
`构建一个项目`_\ 及\ `安装一个项目`_，或者直接运行相应的构建工具（例如\ ``make``）。\
:program:`cmake`\ 也可以用来\ `查看帮助`_。

其他操作是为了让软件开发人员使用\ :manual:`CMake language <cmake-language(7)>`\ 编写\
脚本来支持他们的构建。

有关\ :program:`cmake`\ 的图形用户界面替代，请参阅\ :manual:`ccmake <ccmake(1)>`\ 和\
:manual:`cmake-gui <cmake-gui(1)>`。有关CMake测试和打包工具的命令行接口，请参考\
:manual:`ctest <ctest(1)>`\ 和\ :manual:`cpack <cpack(1)>`。

有关CMake的详细信息，请\ `另行参阅`_\ 本手册末尾的链接。


介绍CMake构建系统
==================================

*构建系统*\ 描述了如何使用\ *构建工具*\ 从其源代码中构建项目的可执行文件和库的自动化过程。\
例如，构建系统可能是一个\ ``Makefile``\ 文件，用于命令行\ ``make``\ 工具或用于集成开发环\
境（IDE）的项目文件。为了避免维护多个这样的构建系统，项目可以使用\
:manual:`CMake语言 <cmake-language(7)>`\ 编写的文件抽象地指定它的构建系统。从这些文件中，\
CMake通过一个称为\ *生成器*\ 的后端为每个用户在本地生成一个首选的构建系统。

要用CMake生成一个构建系统，必须设置以下选项：

源代码树
  包含由项目提供的源文件的顶层目录。该项目使用\ :manual:`cmake-language(7)`\ 手册中描述\
  的文件指定其构建系统，从顶层文件\ ``CMakeLists.txt``\ 开始。这些文件指定了\
  :manual:`cmake-buildsystem(7)`\ 手册中描述的构建目标及其依赖关系。

构建树
  用于存储构建系统文件和构建输出工件（例如可执行文件和库）的顶层目录。CMake将编写一个\
  ``CMakeCache.txt``\ 文件，将该目录标识为构建树，并存储持久信息，如构建系统配置选项。

  要维护原始的源代码树，请使用单独的专用构建树执行\ *源代码外*\ 构建。也支持将构建树放置在与\
  源代码树相同的目录中的\ *源代码内*\ 构建，但不鼓励这样做。

生成器
  这将选择要生成的构建系统的类型。请参阅\ :manual:`cmake-generators(7)`\ 手册获取所有生\
  成器的文档。运行\ :option:`cmake --help`\ 查看本地可用的生成器列表。可以选择使用下面的\
  :option:`-G <cmake -G>`\ 选项来指定一个生成器，或者简单地接受CMake为当前平台选择的默认\
  生成器。

  当使用\ :ref:`Command-Line Build Tool Generators`\ 时，CMake期望编译器工具链所需要\
  的环境已经在shell中配置好了。当使用\ :ref:`IDE Build Tool Generators`\ 时，不需要特\
  定的环境。

.. _`Generate a Project Buildsystem`:

生成一个项目构建系统
==============================

使用以下命令签名之一运行CMake来指定源和构建树，并生成一个构建系统：

``cmake [<options>] -B <path-to-build> [-S <path-to-source>]``

  .. versionadded:: 3.13

  使用\ ``<path-to-build>``\ 作为构建树，并使用\ ``<path-to-source>``\ 作为源码树。指\
  定的路径可以是绝对的，也可以是相对于当前工作目录的。源树码必须包含一个\ ``CMakeLists.txt``\
  文件。如果构建树还不存在，将自动创建它。例如：

  .. code-block:: console

    $ cmake -S src -B build

``cmake [<options>] <path-to-source>``
  使用当前工作目录作为构建树，并使用\ ``<path-to-source>``\ 作为源树。指定的路径可以是绝\
  对路径，也可以是相对于当前工作目录的路径。源树必须包含\ ``CMakeLists.txt``\ 文件，但\
  *不能*\ 包含\ ``CMakeCache.txt``\ 文件，因为后者标识了一个现有的构建树。例如：

  .. code-block:: console

    $ mkdir build ; cd build
    $ cmake ../src

``cmake [<options>] <path-to-existing-build>``
  使用\ ``<path-to-existing-build>``\ 作为构建树，并从其\ ``CMakeCache.txt``\ 文件加\
  载到源树的路径，该文件必须是之前运行CMake时生成的。指定的路径可以是绝对路径，也可以是相对于\
  当前工作目录的路径。例如：

  .. code-block:: console

    $ cd build
    $ cmake .

在所有情况下，\ ``<options>``\ 可以是下面的零个或多个\ `选项`_。

上述用于指定源树和构建树的样式可以混合使用。用\ :option:`-S <cmake -S>`\ 或\
:option:`-B <cmake -B>`\ 指定的路径总是分别归类为源树或构建树。使用普通参数指定的路径根据\
其内容和前面给出的路径类型进行分类。如果只给出一种类型的路径，则使用当前工作目录（cwd）作为另\
一种类型的路径。例如：

============================== ============ ===========
 命令行                          源目录        构建目录
============================== ============ ===========
 ``cmake -B build``             `cwd`        ``build``
 ``cmake -B build src``         ``src``      ``build``
 ``cmake -B build -S src``      ``src``      ``build``
 ``cmake src``                  ``src``      `cwd`
 ``cmake build`` (existing)     `loaded`     ``build``
 ``cmake -S src``               ``src``      `cwd`
 ``cmake -S src build``         ``src``      ``build``
 ``cmake -S src -B build``      ``src``      ``build``
============================== ============ ===========

.. versionchanged:: 3.23

  CMake在指定多个源路径时发出警告。这从来没有正式的文档或支持，但较旧的版本会意外地接受多个\
  源路径，并使用最后指定的路径。避免传递多个源路径参数。

在生成构建系统之后，可以使用相应的本地构建工具来构建项目。例如，在使用\
:generator:`Unix Makefiles`\ 生成器后，可以直接运行\ ``make``：

  .. code-block:: console

    $ make
    $ make install

或者，可以使用\ :program:`cmake`\ 通过自动选择和调用适当的本地构建工具来\ `构建一个项目`_。

.. _`CMake Options`:

选项
-------

.. program:: cmake

.. include:: OPTIONS_BUILD.txt

.. option:: --fresh

 .. versionadded:: 3.24

 执行构建树的新配置。这将删除任何现有的\ ``CMakeCache.txt``\ 文件和相关的\ ``CMakeFiles/``\
 目录，并从头开始重新创建它们。

.. option:: -L[A][H]

 列出非高级缓存变量。

 列表\ ``CACHE``\ 变量将运行CMake并列出CMake ``CACHE``\ 中未标记为\ ``INTERNAL``\ 或\
 :prop_cache:`ADVANCED`\ 的所有变量。这将有效地显示当前的CMake设置，然后可以使用\
 :option:`-D <cmake -D>`\ 选项进行更改。更改一些变量可能会导致创建更多变量。如果指定了\
 ``A``，那么它也将显示高级变量。如果指定了\ ``H``，它还将显示每个变量的帮助。

.. option:: -N

 仅支持查看模式。

 只加载缓存。不实际运行配置和生成步骤。

.. option:: --graphviz=<file>

 生成依赖的graphviz，参见\ :module:`CMakeGraphVizOptions`\ 获取更多信息。

 生成一个graphviz输入文件，该文件将包含项目中的所有库和可执行依赖项。更多细节请参阅\
 :module:`CMakeGraphVizOptions`\ 文档。

.. option:: --system-information [file]

 转储系统信息。

 转储关于当前系统的各种信息。如果从一个CMake项目的二进制目录顶层运行，它将转储额外的信息，\
 如缓存、日志文件等。

.. option:: --log-level=<level>

 设置日志\ ``<level>``。

 :command:`message`\ 命令只输出指定日志级别或更高级别的消息。有效的日志级别包括\
 ``ERROR``、\ ``WARNING``、\ ``NOTICE``、\ ``STATUS``\ （默认）、\ ``VERBOSE``、\
 ``DEBUG``\ 或\ ``TRACE``。

 要在CMake运行之间保持日志级别，可以将\ :variable:`CMAKE_MESSAGE_LOG_LEVEL`\ 设置为缓\
 存变量。如果同时给出了命令行选项和变量，则命令行选项优先。

 出于向后兼容的原因，\ ``--loglevel``\ 也被接受为该选项的同义词。

 .. versionadded:: 3.25
   有关\ :ref:`查询当前消息记录级别 <query_message_log_level>`\ 的方法，请参阅\
   :command:`cmake_language`\ 命令。

.. option:: --log-context

 启用附加到每个消息的\ :command:`message`\ 命令输出上下文。

 这个选项打开仅显示当前CMake运行的上下文。为了让所有后续的CMake运行都持续显示上下文，可以将\
 :variable:`CMAKE_MESSAGE_CONTEXT_SHOW`\ 设置为缓存变量。当给出这个命令行选项时，\
 :variable:`CMAKE_MESSAGE_CONTEXT_SHOW`\ 将被忽略。

.. option:: --debug-trycompile

 不要删除为\ :command:`try_compile`\ /\ :command:`try_run`\ 调用创建的文件和目录。\
 这在调试失败的检查时很有用。

 注意，:command:`try_compile`\ 的某些用法可能使用相同的构建树，如果一个项目执行多个\
 :command:`try_compile`，这将限制该选项的有用性。例如，这样的使用可能会改变结果，因为来自\
 先前尝试编译的工件可能会导致不同的测试错误地通过或失败。此选项最好仅在调试时使用。

 （与前面的命令相比，:command:`try_run`\ 命令实际上是\ :command:`try_compile`\ 命令。\
 两者的任何组合都受到所描述的潜在问题的影响。）

 .. versionadded:: 3.25

   启用此选项后，每次尝试编译检查都会打印一条日志消息，报告执行检查的目录。

.. option:: --debug-output

 将cmake置于调试模式。

 在cmake运行期间打印额外的信息，就像使用\ :command:`message(SEND_ERROR)`\ 调用进行堆栈跟踪一样。

.. option:: --debug-find

 .. versionadded:: 3.17

 将cmake find命令置于调试模式。

 在cmake运行到标准错误时打印额外的find调用信息。输出是为人类使用而不是为解析而设计的。另请参阅\
 :variable:`CMAKE_FIND_DEBUG_MODE`\ 变量，以调试项目中更局部的部分。

.. option:: --debug-find-pkg=<pkg>[,...]

 .. versionadded:: 3.23

 在调用\ :command:`find_package(\<pkg\>) <find_package>`\ 时，将cmake find命令置于\
 调试模式，其中\ ``<pkg>``\ 是给定逗号分隔的区分大小写的包名列表中的一个条目。

 类似于\ :option:`--debug-find <cmake --debug-find>`，但将作用域限制为指定的包。

.. option:: --debug-find-var=<var>[,...]

 .. versionadded:: 3.23

 使用\ ``<var>``\ 将cmake find命令置于调试模式。作为结果变量，其中\ ``<var>``\ 是给定\
 逗号分隔列表中的条目。

 类似于\ :option:`--debug-find <cmake --debug-find>`，但将作用域限制为指定的变量名。

.. option:: --trace

 将cmake置于跟踪模式。

 打印所有呼叫的轨迹和调用的来源。

.. option:: --trace-expand

 将cmake置于跟踪模式。

 类似于\ :option:`--trace <cmake --trace>`，但是变量展开了。

.. option:: --trace-format=<format>

 .. versionadded:: 3.17

 将cmake置于跟踪模式并设置跟踪输出格式。

 ``<format>``\ 可以是以下值之一。

   ``human``
     以人类可读的格式打印每个跟踪行。这是默认格式。

   ``json-v1``
     将每一行打印为一个单独的JSON文档。每个文档由换行符（``\n``）分隔。可以保证JSON文档中不会出现换行符。

     .. code-block:: json
       :caption: JSON trace format

       {
         "file": "/full/path/to/the/CMake/file.txt",
         "line": 0,
         "cmd": "add_executable",
         "args": ["foo", "bar"],
         "time": 1579512535.9687231,
         "frame": 2,
         "global_frame": 4
       }

     成员有：

     ``file``
       调用函数的CMake源文件的完整路径。

     ``line``
       ``file``\ 中函数调用开始的行。

     ``line_end``
       如果函数调用跨越多行，则该字段将设置为函数调用结束的行。如果函数调用跨越单行，这个字\
       段将被取消设置。该字段是在\ ``json-v1``\ 格式的次要版本2中添加的。

     ``defer``
       当函数调用被\ :command:`cmake_language(DEFER)`\ 延迟时出现的可选成员。如果存在，\
       它的值是一个包含延迟调用\ ``<id>``\ 的字符串。

     ``cmd``
       被调用的函数的名称。

     ``args``
       包含所有函数参数的字符串列表。

     ``time``
       函数调用的时间戳（自epoch以来的秒数）。

     ``frame``
       在当前正在处理的\ ``CMakeLists.txt``\ 的上下文中，被调用函数的堆栈帧深度。

     ``global_frame``
       被调用函数的堆栈帧深度，在跟踪涉及的所有\ ``CMakeLists.txt``\ 文件中全局跟踪。该\
       字段是在\ ``json-v1``\ 格式的次要版本2中添加的。

     此外，输出的第一个JSON文档包含当前主要和次要版本的\ ``version``\ 键

     .. code-block:: json
       :caption: JSON version format

       {
         "version": {
           "major": 1,
           "minor": 2
         }
       }

     成员有：

     ``version``
       JSON格式的版本。该版本具有遵循语义版本约定的主要和次要组件。

.. option:: --trace-source=<file>

 将cmake置于跟踪模式，但只输出指定文件的行。

 允许多个选项。

.. option:: --trace-redirect=<file>

 将cmake置于跟踪模式，并将跟踪输出重定向到文件而不是stderr。

.. option:: --warn-uninitialized

 警告未初始化的值。

 当使用未初始化的变量时打印警告。

.. option:: --warn-unused-vars

 什么也不做。在CMake 3.2及以下版本中，此功能启用了关于未使用变量的警告。在CMake 3.3到\
 3.18版本中，这个选项被破坏了。在CMake 3.19及以上版本中，该选项已被删除。

.. option:: --no-warn-unused-cli

 不要对命令行选项发出警告。

 不要查找在命令行中声明但没有使用的变量。

.. option:: --check-system-vars

 在系统文件中查找变量使用的问题。

 通常，未使用和未初始化的变量只在\ :variable:`CMAKE_SOURCE_DIR`\
 和\ :variable:`CMAKE_BINARY_DIR`\ 中搜索。这个标志告诉CMake对其他文件也发出警告。

.. option:: --compile-no-warning-as-error

 .. versionadded:: 3.24

 忽略目标属性\ :prop_tgt:`COMPILE_WARNING_AS_ERROR`\ 和变量\
 :variable:`CMAKE_COMPILE_WARNING_AS_ERROR`，防止警告在编译时被视为错误。

.. option:: --profiling-output=<path>

 .. versionadded:: 3.18

 与\ :option:`--profiling-format <cmake --profiling-format>`\ 一起使用，输出到给定\
 的路径。

.. option:: --profiling-format=<file>

 启用CMake脚本以给定格式输出分析数据。

 这有助于执行CMake脚本的性能分析。应该使用第三方应用程序将输出处理成人类可读的格式。

 目前支持的值是：\ ``google-trace``\ 输出谷歌Trace格式，可以通过谷歌Chrome的\
 about:tracing\ 选项卡或使用Trace Compass等工具的插件进行解析。

.. option:: --preset <preset>, --preset=<preset>

 从\ ``<path-to-source>/CMakePresets.json``\ 和\ ``<path-to-source>/CMakeUserPresets.json``\
 中读取\ :manual:`preset <cmake-presets(7)>`。预设可以指定生成器和构建目录，以及传递给\
 CMake的变量和其他参数的列表。当前工作目录必须包含CMake预置文件。\ :manual:`CMake GUI <cmake-gui(1)>`\
 也可以识别\ ``CMakePresets.json``\ 和\ ``CMakeUserPresets.json``\ 文件。有关这些文\
 件的详细信息，请参见\ :manual:`cmake-presets(7)`。

 在所有其他命令行选项之前读取预设。预设指定的选项（变量、生成器等）都可以通过在命令行中手动\
 指定来覆盖。例如，如果预设将名为\ ``MYVAR``\ 的变量设置为\ ``1``，但用户使用\ ``-D``\
 参数将其设置为\ ``2``，则首选值为\ ``2``。

.. option:: --list-presets[=<type>]

 列出指定\ ``<type>``\ 的可用预设。\ ``<type>``\ 的有效值是\ ``configure``、\
 ``build``、\ ``test``、\ ``package``\ 或\ ``all``。如果省略\ ``<type>``，则假定为\
 ``configure``。当前工作目录必须包含CMake预置文件。

.. option:: --debugger

  启用CMake语言的交互式调试。CMake在名为\ :option:`--debugger-pipe <cmake --debugger-pipe>`\
  的管道上公开了一个调试接口，该接口符合\ `Debug Adapter Protocol`_\ 规范，并进行了以下修改。

  ``initialize``\ 响应包括一个名为\ ``cmakeVersion``\ 的附加字段，该字段指定正在调试的\
  CMake版本。

  .. code-block:: json
    :caption: Debugger initialize response

    {
      "cmakeVersion": {
        "major": 3,
        "minor": 27,
        "patch": 0,
        "full": "3.27.0"
      }
    }

  成员包括：

  ``major``
    指定主版本号的整数。

  ``minor``
    指定次要版本号的整数。

  ``patch``
    指定补丁版本号的整数。

  ``full``
    指定完整CMake版本的字符串。

.. _`Debug Adapter Protocol`: https://microsoft.github.io/debug-adapter-protocol/

.. option:: --debugger-pipe <pipe name>, --debugger-pipe=<pipe name>

  用于调试器通信的管道（在Windows上）或域套接字（在Unix上）的名称。

.. option:: --debugger-dap-log <log path>, --debugger-dap-log=<log path>

  将所有调试器通信记录到指定文件。

.. _`Build Tool Mode`:

构建一个项目
===============

.. program:: cmake

CMake提供了一个命令行签名来构建已经生成的项目二叉树：

.. code-block:: shell

  cmake --build <dir>             [<options>] [-- <build-tool-options>]
  cmake --build --preset <preset> [<options>] [-- <build-tool-options>]

这将使用以下选项抽象出一个本机构建工具的命令行界面：

.. option:: --build <dir>

  要构建的项目二进制目录。这是必需的（除非指定了预设），并且必须放在首位。

.. program:: cmake--build

.. option:: --preset <preset>, --preset=<preset>

  使用构建预设来指定构建选项。项目二进制目录是从\ ``configurePreset``\ 键推断出来的。当前\
  工作目录必须包含CMake预置文件。有关更多详细信息，请参阅\ :manual:`preset <cmake-presets(7)>`。

.. option:: --list-presets

  列出可用的构建预设。当前工作目录必须包含CMake预置文件。

.. option:: -j [<jobs>], --parallel [<jobs>]

  .. versionadded:: 3.12

  构建时要使用的最大并发进程数。如果省略\ ``<jobs>``，则使用本机构建工具的默认数字。

  如果设置了\ :envvar:`CMAKE_BUILD_PARALLEL_LEVEL`\ 环境变量，则在未给出此选项时指定默\
  认并行级别。

  一些本地构建工具总是并行构建。\ ``<jobs>``\ 值\ ``1``\ 的使用可用于限制为单个作业。

.. option:: -t <tgt>..., --target <tgt>...

  构建\ ``<tgt>``\ 而不是默认目标。可以给出多个目标，用空格分隔。

.. option:: --config <cfg>

  对于多配置工具，选择\ ``<cfg>``\ 配置。

.. option:: --clean-first

  先构建目标\ ``clean``，然后再构建。（如果只清理，请使用\
  :option:`--target clean <cmake--build --target>`。）

.. option:: --resolve-package-references=<value>

  .. versionadded:: 3.23

  在构建之前解析来自外部包管理器（例如NuGet）的远程包引用。当\ ``<value>``\ 设置为\ ``on``\
  （默认）时，将在构建目标之前恢复包。当\ ``<value>``\ 设置为\ ``only``\ 时，将恢复包，\
  但不会执行构建。当\ ``<value>``\ 设置为\ ``off``\ 时，不恢复任何包。

  如果目标未定义任何包引用，则此选项不执行任何操作。

  该设置可以在构建预设中指定（使用\ ``resolvePackageReferences``）。如果指定了此命令行选项，\
  则将忽略预设设置。

  如果没有提供命令行参数或预设选项，将评估一个特定于环境的缓存变量，以决定是否应该执行包恢复。

  当使用Visual Studio生成器时，包引用是使用\ :prop_tgt:`VS_PACKAGE_REFERENCES`\ 属\
  性定义的。使用NuGet恢复包引用。可以通过将\ ``CMAKE_VS_NUGET_PACKAGE_RESTORE``\ 变量\
  设置为\ ``OFF``\ 来禁用它。

.. option:: --use-stderr

  忽略。行为是默认的在CMake >= 3.0。

.. option:: -v, --verbose

  启用详细输出，如果支持的话，包括要执行的构建命令。

  如果设置了\ :envvar:`VERBOSE`\ 环境变量或\ :variable:`CMAKE_VERBOSE_MAKEFILE`\
  缓存变量，则可以省略此选项。


.. option:: --

  将其余选项传递给本机工具。

运行\ :option:`cmake --build`，没有快速帮助选项。

安装一个项目
=================

.. program:: cmake

CMake提供了一个命令行签名来安装已经生成的项目二进制树：

.. code-block:: shell

  cmake --install <dir> [<options>]

这可以在构建项目后使用，以运行安装，而不使用生成的构建系统或本机构建工具。选项如下：

.. option:: --install <dir>

  要安装的项目二进制目录。这是必须的，而且必须放在首位。

.. program:: cmake--install

.. option:: --config <cfg>

  对于多配置生成器，选择\ ``<cfg>``\ 配置。

.. option:: --component <comp>

  基于组件的安装。只安装\ ``<comp>``\ 组件。

.. option:: --default-directory-permissions <permissions>

  默认目录安装权限。权限为\ ``<u=rwx,g=rx,o=rx>``\ 的格式。

.. option:: --prefix <prefix>

  覆盖安装前缀\ :variable:`CMAKE_INSTALL_PREFIX`。

.. option:: --strip

  安装前去除前后空格。

.. option:: -v, --verbose

  启用详细输出。

  如果设置了\ :envvar:`VERBOSE`\ 环境变量，则可以省略此选项。

运行\ :option:`cmake --install`，没有快速帮助选项。

打开一个项目
==============

.. program:: cmake

.. code-block:: shell

  cmake --open <dir>

在关联的应用程序中打开生成的项目。只支持部分生成器。


.. _`Script Processing Mode`:

运行脚本
============

.. program:: cmake

.. code-block:: shell

  cmake [-D <var>=<value>]... -P <cmake-script-file> [-- <unparsed-options>...]

.. program:: cmake-P

.. option:: -D <var>=<value>

 为脚本模式定义变量。

.. program:: cmake

.. option:: -P <cmake-script-file>

 将给定的cmake文件作为用CMake语言编写的脚本处理。不执行配置或生成步骤，不修改缓存。如果使用\
 ``-D``\ 定义变量，则必须在\ ``-P``\ 参数之前进行。

``--``\ 后面的任何选项都不会被CMake解析，但它们仍然包含在\
:variable:`CMAKE_ARGV<n> <CMAKE_ARGV0>`\ 传递给脚本的变量\（包括 ``--``\ 本身）。


.. _`Run a Command-Line Tool`:

运行命令行工具
=======================

.. program:: cmake

CMake通过签名提供内置命令行工具

.. code-block:: shell

  cmake -E <command> [<options>]

.. option:: -E [help]

  执行\ ``cmake -E``\ 或\ ``cmake -E help``\ 查看命令摘要。

.. program:: cmake-E

可用的命令有：

.. option:: capabilities

  .. versionadded:: 3.7

  JSON格式的cmake报表生成功能。输出是一个JSON对象，包含以下关键字：

  ``version``
    带有版本信息的JSON对象。键是：

    ``string``
      完整版本字符串，如\ :option:`--version <cmake --version>`\ 所示。
    ``major``
      以整数形式表示的主版本号。
    ``minor``
      整数形式的次要版本号。
    ``patch``
      整数形式的补丁级别。
    ``suffix``
      cmake版本后缀字符串。
    ``isDirty``
      如果生成来自脏树，则设置一个bool值。

  ``generators``
    一个可用的生成器列表。每个生成器都是一个JSON对象，具有以下键：

    ``name``
      包含生成器名称的字符串。
    ``toolsetSupport``
      如果生成器支持工具集，则为\ ``true``，否则为\ ``false``。
    ``platformSupport``
      如果生成器支持平台，则为\ ``true``，否则为\ ``false``。
    ``supportedPlatforms``
      .. versionadded:: 3.21

      当生成器通过\ :variable:`CMAKE_GENERATOR_PLATFORM` (\ :option:`-A ... <cmake -A>`\ )\
      支持平台规范时，可能存在的可选成员。该值是已知支持的平台列表。
    ``extraGenerators``
      具有与该生成器兼容的所有\ :ref:`Extra Generators`\ 的字符串列表。

  ``fileApi``
    :manual:`cmake-file-api(7)`\ 可用时出现的可选成员。该值是一个JSON对象，只有一个成员：

    ``requests``
      一个JSON数组，包含零个或多个支持的文件api请求。每个请求都是一个JSON对象，包含以下成员:

      ``kind``
        指定支持的\ :ref:`file-api object kinds`\ 之一。

      ``version``
        一个JSON数组，其每个元素都是一个JSON对象，其中包含指定非负整数版本组件的\ ``major``\
        和\ ``minor``\ 成员。

  ``serverMode``
    如果cmake支持服务器模式，则为\ ``true``，否则为\ ``false``。自CMake 3.20以来总是false。

  ``tls``
    .. versionadded:: 3.25

    如果启用了TLS支持，则为\ ``true``，否则为\ ``false``。

  ``debugger``
    .. versionadded:: 3.27

    如果支持\ :option:`--debugger <cmake --debugger>`\ 模式，则为\ ``true``，否则为\
    ``false``。

.. option:: cat [--] <files>...

  .. versionadded:: 3.18

  连接文件并在标准输出上打印。

  .. program:: cmake-E_cat

  .. option:: --

    .. versionadded:: 3.24

    增加了对双破折号参数的支持\ ``--``。\ ``cat``\ 的基本实现不支持任何选项，因此使用以\
    ``-``\ 开头的选项将导致错误。在文件以\ ``-``\ 开头的情况下，使用\ ``--``\ 来表示选项\
    的结束。

  .. versionadded:: 3.29

    ``cat``\ 现在可以通过传递\ ``-``\ 参数打印标准输入。

.. program:: cmake-E

.. option:: chdir <dir> <cmd> [<arg>...]

  更改当前工作目录并运行命令。

.. option:: compare_files [--ignore-eol] <file1> <file2>

  检查\ ``<file1>``\ 是否与\ ``<file2>``\ 相同。如果文件相同，则返回\ ``0``，否则返回\
  ``1``。如果参数无效，则返回2。

  .. program:: cmake-E_compare_files

  .. option:: --ignore-eol

    .. versionadded:: 3.14

    该选项暗示逐行比较，忽略LF/CRLF差异。

.. program:: cmake-E

.. option:: copy <file>... <destination>, copy -t <destination> <file>...

  将文件复制到\ ``<destination>``\ （文件或目录）。如果指定了多个文件，或者指定了\ ``-t`` ，\
  ``<destination>`` \ 必须是目录，并且必须存在。如果未指定\ ``-t`` ，则假定最后一个参数为\
  ``<destination>``。不支持通配符。\ ``copy``\ 遵循符号链接。这意味着它不复制符号链接，\
  而是复制它所指向的文件或目录。

  .. versionadded:: 3.5
    支持多个输入文件。

  .. versionadded:: 3.26
    支持\ ``-t``\ 参数。

.. option:: copy_directory <dir>... <destination>

  复制\ ``<dir>...``\ 目录到\ ``<destination>``\ 目录。如果\ ``<destination>``\
  目录不存在，它将被创建。\ ``copy_directory``\ 遵循符号链接。

  .. versionadded:: 3.5
    支持多个输入目录。

  .. versionadded:: 3.15
    当源目录不存在时，该命令将失败。之前，它通过创建一个空的目标目录而成功。

.. option:: copy_directory_if_different <dir>... <destination>

  .. versionadded:: 3.26

  复制\ ``<dir>...``\ 目录的更改内容到\ ``<destination>``\ 目录。如果\ ``<destination>``\
  目录不存在，它将被创建。

  ``copy_directory_if_different``\ 遵循符号链接。当源目录不存在时，命令执行失败。

.. option:: copy_if_different <file>... <destination>

  如果文件已更改，则将其复制到\ ``<destination>``\（文件或目录）。如果指定了多个文件，\
  ``<destination>``\ 必须是目录且必须存在。\ ``copy_if_different``\ 遵循符号链接。

  .. versionadded:: 3.5
    支持多个输入文件。

.. option:: create_symlink <old> <new>

  创建一个命名为\ ``<old>``\ 的符号链接\ ``<new>``。

  .. versionadded:: 3.13
    支持在Windows上创建符号链接。

  .. note::
    创建\ ``<new>``\ 符号链接的路径必须事先存在。

.. option:: create_hardlink <old> <new>

  .. versionadded:: 3.19

  创建一个硬链接\ ``<new>``\ 命名为\ ``<old>``。

  .. note::
    要创建\ ``<new>``\ 硬链接的路径必须事先存在。\ ``<old>``\ 必须事先存在。

.. option:: echo [<string>...]

  将参数显示为文本。

.. option:: echo_append [<string>...]

  将参数显示为文本，但不换行。

.. option:: env [<options>] [--] <command> [<arg>...]

  .. versionadded:: 3.1

  在修改后的环境中执行命令。选项有：

  .. program:: cmake-E_env

  .. option:: NAME=VALUE

    将\ ``NAME``\ 的当前值替换为\ ``VALUE``。

  .. option:: --unset=NAME

    取消\ ``NAME``\ 的当前值。

  .. option:: --modify ENVIRONMENT_MODIFICATION

    .. versionadded:: 3.25

    对修改后的环境应用单个\ :prop_test:`ENVIRONMENT_MODIFICATION`\ 操作。

    ``NAME=VALUE``\ 和\ ``--unset=NAME``\ 选项分别相当于\ ``--modify NAME=set:VALUE``\
    和\ ``--modify NAME=unset:``。注意\ ``--modify NAME=reset:``\ 将\ ``NAME``\
    重置为\ :program:`cmake`\ 启动（或取消设置）时的值，而不是最近的\ ``NAME=VALUE``\ 选项。

  .. option:: --

    .. versionadded:: 3.24

    增加了对双破折号参数的支持\ ``--``。使用\ ``--``\ 停止解释选项/环境变量，并将下一个参\
    数视为命令，即使它以\ ``-``\ 开头或包含\ ``=``。

.. program:: cmake-E

.. option:: environment

  显示当前环境变量。

.. option:: false

  .. versionadded:: 3.16

  什么都不做，退出代码为1。

.. option:: make_directory <dir>...

  创建\ ``<dir>``\ 目录。如果需要，也创建父目录。如果一个目录已经存在，它将被静默忽略。

  .. versionadded:: 3.5
    支持多个输入目录。

.. option:: md5sum <file>...

  以\ ``md5sum``\ 兼容格式创建文件的MD5校验和：\ ::

     351abe79cd3800b38cdfb25d45015a15  file1.txt
     052f86c15bbde68af55c7f7b340ab639  file2.txt

.. option:: sha1sum <file>...

  .. versionadded:: 3.10

  以\ ``sha1sum``\ 兼容格式创建文件的SHA1校验和：\ ::

     4bb7932a29e6f73c97bb9272f2bdc393122f86e0  file1.txt
     1df4c8f318665f9a5f2ed38f55adadb7ef9f559c  file2.txt

.. option:: sha224sum <file>...

  .. versionadded:: 3.10

  以\ ``sha224sum``\ 兼容格式创建文件的SHA224校验和：\ ::

     b9b9346bc8437bbda630b0b7ddfc5ea9ca157546dbbf4c613192f930  file1.txt
     6dfbe55f4d2edc5fe5c9197bca51ceaaf824e48eba0cc453088aee24  file2.txt

.. option:: sha256sum <file>...

  .. versionadded:: 3.10

  以\ ``sha256sum``\ 兼容格式创建文件的SHA256校验和：\ ::

     76713b23615d31680afeb0e9efe94d47d3d4229191198bb46d7485f9cb191acc  file1.txt
     15b682ead6c12dedb1baf91231e1e89cfc7974b3787c1e2e01b986bffadae0ea  file2.txt

.. option:: sha384sum <file>...

  .. versionadded:: 3.10

  以\ ``sha384sum``\ 兼容格式创建文件的SHA384校验和：\ ::

     acc049fedc091a22f5f2ce39a43b9057fd93c910e9afd76a6411a28a8f2b8a12c73d7129e292f94fc0329c309df49434  file1.txt
     668ddeb108710d271ee21c0f3acbd6a7517e2b78f9181c6a2ff3b8943af92b0195dcb7cce48aa3e17893173c0a39e23d  file2.txt

.. option:: sha512sum <file>...

  .. versionadded:: 3.10

  以\ ``sha512sum``\ 兼容格式创建文件的SHA512校验和：\ ::

     2a78d7a6c5328cfb1467c63beac8ff21794213901eaadafd48e7800289afbc08e5fb3e86aa31116c945ee3d7bf2a6194489ec6101051083d1108defc8e1dba89  file1.txt
     7a0b54896fe5e70cca6dd643ad6f672614b189bf26f8153061c4d219474b05dad08c4e729af9f4b009f1a1a280cb625454bf587c690f4617c27e3aebdf3b7a2d  file2.txt

.. option:: remove [-f] <file>...

  .. deprecated:: 3.17

  删除文件。计划的行为是，如果列出的任何文件已经不存在，该命令返回非零退出代码，但不记录任何\
  消息。在这种情况下，\ ``-f``\ 选项将行为更改为返回零退出代码（即成功）。\ ``remove``\
  不跟随符号链接。这意味着它只删除符号链接，而不删除它指向的文件。

  这个实现有很多问题，总是返回0。如果不破坏向后兼容性，就无法修复它。请使用\ ``rm``\ 代替。

.. option:: remove_directory <dir>...

  .. deprecated:: 3.17

  删除\ ``<dir>``\ 目录及其内容。如果一个目录不存在，它将被静默忽略。使用\ ``rm``\ 代替。

  .. versionadded:: 3.15
    支持多个目录。

  .. versionadded:: 3.16
    如果\ ``<dir>``\ 是指向目录的符号链接，则只删除符号链接。

.. option:: rename <oldname> <newname>

  重命名文件或目录（在一个卷上）。如果名称为\ ``<newname>``\ 的文件已经存在，那么它将被静默替换。

.. option:: rm [-rRf] [--] <file|dir>...

  .. versionadded:: 3.17

  删除文件\ ``<file>``\ 或目录\ ``<dir>``。使用\ ``-r`` 或 ``-R``\ 递归地删除目录及其\
  内容。如果列出的任何文件/目录不存在，该命令返回一个非零退出代码，但不记录任何消息。在这种情\
  况下，\ ``-f``\ 选项将行为更改为返回零退出代码（即成功）。使用\ ``--``\ 停止解释选项，并\
  将所有剩余的参数视为路径，即使它们以\ ``-``\ 开头。

.. option:: sleep <number>

  .. versionadded:: 3.0

  睡眠给定的秒\ ``<number>``。\ ``<number>``\ 可以是浮点数。由于启动/停止CMake可执行文\
  件的开销，实际的最小值大约是0.1秒。这在CMake脚本中插入延迟是很有用的：

  .. code-block:: cmake

    # Sleep for about 0.5 seconds
    execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 0.5)

.. option:: tar [cxt][vf][zjJ] file.tar [<options>] [--] [<pathname>...]

  创建或提取一个tar或zip归档文件。选项有：

  .. program:: cmake-E_tar

  .. option:: c

    创建包含指定文件的新存档。如果使用\ ``<pathname>...``\ 参数是强制性的。

  .. option:: x

    从归档文件中提取到磁盘。

    .. versionadded:: 3.15
      ``<pathname>...``\ 参数可用于仅提取选定的文件或目录。在提取选定的文件或目录时，必须\
      提供它们的确切名称，包括路径，如列表打印（\ ``-t``\ ）所示。

  .. option:: t

    列出存档内容。

    .. versionadded:: 3.15
      ``<pathname>...``\ 参数可用于仅列出选定的文件或目录。

  .. option:: v

    产生详细的输出。

  .. option:: z

    使用gzip压缩生成的归档文件。

  .. option:: j

    使用bzip2压缩生成的归档文件。

  .. option:: J

    .. versionadded:: 3.1

    使用XZ压缩生成的归档文件。

  .. option:: --zstd

    .. versionadded:: 3.15

    使用Zstandard压缩生成的归档文件。

  .. option:: --files-from=<file>

    .. versionadded:: 3.1

    从给定的文件中读取文件名，每行一个。空行将被忽略。行不能以\ ``-``\ 开头，除非\
    ``--add-file=<name>``\ 添加文件名以\ ``-``\ 开头的文件。

  .. option:: --format=<format>

    .. versionadded:: 3.3

    指定要创建的归档文件的格式。支持的格式有：\ ``7zip``、\ ``gnutar``、\ ``pax``、\
    ``paxr``\ （受限pax，默认）和\ ``zip``。

  .. option:: --mtime=<date>

    .. versionadded:: 3.1

    指定在tarball条目中记录的修改时间。

  .. option:: --touch

    .. versionadded:: 3.24

    使用当前本地时间戳，而不是从存档中提取文件时间戳。

  .. option:: --

    .. versionadded:: 3.1

    停止解释选项，并将所有剩余的参数视为文件名，即使它们以\ ``-``\ 开头。

  .. versionadded:: 3.1
    支持LZMA （7zip）。

  .. versionadded:: 3.15
    该命令现在继续向存档中添加文件，即使其中一些文件不可读。这种行为与经典的\ ``tar``\ 工具\
    更加一致。该命令现在还解析所有标志，如果提供了无效标志，则发出警告。

.. program:: cmake-E

.. option:: time <command> [<args>...]

  运行\ ``<command>``\ 并显示运行时间。（包括CMake前端的开销）。

  .. versionadded:: 3.5
    该命令现在正确地将带有空格或特殊字符的参数传递给子进程。这可能会破坏那些使用自己的额外引\
    用或转义来解决错误的脚本。

.. option:: touch <file>...

  如果文件不存在，则创建\ ``<file>``。如果\ ``<file>``\ 存在，它正在改变\ ``<file>``\
  的访问和修改时间。

.. option:: touch_nocreate <file>...

  触摸一个文件，如果它存在，但不创建它。如果一个文件不存在，它将被静默忽略。

.. option:: true

  .. versionadded:: 3.16

  什么都不做，退出代码为0。

Windows特定命令行工程
-----------------------------------

以下\ ``cmake -E``\ 命令仅在Windows操作系统下可用：

.. option:: delete_regv <key>

  删除Windows注册表值。

.. option:: env_vs8_wince <sdkname>

  .. versionadded:: 3.2

  显示一个批处理文件，该文件为VS2005中安装的Windows CE SDK设置环境。

.. option:: env_vs9_wince <sdkname>

  .. versionadded:: 3.2

  显示一个批处理文件，该文件为安装在VS2008中提供的Windows CE SDK设置环境。

.. option:: write_regv <key> <value>

  写入Windows注册表值。

.. _`Find-Package Tool Mode`:

运行包查找工具
=========================

.. program:: cmake--find-package

CMake为基于Makefile的项目提供了一个类似pkg-config的助手：

.. code-block:: shell

  cmake --find-package [<options>]

它使用\ :command:`find_package()`\ 搜索包，并将结果标记打印到stdout。这可以代替\
pkg-config在普通的基于Makefile的项目或基于autoconf的项目中找到已安装的库（通过\
``share/aclocal/cmake.m4``）。

.. note::
  由于一些技术限制，这种模式没有得到很好的支持。保留它是为了兼容，但不应该在新项目中使用。

.. _`Workflow Mode`:

运行工作流预设
=====================

.. versionadded:: 3.25

.. program:: cmake

:manual:`CMake预设 <cmake-presets(7)>`\ 提供了一种按顺序执行多个构建步骤的方法：

.. code-block:: shell

  cmake --workflow [<options>]

选项有：

.. option:: --workflow

  使用以下选项之一选择\ :ref:`Workflow Preset` 。

.. program:: cmake--workflow

.. option:: --preset <preset>, --preset=<preset>

  使用工作流预设来指定工作流。项目二进制目录是从初始配置预设推断出来的。当前工作目录必须包含\
  CMake预置文件。有关更多详细信息，请参阅\ :manual:`preset <cmake-presets(7)>` 。

.. option:: --list-presets

  列出可用的工作流预设。当前工作目录必须包含CMake预设文件。

.. option:: --fresh

  执行构建树的新配置。这将删除任何现有的\ ``CMakeCache.txt``\ 文件和相关的\ ``CMakeFiles/``\
  目录，并从头开始重新创建它们。

查看帮助
=========

.. program:: cmake

要从CMake文档中打印选定的页面，使用

.. code-block:: shell

  cmake --help[-<topic>]

有下列其中一种选择：

.. include:: OPTIONS_HELP.txt

若要查看项目可用的预设，请使用

.. code-block:: shell

  cmake <source-dir> --list-presets


.. _`CMake Exit Code`:

返回值（退出码）
========================

在常规终止时，:program:`cmake`\ 可执行文件返回退出码\ ``0``。

如果终止是由命令消息\ :command:`message(FATAL_ERROR)`\ 或其他错误条件引起的，则返回一个\
非零退出代码。


另行参阅
========

.. include:: LINKS.txt
