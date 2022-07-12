.. cmake-manual-description: CMake Command-Line Reference

cmake(1)
********

概要
========

.. parsed-literal::

 `生成一个项目构建系统`_
  cmake [<options>] <path-to-source>
  cmake [<options>] <path-to-existing-build>
  cmake [<options>] -S <path-to-source> -B <path-to-build>

 `构建一个项目`_
  cmake --build <dir> [<options>] [-- <build-tool-options>]

 `安装一个项目`_
  cmake --install <dir> [<options>]

 `打开一个项目`_
  cmake --open <dir>

 `运行脚本`_
  cmake [{-D <var>=<value>}...] -P <cmake-script-file>

 `运行命令行工具`_
  cmake -E <command> [<options>]

 `运行包查找工具`_
  cmake --find-package [<options>]

 `查看帮助`_
  cmake --help[-<topic>]

描述
===========

**cmake**\ 可执行文件是跨平台构建系统生成器CMake的命令行界面。上面\ `概要`_\ 列出了工具可以执行的各种操作，如下面的部分所述。

要用CMake构建一个软件项目，请\ `生成一个项目构建系统`_。可以选择使用\ **cmake**\ 来\ `构建一个项目`_\ 及\ `安装一个项目`_，或者直接运行相应的构建工具（例如\ ``make``）。**cmake**\ 也可以用来\ `查看帮助`_。

其他操作是为了让软件开发人员使用\ :manual:`CMake language <cmake-language(7)>`\ 编写脚本来支持他们的构建。

有关\ **cmake**\ 的图形用户界面替代，请参阅\ :manual:`ccmake <ccmake(1)>`\ 和\ :manual:`cmake-gui <cmake-gui(1)>`。有关CMake测试和打包工具的命令行接口，请参考\ :manual:`ctest <ctest(1)>`\ 和\ :manual:`cpack <cpack(1)>`。

有关CMake的详细信息，请\ `另行参阅`_\ 本手册末尾的链接。


介绍CMake构建系统
==================================

*构建系统*\ 描述了如何使用\ *构建工具*\ 从其源代码中构建项目的可执行文件和库的自动化过程。例如，构建系统可能是一个\ ``Makefile``\ 文件，用于命令行\ ``make``\ 工具或用于集成开发环境（IDE）的项目文件。为了避免维护多个这样的构建系统，项目可以使用\ :manual:`CMake语言 <cmake-language(7)>`\ 编写的文件抽象地指定它的构建系统。从这些文件中，CMake通过一个称为\ *生成器*\ 的后端为每个用户在本地生成一个首选的构建系统。

要用CMake生成一个构建系统，必须设置以下选项：

源代码树
  包含由项目提供的源文件的顶层目录。该项目使用\ :manual:`cmake-language(7)`\ 手册中描述的文件指定其构建系统，从顶层文件\ ``CMakeLists.txt``\ 开始。这些文件指定了\ :manual:`cmake-buildsystem(7)`\ 手册中描述的构建目标及其依赖关系。

构建树
  用于存储构建系统文件和构建输出工件（例如可执行文件和库）的顶层目录。CMake将编写一个\ ``CMakeCache.txt``\ 文件，将该目录标识为构建树，并存储持久信息，如构建系统配置选项。

  要维护原始的源代码树，请使用单独的专用构建树执行\ *源代码外*\ 构建。也支持将构建树放置在与源代码树相同的目录中的\ *源代码内*\ 构建，但不鼓励这样做。

生成器
  它选择要生成的构建系统的类型。有关所有生成器的文档，请参阅\ :manual:`cmake-generators(7)`\ 手册。运行\ ``cmake --help``\ 查看本地可用的生成器列表。可以选择使用下面的\ ``-G``\ 选项来指定生成器，或者简单地接受CMake在当前平台的默认选项。

  当使用\ :ref:`Command-Line Build Tool Generators`\ 时，CMake期望编译器工具链所需要的环境已经在shell中配置好了。当使用\ :ref:`IDE Build Tool Generators`\ 时，不需要特定的环境。

.. _`Generate a Project Buildsystem`:

生成一个项目构建系统
==============================

使用以下命令签名之一运行CMake，指定源和构建树，并生成一个构建系统：

``cmake [<options>] <path-to-source>``
  使用当前工作目录作为构建树，并使用\ ``<path-to-source>``\ 作为源树。指定的路径可以是绝对路径，也可以是相对于当前工作目录的路径。源树必须包含\ ``CMakeLists.txt``\ 文件，但\ *不能*\ 包含\ ``CMakeCache.txt``\ 文件，因为后者标识了一个现有的构建树。例如：

  .. code-block:: console

    $ mkdir build ; cd build
    $ cmake ../src

``cmake [<options>] <path-to-existing-build>``
  使用\ ``<path-to-existing-build>``\ 作为构建树，并从其\ ``CMakeCache.txt``\ 文件加载到源树的路径，该文件必须是之前运行CMake时生成的。指定的路径可以是绝对路径，也可以是相对于当前工作目录的路径。例如：

  .. code-block:: console

    $ cd build
    $ cmake .

``cmake [<options>] -S <path-to-source> -B <path-to-build>``
  使用\ ``<path-to-build>``\ 作为构建树，使用\ ``<path-to-source>``\ 作为源树。指定的路径可以是绝对路径或相对于当前工作目录的路径。源树必须包含一个\ ``CMakeLists.txt``\ 文件。如果构建树不存在，将自动创建它。例如：

  .. code-block:: console

    $ cmake -S src -B build

在所有情况下，``<options>``\ 可能是下面\ `选项`_\ 的零或多个。

上面用于指定源树和构建树的样式可以混合使用。用\ ``-S``\ 或\ ``-B``\ 指定的路径总是被分别归类为源树或构建树。用普通参数指定的路径根据它们的内容和前面给出的路径类型进行分类。如果只给出一种路径类型，则使用当前工作目录（cwd）作为另一种。例如：

============================== ============ ===========
 命令行                          源目录        构建目录
============================== ============ ===========
 ``cmake src``                  ``src``      `cwd`
 ``cmake build`` (existing)     `loaded`     ``build``
 ``cmake -S src``               ``src``      `cwd`
 ``cmake -S src build``         ``src``      ``build``
 ``cmake -S src -B build``      ``src``      ``build``
 ``cmake -B build``             `cwd`        ``build``
 ``cmake -B build src``         ``src``      ``build``
 ``cmake -B build -S src``      ``src``      ``build``
============================== ============ ===========

.. versionchanged:: 3.23

  CMake在指定多个源路径时发出警告。这从来没有正式的文档或支持，但较旧的版本会意外地接受多个源路径，并使用最后指定的路径。避免传递多个源路径参数。

在生成构建系统之后，可以使用相应的本地构建工具来构建项目。例如，在使用\ :generator:`Unix Makefiles`\ 生成器后，可以直接运行\ ``make``：

  .. code-block:: console

    $ make
    $ make install

或者，可以使用\ **cmake**\ 通过自动选择和调用适当的本地构建工具来\ `构建一个项目`_。

.. _`CMake Options`:

选项
-------

.. include:: OPTIONS_BUILD.txt

``--fresh``
 .. versionadded:: 3.24

 执行构建树的新配置。这将删除任何现有的\ ``CMakeCache.txt``\ 文件和相关的\ ``CMakeFiles/``\ 目录，并从头开始重新创建它们。

``-L[A][H]``
 列出非高级缓存变量。

 列表\ ``CACHE``\ 变量将运行CMake，并从CMake ``CACHE``\ 中列出所有未标记为\ ``INTERNAL``\ 或\ :prop_cache:`ADVANCED`\ 的变量。这将有效地显示当前的CMake设置，然后可以使用\ ``-D``\ 选项更改。改变一些变量可能会产生更多的变量。如果指定了\ ``A``，那么它还将显示高级变量。如果指定了\ ``H``，它还将为每个变量显示帮助。

``-N``
 视图模式。

 只加载缓存。不实际运行配置和生成步骤。

``--graphviz=[file]``
 生成依赖的graphviz，参见\ :module:`CMakeGraphVizOptions`\ 获取更多信息。

 生成一个graphviz输入文件，该文件将包含项目中的所有库和可执行依赖项。更多细节请参阅\ :module:`CMakeGraphVizOptions`\ 文档。

``--system-information [file]``
 转储系统信息。

 转储关于当前系统的各种信息。如果从一个CMake项目的二进制目录顶层运行，它将转储额外的信息，如缓存、日志文件等。

``--log-level=<ERROR|WARNING|NOTICE|STATUS|VERBOSE|DEBUG|TRACE>``
 设置日志级别。

 :command:`message`\ 命令将只输出指定日志级别或更高级别的消息。默认日志级别为\ ``STATUS``。

 要在CMake运行之间保持日志级别，可以将\ :variable:`CMAKE_MESSAGE_LOG_LEVEL`\ 设置为缓存变量。如果同时给出了命令行选项和变量，则命令行选项优先。

 出于向后兼容的原因，``--loglevel``\ 也被接受为该选项的同义词。

``--log-context``
 启用\ :command:`message`\ 命令输出附加到每个消息的上下文。

 这个选项打开仅显示当前CMake运行的上下文。为了让所有后续的CMake运行都持续显示上下文，可以将\ :variable:`CMAKE_MESSAGE_CONTEXT_SHOW`\ 设置为缓存变量。当给出这个命令行选项时，:variable:`CMAKE_MESSAGE_CONTEXT_SHOW`\ 将被忽略。

``--debug-trycompile``
 不删除\ :command:`try_compile`\ 构建树。一次只对一个\ :command:`try_compile`\ 有用。

 不删除为\ :command:`try_compile`\ 调用创建的文件和目录。这在调试失败的try_compile时很有用。但是，它可能将try-compile的结果更改为以前try-compile的旧数据，可能导致不同的测试错误地通过或失败。这个选项最好一次只用于一个try-compile，并且只在调试时使用。

``--debug-output``
 将cmake置于调试模式。

 在cmake运行期间打印额外的信息，就像使用\ :command:`message(SEND_ERROR)`\ 调用进行堆栈跟踪一样。

``--debug-find``
 将cmake find命令置于调试模式。

 在cmake运行到标准错误时打印额外的find调用信息。输出是为人们使用而设计的，而不是为解析设计的。请参阅\ :variable:`CMAKE_FIND_DEBUG_MODE`\ 变量来调试项目中更局部的部分。

``--debug-find-pkg=<pkg>[,...]``
 当在调用\ :command:`find_package(\<pkg\>) <find_package>`\ 下运行时，将cmake find命令置于调试模式，其中\ ``<pkg>``\ 是给定的以逗号分隔的包名列表中的一个条目，包名区分大小写。

 类似于\ ``--debug-find``，但将作用域限制为指定的包。

``--debug-find-var=<var>[,...]``
 当使用\ ``<var>``\ 作为结果变量调用时，将cmake find命令置于调试模式，其中\ ``<var>``\ 是给定的逗号分隔列表中的条目。

 类似于\ ``--debug-find``，但将作用域限制为指定的变量名。

``--trace``
 将cmake设置为跟踪模式。

 打印所有呼叫的轨迹和调用的来源。

``--trace-expand``
 将cmake设置为跟踪模式。

 类似于\ ``--trace``，但是扩展了变量。

``--trace-format=<format>``
 Put cmake in trace mode and sets the trace output format.

 ``<format>`` can be one of the following values.

   ``human``
     Prints each trace line in a human-readable format. This is the
     default format.

   ``json-v1``
     Prints each line as a separate JSON document. Each document is
     separated by a newline ( ``\n`` ). It is guaranteed that no
     newline characters will be present inside a JSON document.

     JSON trace format:

     .. code-block:: json

       {
         "file": "/full/path/to/the/CMake/file.txt",
         "line": 0,
         "cmd": "add_executable",
         "args": ["foo", "bar"],
         "time": 1579512535.9687231,
         "frame": 2,
         "global_frame": 4
       }

     The members are:

     ``file``
       The full path to the CMake source file where the function
       was called.

     ``line``
       The line in ``file`` where the function call begins.

     ``line_end``
       If the function call spans multiple lines, this field will
       be set to the line where the function call ends. If the function
       calls spans a single line, this field will be unset. This field
       was added in minor version 2 of the ``json-v1`` format.

     ``defer``
       Optional member that is present when the function call was deferred
       by :command:`cmake_language(DEFER)`.  If present, its value is a
       string containing the deferred call ``<id>``.

     ``cmd``
       The name of the function that was called.

     ``args``
       A string list of all function parameters.

     ``time``
       Timestamp (seconds since epoch) of the function call.

     ``frame``
       Stack frame depth of the function that was called, within the
       context of the  ``CMakeLists.txt`` being processed currently.

     ``global_frame``
       Stack frame depth of the function that was called, tracked globally
       across all ``CMakeLists.txt`` files involved in the trace. This field
       was added in minor version 2 of the ``json-v1`` format.

     Additionally, the first JSON document outputted contains the
     ``version`` key for the current major and minor version of the

     JSON trace format:

     .. code-block:: json

       {
         "version": {
           "major": 1,
           "minor": 2
         }
       }

     The members are:

     ``version``
       Indicates the version of the JSON format. The version has a
       major and minor components following semantic version conventions.

``--trace-source=<file>``
 Put cmake in trace mode, but output only lines of a specified file.

 Multiple options are allowed.

``--trace-redirect=<file>``
 Put cmake in trace mode and redirect trace output to a file instead of stderr.

``--warn-uninitialized``
 Warn about uninitialized values.

 Print a warning when an uninitialized variable is used.

``--warn-unused-vars``
 Does nothing.  In CMake versions 3.2 and below this enabled warnings about
 unused variables.  In CMake versions 3.3 through 3.18 the option was broken.
 In CMake 3.19 and above the option has been removed.

``--no-warn-unused-cli``
 Don't warn about command line options.

 Don't find variables that are declared on the command line, but not
 used.

``--check-system-vars``
 Find problems with variable usage in system files.

 Normally, unused and uninitialized variables are searched for only
 in :variable:`CMAKE_SOURCE_DIR` and :variable:`CMAKE_BINARY_DIR`.
 This flag tells CMake to warn about other files as well.

``--compile-no-warning-as-error``
 Ignore target property :prop_tgt:`COMPILE_WARNING_AS_ERROR` and variable
 :variable:`CMAKE_COMPILE_WARNING_AS_ERROR`, preventing warnings from being
 treated as errors on compile.

``--profiling-output=<path>``
 Used in conjunction with ``--profiling-format`` to output to a given path.

``--profiling-format=<file>``
 Enable the output of profiling data of CMake script in the given format.

 This can aid performance analysis of CMake scripts executed. Third party
 applications should be used to process the output into human readable format.

 Currently supported values are:
 ``google-trace`` Outputs in Google Trace Format, which can be parsed by the
 about:tracing tab of Google Chrome or using a plugin for a tool like Trace
 Compass.

``--preset <preset>``, ``--preset=<preset>``
 Reads a :manual:`preset <cmake-presets(7)>` from
 ``<path-to-source>/CMakePresets.json`` and
 ``<path-to-source>/CMakeUserPresets.json``. The preset may specify the
 generator and the build directory, and a list of variables and other
 arguments to pass to CMake. The current working directory must contain
 CMake preset files. The :manual:`CMake GUI <cmake-gui(1)>` can
 also recognize ``CMakePresets.json`` and ``CMakeUserPresets.json`` files. For
 full details on these files, see :manual:`cmake-presets(7)`.

 The presets are read before all other command line options. The options
 specified by the preset (variables, generator, etc.) can all be overridden by
 manually specifying them on the command line. For example, if the preset sets
 a variable called ``MYVAR`` to ``1``, but the user sets it to ``2`` with a
 ``-D`` argument, the value ``2`` is preferred.

``--list-presets, --list-presets=<[configure | build | test | all]>``
 Lists the available presets. If no option is specified only configure presets
 will be listed. The current working directory must contain CMake preset files.

.. _`Build Tool Mode`:

构建一个项目
===============

CMake提供了一个命令行签名来构建一个已经生成的项目二进制树：

.. code-block:: shell

  cmake --build <dir>             [<options>] [-- <build-tool-options>]
  cmake --build --preset <preset> [<options>] [-- <build-tool-options>]

这将使用以下选项抽象出一个本机构建工具的命令行界面：

``--build <dir>``
  Project binary directory to be built.  This is required (unless a preset
  is specified) and must be first.

``--preset <preset>``, ``--preset=<preset>``
  Use a build preset to specify build options. The project binary directory
  is inferred from the ``configurePreset`` key. The current working directory
  must contain CMake preset files.
  See :manual:`preset <cmake-presets(7)>` for more details.

``--list-presets``
  Lists the available build presets. The current working directory must
  contain CMake preset files.

``--parallel [<jobs>], -j [<jobs>]``
  The maximum number of concurrent processes to use when building.
  If ``<jobs>`` is omitted the native build tool's default number is used.

  The :envvar:`CMAKE_BUILD_PARALLEL_LEVEL` environment variable, if set,
  specifies a default parallel level when this option is not given.

  Some native build tools always build in parallel.  The use of ``<jobs>``
  value of ``1`` can be used to limit to a single job.

``--target <tgt>..., -t <tgt>...``
  Build ``<tgt>`` instead of the default target.  Multiple targets may be
  given, separated by spaces.

``--config <cfg>``
  For multi-configuration tools, choose configuration ``<cfg>``.

``--clean-first``
  Build target ``clean`` first, then build.
  (To clean only, use ``--target clean``.)

``--resolve-package-references=<on|off|only>``
  .. versionadded:: 3.23

  Resolve remote package references from external package managers (e.g. NuGet)
  before build. When set to ``on`` (default), packages will be restored before
  building a target. When set to ``only``, the packages will be restored, but no
  build will be performed. When set to ``off``, no packages will be restored.

  If the target does not define any package references, this option does nothing.

  This setting can be specified in a build preset (using
  ``resolvePackageReferences``). The preset setting will be ignored, if this
  command line option is specified.

  If no command line parameter or preset option are provided, an environment-
  specific cache variable will be evaluated to decide, if package restoration
  should be performed.

  When using the Visual Studio generator, package references are defined
  using the :prop_tgt:`VS_PACKAGE_REFERENCES` property. Package references
  are restored using NuGet. It can be disabled by setting the
  ``CMAKE_VS_NUGET_PACKAGE_RESTORE`` variable to ``OFF``.

``--use-stderr``
  Ignored.  Behavior is default in CMake >= 3.0.

``--verbose, -v``
  Enable verbose output - if supported - including the build commands to be
  executed.

  This option can be omitted if :envvar:`VERBOSE` environment variable or
  :variable:`CMAKE_VERBOSE_MAKEFILE` cached variable is set.


``--``
  Pass remaining options to the native tool.

Run ``cmake --build`` with no options for quick help.

安装一个项目
=================

CMake提供了一个命令行签名来安装已经生成的项目二进制树：

.. code-block:: shell

  cmake --install <dir> [<options>]

这可以在构建项目后使用，以运行安装，而不使用生成的构建系统或本机构建工具。选项如下：

``--install <dir>``
  Project binary directory to install. This is required and must be first.

``--config <cfg>``
  For multi-configuration generators, choose configuration ``<cfg>``.

``--component <comp>``
  Component-based install. Only install component ``<comp>``.

``--default-directory-permissions <permissions>``
  Default directory install permissions. Permissions in format ``<u=rwx,g=rx,o=rx>``.

``--prefix <prefix>``
  Override the installation prefix, :variable:`CMAKE_INSTALL_PREFIX`.

``--strip``
  Strip before installing.

``-v, --verbose``
  Enable verbose output.

  This option can be omitted if :envvar:`VERBOSE` environment variable is set.

Run ``cmake --install`` with no options for quick help.

打开一个项目
==============

.. code-block:: shell

  cmake --open <dir>

在关联的应用程序中打开生成的项目。只支持部分生成器。


.. _`Script Processing Mode`:

运行脚本
============

.. code-block:: shell

  cmake [{-D <var>=<value>}...] -P <cmake-script-file> [-- <unparsed-options>...]

将给定的cmake文件作为CMake语言编写的脚本处理。没有执行配置或生成步骤，也没有修改缓存。如果使用 ``-D`` 定义变量，则必须在 ``-P`` 参数之前完成。

``--`` 后面的任何选项都不会被CMake解析，但它们仍然包含在 :variable:`CMAKE_ARGV<n> <CMAKE_ARGV0>` 传递给脚本的变量（包括 ``--`` 本身）。


.. _`Run a Command-Line Tool`:

运行命令行工具
=======================

CMake通过签名提供了内置的命令行工具

.. code-block:: shell

  cmake -E <command> [<options>]

执行 ``cmake -E`` 或 ``cmake -E help`` 获取命令摘要。可用的命令是：

``capabilities``
  .. versionadded:: 3.7

  Report cmake capabilities in JSON format. The output is a JSON object
  with the following keys:

  ``version``
    A JSON object with version information. Keys are:

    ``string``
      The full version string as displayed by cmake ``--version``.
    ``major``
      The major version number in integer form.
    ``minor``
      The minor version number in integer form.
    ``patch``
      The patch level in integer form.
    ``suffix``
      The cmake version suffix string.
    ``isDirty``
      A bool that is set if the cmake build is from a dirty tree.

  ``generators``
    A list available generators. Each generator is a JSON object with the
    following keys:

    ``name``
      A string containing the name of the generator.
    ``toolsetSupport``
      ``true`` if the generator supports toolsets and ``false`` otherwise.
    ``platformSupport``
      ``true`` if the generator supports platforms and ``false`` otherwise.
    ``supportedPlatforms``
      .. versionadded:: 3.21

      Optional member that may be present when the generator supports
      platform specification via :variable:`CMAKE_GENERATOR_PLATFORM`
      (``-A ...``).  The value is a list of platforms known to be supported.
    ``extraGenerators``
      A list of strings with all the extra generators compatible with
      the generator.

  ``fileApi``
    Optional member that is present when the :manual:`cmake-file-api(7)`
    is available.  The value is a JSON object with one member:

    ``requests``
      A JSON array containing zero or more supported file-api requests.
      Each request is a JSON object with members:

      ``kind``
        Specifies one of the supported :ref:`file-api object kinds`.

      ``version``
        A JSON array whose elements are each a JSON object containing
        ``major`` and ``minor`` members specifying non-negative integer
        version components.

  ``serverMode``
    ``true`` if cmake supports server-mode and ``false`` otherwise.
    Always false since CMake 3.20.

``cat [--] <files>...``
  .. versionadded:: 3.18

  Concatenate files and print on the standard output.

  .. versionadded:: 3.24
    Added support for the double dash argument ``--``. This basic implementation
    of ``cat`` does not support any options, so using a option starting with
    ``-`` will result in an error. Use ``--`` to indicate the end of options, in
    case a file starts with ``-``.

``chdir <dir> <cmd> [<arg>...]``
  Change the current working directory and run a command.

``compare_files [--ignore-eol] <file1> <file2>``
  Check if ``<file1>`` is same as ``<file2>``. If files are the same,
  then returns ``0``, if not it returns ``1``.  In case of invalid
  arguments, it returns 2.

  .. versionadded:: 3.14
    The ``--ignore-eol`` option implies line-wise comparison and ignores
    LF/CRLF differences.

``copy <file>... <destination>``
  Copy files to ``<destination>`` (either file or directory).
  If multiple files are specified, the ``<destination>`` must be
  directory and it must exist. Wildcards are not supported.
  ``copy`` does follow symlinks. That means it does not copy symlinks,
  but the files or directories it point to.

  .. versionadded:: 3.5
    Support for multiple input files.

``copy_directory <dir>... <destination>``
  Copy content of ``<dir>...`` directories to ``<destination>`` directory.
  If ``<destination>`` directory does not exist it will be created.
  ``copy_directory`` does follow symlinks.

  .. versionadded:: 3.5
    Support for multiple input directories.

  .. versionadded:: 3.15
    The command now fails when the source directory does not exist.
    Previously it succeeded by creating an empty destination directory.

``copy_if_different <file>... <destination>``
  Copy files to ``<destination>`` (either file or directory) if
  they have changed.
  If multiple files are specified, the ``<destination>`` must be
  directory and it must exist.
  ``copy_if_different`` does follow symlinks.

  .. versionadded:: 3.5
    Support for multiple input files.

``create_symlink <old> <new>``
  Create a symbolic link ``<new>`` naming ``<old>``.

  .. versionadded:: 3.13
    Support for creating symlinks on Windows.

  .. note::
    Path to where ``<new>`` symbolic link will be created has to exist beforehand.

``create_hardlink <old> <new>``
  .. versionadded:: 3.19

  Create a hard link ``<new>`` naming ``<old>``.

  .. note::
    Path to where ``<new>`` hard link will be created has to exist beforehand.
    ``<old>`` has to exist beforehand.

``echo [<string>...]``
  Displays arguments as text.

``echo_append [<string>...]``
  Displays arguments as text but no new line.

``env [--unset=NAME ...] [NAME=VALUE ...] [--] <command> [<arg>...]``
  .. versionadded:: 3.1

  Run command in a modified environment.

  .. versionadded:: 3.24
    Added support for the double dash argument ``--``. Use ``--`` to stop
    interpreting options/environment variables and treat the next argument as
    the command, even if it start with ``-`` or contains a ``=``.

``environment``
  Display the current environment variables.

``false``
  .. versionadded:: 3.16

  Do nothing, with an exit code of 1.

``make_directory <dir>...``
  Create ``<dir>`` directories.  If necessary, create parent
  directories too.  If a directory already exists it will be
  silently ignored.

  .. versionadded:: 3.5
    Support for multiple input directories.

``md5sum <file>...``
  Create MD5 checksum of files in ``md5sum`` compatible format::

     351abe79cd3800b38cdfb25d45015a15  file1.txt
     052f86c15bbde68af55c7f7b340ab639  file2.txt

``sha1sum <file>...``
  .. versionadded:: 3.10

  Create SHA1 checksum of files in ``sha1sum`` compatible format::

     4bb7932a29e6f73c97bb9272f2bdc393122f86e0  file1.txt
     1df4c8f318665f9a5f2ed38f55adadb7ef9f559c  file2.txt

``sha224sum <file>...``
  .. versionadded:: 3.10

  Create SHA224 checksum of files in ``sha224sum`` compatible format::

     b9b9346bc8437bbda630b0b7ddfc5ea9ca157546dbbf4c613192f930  file1.txt
     6dfbe55f4d2edc5fe5c9197bca51ceaaf824e48eba0cc453088aee24  file2.txt

``sha256sum <file>...``
  .. versionadded:: 3.10

  Create SHA256 checksum of files in ``sha256sum`` compatible format::

     76713b23615d31680afeb0e9efe94d47d3d4229191198bb46d7485f9cb191acc  file1.txt
     15b682ead6c12dedb1baf91231e1e89cfc7974b3787c1e2e01b986bffadae0ea  file2.txt

``sha384sum <file>...``
  .. versionadded:: 3.10

  Create SHA384 checksum of files in ``sha384sum`` compatible format::

     acc049fedc091a22f5f2ce39a43b9057fd93c910e9afd76a6411a28a8f2b8a12c73d7129e292f94fc0329c309df49434  file1.txt
     668ddeb108710d271ee21c0f3acbd6a7517e2b78f9181c6a2ff3b8943af92b0195dcb7cce48aa3e17893173c0a39e23d  file2.txt

``sha512sum <file>...``
  .. versionadded:: 3.10

  Create SHA512 checksum of files in ``sha512sum`` compatible format::

     2a78d7a6c5328cfb1467c63beac8ff21794213901eaadafd48e7800289afbc08e5fb3e86aa31116c945ee3d7bf2a6194489ec6101051083d1108defc8e1dba89  file1.txt
     7a0b54896fe5e70cca6dd643ad6f672614b189bf26f8153061c4d219474b05dad08c4e729af9f4b009f1a1a280cb625454bf587c690f4617c27e3aebdf3b7a2d  file2.txt

``remove [-f] <file>...``
  .. deprecated:: 3.17

  Remove the file(s). The planned behavior was that if any of the
  listed files already do not exist, the command returns a non-zero exit code,
  but no message is logged. The ``-f`` option changes the behavior to return a
  zero exit code (i.e. success) in such situations instead.
  ``remove`` does not follow symlinks. That means it remove only symlinks
  and not files it point to.

  The implementation was buggy and always returned 0. It cannot be fixed without
  breaking backwards compatibility. Use ``rm`` instead.

``remove_directory <dir>...``
  .. deprecated:: 3.17

  Remove ``<dir>`` directories and their contents. If a directory does
  not exist it will be silently ignored.
  Use ``rm`` instead.

  .. versionadded:: 3.15
    Support for multiple directories.

  .. versionadded:: 3.16
    If ``<dir>`` is a symlink to a directory, just the symlink will be removed.

``rename <oldname> <newname>``
  Rename a file or directory (on one volume). If file with the ``<newname>`` name
  already exists, then it will be silently replaced.

``rm [-rRf] [--] <file|dir>...``
  .. versionadded:: 3.17

  Remove the files ``<file>`` or directories ``<dir>``.
  Use ``-r`` or ``-R`` to remove directories and their contents recursively.
  If any of the listed files/directories do not exist, the command returns a
  non-zero exit code, but no message is logged. The ``-f`` option changes
  the behavior to return a zero exit code (i.e. success) in such
  situations instead. Use ``--`` to stop interpreting options and treat all
  remaining arguments as paths, even if they start with ``-``.

``server``
  Launch :manual:`cmake-server(7)` mode.

``sleep <number>...``
  .. versionadded:: 3.0

  Sleep for given number of seconds.

``tar [cxt][vf][zjJ] file.tar [<options>] [--] [<pathname>...]``
  Create or extract a tar or zip archive.  Options are:

  ``c``
    Create a new archive containing the specified files.
    If used, the ``<pathname>...`` argument is mandatory.

  ``x``
    Extract to disk from the archive.

    .. versionadded:: 3.15
      The ``<pathname>...`` argument could be used to extract only selected files
      or directories.
      When extracting selected files or directories, you must provide their exact
      names including the path, as printed by list (``-t``).

  ``t``
    List archive contents.

    .. versionadded:: 3.15
      The ``<pathname>...`` argument could be used to list only selected files
      or directories.

  ``v``
    Produce verbose output.

  ``z``
    Compress the resulting archive with gzip.

  ``j``
    Compress the resulting archive with bzip2.

  ``J``
    .. versionadded:: 3.1

    Compress the resulting archive with XZ.

  ``--zstd``
    .. versionadded:: 3.15

    Compress the resulting archive with Zstandard.

  ``--files-from=<file>``
    .. versionadded:: 3.1

    Read file names from the given file, one per line.
    Blank lines are ignored.  Lines may not start in ``-``
    except for ``--add-file=<name>`` to add files whose
    names start in ``-``.

  ``--format=<format>``
    .. versionadded:: 3.3

    Specify the format of the archive to be created.
    Supported formats are: ``7zip``, ``gnutar``, ``pax``,
    ``paxr`` (restricted pax, default), and ``zip``.

  ``--mtime=<date>``
    .. versionadded:: 3.1

    Specify modification time recorded in tarball entries.

  ``--touch``
    .. versionadded:: 3.24

    Use current local timestamp instead of extracting file timestamps
    from the archive.

  ``--``
    .. versionadded:: 3.1

    Stop interpreting options and treat all remaining arguments
    as file names, even if they start with ``-``.

  .. versionadded:: 3.1
    LZMA (7zip) support.

  .. versionadded:: 3.15
    The command now continues adding files to an archive even if some of the
    files are not readable.  This behavior is more consistent with the classic
    ``tar`` tool. The command now also parses all flags, and if an invalid flag
    was provided, a warning is issued.

``time <command> [<args>...]``
  Run command and display elapsed time.

  .. versionadded:: 3.5
    The command now properly passes arguments with spaces or special characters
    through to the child process. This may break scripts that worked around the
    bug with their own extra quoting or escaping.

``touch <file>...``
  Creates ``<file>`` if file do not exist.
  If ``<file>`` exists, it is changing ``<file>`` access and modification times.

``touch_nocreate <file>...``
  Touch a file if it exists but do not create it.  If a file does
  not exist it will be silently ignored.

``true``
  .. versionadded:: 3.16

  Do nothing, with an exit code of 0.

Windows特定命令行工程
-----------------------------------

以下 ``cmake -E`` 命令仅在Windows操作系统下可用：

``delete_regv <key>``
  Delete Windows registry value.

``env_vs8_wince <sdkname>``
  .. versionadded:: 3.2

  Displays a batch file which sets the environment for the provided
  Windows CE SDK installed in VS2005.

``env_vs9_wince <sdkname>``
  .. versionadded:: 3.2

  Displays a batch file which sets the environment for the provided
  Windows CE SDK installed in VS2008.

``write_regv <key> <value>``
  Write Windows registry value.


运行包查找工具
=========================

CMake为基于Makefile的项目提供了一个类似于pkg-config的助手：

.. code-block:: shell

  cmake --find-package [<options>]

它使用 :command:`find_package()` 搜索包，并将结果标记打印到stdout。这可以代替pkg-config在普通的基于Makefile的项目或基于autoconf的项目中找到已安装的库（通过 ``share/aclocal/cmake.m4``）。

.. note::
  由于一些技术限制，这种模式没有得到很好的支持。保留它是为了兼容，但不应该在新项目中使用。


查看帮助
=========

要从CMake文档中打印选定的页面，请使用

.. code-block:: shell

  cmake --help[-<topic>]

有下列其中一种选择：

.. include:: OPTIONS_HELP.txt

To view the presets available for a project, use

.. code-block:: shell

  cmake <source-dir> --list-presets


.. _`CMake Exit Code`:

Return Value (Exit Code)
========================

Upon regular termination, the ``cmake`` executable returns the exit code ``0``.

If termination is caused by the command :command:`message(FATAL_ERROR)`,
or another error condition, then a non-zero exit code is returned.


另行参阅
========

.. include:: LINKS.txt
