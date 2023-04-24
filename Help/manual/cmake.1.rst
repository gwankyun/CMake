.. cmake-manual-description: CMake Command-Line Reference

cmake(1)
********

概要
========

.. parsed-literal::

 `Generate a Project Buildsystem`_
  cmake [<options>] <path-to-source | path-to-existing-build>
  cmake [<options>] -S <path-to-source> -B <path-to-build>

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

 `Run a Workflow Preset`_
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
境（IDE）的项目文件。为了避免维护多个这样的构建系统，项目可以使用\ :manual:`CMake语言 <cmake-language(7)>`\
编写的文件抽象地指定它的构建系统。从这些文件中，CMake通过一个称为\ *生成器*\ 的后端为每个用\
户在本地生成一个首选的构建系统。

要用CMake生成一个构建系统，必须设置以下选项：

源代码树
  包含由项目提供的源文件的顶层目录。该项目使用\ :manual:`cmake-language(7)`\ 手册中描述\
  的文件指定其构建系统，从顶层文件\ ``CMakeLists.txt``\ 开始。这些文件指定了\ :manual:`cmake-buildsystem(7)`\
  手册中描述的构建目标及其依赖关系。

构建树
  用于存储构建系统文件和构建输出工件（例如可执行文件和库）的顶层目录。CMake将编写一个\
  ``CMakeCache.txt``\ 文件，将该目录标识为构建树，并存储持久信息，如构建系统配置选项。

  要维护原始的源代码树，请使用单独的专用构建树执行\ *源代码外*\ 构建。也支持将构建树放置在与\
  源代码树相同的目录中的\ *源代码内*\ 构建，但不鼓励这样做。

Generator
  This chooses the kind of buildsystem to generate.  See the
  :manual:`cmake-generators(7)` manual for documentation of all generators.
  Run :option:`cmake --help` to see a list of generators available locally.
  Optionally use the :option:`-G <cmake -G>` option below to specify a
  generator, or simply accept the default CMake chooses for the current
  platform.

  当使用\ :ref:`Command-Line Build Tool Generators`\ 时，CMake期望编译器工具链所需要\
  的环境已经在shell中配置好了。当使用\ :ref:`IDE Build Tool Generators`\ 时，不需要特\
  定的环境。

.. _`Generate a Project Buildsystem`:

生成一个项目构建系统
==============================

使用以下命令签名之一运行CMake，指定源和构建树，并生成一个构建系统：

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

``cmake [<options>] -S <path-to-source> -B <path-to-build>``

  .. versionadded:: 3.13

  使用\ ``<path-to-build>``\ 作为构建树，使用\ ``<path-to-source>``\ 作为源树。指定的\
  路径可以是绝对路径或相对于当前工作目录的路径。源树必须包含一个\ ``CMakeLists.txt``\ 文件。\
  如果构建树不存在，将自动创建它。例如：

  .. code-block:: console

    $ cmake -S src -B build

在所有情况下，``<options>``\ 可能是下面\ `选项`_\ 的零或多个。

The above styles for specifying the source and build trees may be mixed.
Paths specified with :option:`-S <cmake -S>` or :option:`-B <cmake -B>`
are always classified as source or build trees, respectively.  Paths
specified with plain arguments are classified based on their content
and the types of paths given earlier.  If only one type of path is given,
the current working directory (cwd) is used for the other.  For example:

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

  CMake在指定多个源路径时发出警告。这从来没有正式的文档或支持，但较旧的版本会意外地接受多个\
  源路径，并使用最后指定的路径。避免传递多个源路径参数。

在生成构建系统之后，可以使用相应的本地构建工具来构建项目。例如，在使用\ :generator:`Unix Makefiles`\
生成器后，可以直接运行\ ``make``：

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

 List non-advanced cached variables.

 List ``CACHE`` variables will run CMake and list all the variables from
 the CMake ``CACHE`` that are not marked as ``INTERNAL`` or :prop_cache:`ADVANCED`.
 This will effectively display current CMake settings, which can then be
 changed with :option:`-D <cmake -D>` option.  Changing some of the variables
 may result in more variables being created.  If ``A`` is specified, then it
 will display also advanced variables.  If ``H`` is specified, it will also
 display help for each variable.

.. option:: -N

 View mode only.

 只加载缓存。不实际运行配置和生成步骤。

.. option:: --graphviz=<file>

 Generate graphviz of dependencies, see :module:`CMakeGraphVizOptions` for more.

 生成一个graphviz输入文件，该文件将包含项目中的所有库和可执行依赖项。更多细节请参阅\
 :module:`CMakeGraphVizOptions`\ 文档。

.. option:: --system-information [file]

 Dump information about this system.

 转储关于当前系统的各种信息。如果从一个CMake项目的二进制目录顶层运行，它将转储额外的信息，\
 如缓存、日志文件等。

.. option:: --log-level=<level>

 Set the log ``<level>``.

 The :command:`message` command will only output messages of the specified
 log level or higher.  The valid log levels are ``ERROR``, ``WARNING``,
 ``NOTICE``, ``STATUS`` (default), ``VERBOSE``, ``DEBUG``, or ``TRACE``.

 要在CMake运行之间保持日志级别，可以将\ :variable:`CMAKE_MESSAGE_LOG_LEVEL`\ 设置为缓\
 存变量。如果同时给出了命令行选项和变量，则命令行选项优先。

 出于向后兼容的原因，``--loglevel``\ 也被接受为该选项的同义词。

 .. versionadded:: 3.25
   See the :command:`cmake_language` command for a way to
   :ref:`query the current message logging level <query_message_log_level>`.

.. option:: --log-context

 Enable the :command:`message` command outputting context attached to each
 message.

 这个选项打开仅显示当前CMake运行的上下文。为了让所有后续的CMake运行都持续显示上下文，可以将\
 :variable:`CMAKE_MESSAGE_CONTEXT_SHOW`\ 设置为缓存变量。当给出这个命令行选项时，\
 :variable:`CMAKE_MESSAGE_CONTEXT_SHOW`\ 将被忽略。

.. option:: --debug-trycompile

 Do not delete the files and directories created for
 :command:`try_compile` / :command:`try_run` calls.
 This is useful in debugging failed checks.

 Note that some uses of :command:`try_compile` may use the same build tree,
 which will limit the usefulness of this option if a project executes more
 than one :command:`try_compile`.  For example, such uses may change results
 as artifacts from a previous try-compile may cause a different test to either
 pass or fail incorrectly.  This option is best used only when debugging.

 (With respect to the preceding, the :command:`try_run` command
 is effectively a :command:`try_compile`.  Any combination of the two
 is subject to the potential issues described.)

 .. versionadded:: 3.25

   When this option is enabled, every try-compile check prints a log
   message reporting the directory in which the check is performed.

.. option:: --debug-output

 Put cmake in a debug mode.

 在cmake运行期间打印额外的信息，就像使用\ :command:`message(SEND_ERROR)`\ 调用进行堆栈跟踪一样。

.. option:: --debug-find

 Put cmake find commands in a debug mode.

 在cmake运行到标准错误时打印额外的find调用信息。输出是为人们使用而设计的，而不是为解析设计的。\
 请参阅\ :variable:`CMAKE_FIND_DEBUG_MODE`\ 变量来调试项目中更局部的部分。

.. option:: --debug-find-pkg=<pkg>[,...]

 Put cmake find commands in a debug mode when running under calls
 to :command:`find_package(\<pkg\>) <find_package>`, where ``<pkg>``
 is an entry in the given comma-separated list of case-sensitive package
 names.

 Like :option:`--debug-find <cmake --debug-find>`, but limiting scope
 to the specified packages.

.. option:: --debug-find-var=<var>[,...]

 Put cmake find commands in a debug mode when called with ``<var>``
 as the result variable, where ``<var>`` is an entry in the given
 comma-separated list.

 Like :option:`--debug-find <cmake --debug-find>`, but limiting scope
 to the specified variable names.

.. option:: --trace

 Put cmake in trace mode.

 打印所有呼叫的轨迹和调用的来源。

.. option:: --trace-expand

 Put cmake in trace mode.

 Like :option:`--trace <cmake --trace>`, but with variables expanded.

.. option:: --trace-format=<format>

 Put cmake in trace mode and sets the trace output format.

 ``<format>``\ 可以是下列值之一。

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
       如果函数调用跨越多行，则该字段将设置为函数调用结束的行。如果函数调用跨越单行，这个字段将被取消设置。该字段是在\ ``json-v1``\ 格式的次要版本2中添加的。

     ``defer``
       当函数调用被\ :command:`cmake_language(DEFER)`\ 延迟时出现的可选成员。如果存在，它的值是一个包含延迟调用\ ``<id>``\ 的字符串。

     ``cmd``
       被调用的函数的名称。

     ``args``
       包含所有函数参数的字符串列表。

     ``time``
       函数调用的时间戳（自epoch以来的秒数）。

     ``frame``
       在当前正在处理的\ ``CMakeLists.txt``\ 的上下文中，被调用函数的堆栈帧深度。

     ``global_frame``
       被调用函数的堆栈帧深度，在跟踪涉及的所有\ ``CMakeLists.txt``\ 文件中全局跟踪。该字段是在\ ``json-v1``\ 格式的次要版本2中添加的。

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

 Put cmake in trace mode, but output only lines of a specified file.

 Multiple options are allowed.

.. option:: --trace-redirect=<file>

 Put cmake in trace mode and redirect trace output to a file instead of stderr.

.. option:: --warn-uninitialized

 Warn about uninitialized values.

 Print a warning when an uninitialized variable is used.

.. option:: --warn-unused-vars

 Does nothing.  In CMake versions 3.2 and below this enabled warnings about
 unused variables.  In CMake versions 3.3 through 3.18 the option was broken.
 In CMake 3.19 and above the option has been removed.

.. option:: --no-warn-unused-cli

 Don't warn about command line options.

 Don't find variables that are declared on the command line, but not
 used.

.. option:: --check-system-vars

 Find problems with variable usage in system files.

 Normally, unused and uninitialized variables are searched for only
 in :variable:`CMAKE_SOURCE_DIR` and :variable:`CMAKE_BINARY_DIR`.
 This flag tells CMake to warn about other files as well.

.. option:: --compile-no-warning-as-error

 Ignore target property :prop_tgt:`COMPILE_WARNING_AS_ERROR` and variable
 :variable:`CMAKE_COMPILE_WARNING_AS_ERROR`, preventing warnings from being
 treated as errors on compile.

.. option:: --profiling-output=<path>

 Used in conjunction with
 :option:`--profiling-format <cmake --profiling-format>` to output to a
 given path.

.. option:: --profiling-format=<file>

 Enable the output of profiling data of CMake script in the given format.

 This can aid performance analysis of CMake scripts executed. Third party
 applications should be used to process the output into human readable format.

 Currently supported values are:
 ``google-trace`` Outputs in Google Trace Format, which can be parsed by the
 about:tracing tab of Google Chrome or using a plugin for a tool like Trace
 Compass.

.. option:: --preset <preset>, --preset=<preset>

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

.. option:: --list-presets[=<type>]

 Lists the available presets of the specified ``<type>``.  Valid values for
 ``<type>`` are ``configure``, ``build``, ``test``, ``package``, or ``all``.
 If ``<type>`` is omitted, ``configure`` is assumed.  The current working
 directory must contain CMake preset files.

.. _`Build Tool Mode`:

构建一个项目
===============

.. program:: cmake

CMake provides a command-line signature to build an already-generated
project binary tree:

.. code-block:: shell

  cmake --build <dir>             [<options>] [-- <build-tool-options>]
  cmake --build --preset <preset> [<options>] [-- <build-tool-options>]

这将使用以下选项抽象出一个本机构建工具的命令行界面：

.. option:: --build <dir>

  Project binary directory to be built.  This is required (unless a preset
  is specified) and must be first.

.. program:: cmake--build

.. option:: --preset <preset>, --preset=<preset>

  Use a build preset to specify build options. The project binary directory
  is inferred from the ``configurePreset`` key. The current working directory
  must contain CMake preset files.
  See :manual:`preset <cmake-presets(7)>` for more details.

.. option:: --list-presets

  Lists the available build presets. The current working directory must
  contain CMake preset files.

.. option:: -j [<jobs>], --parallel [<jobs>]

  .. versionadded:: 3.12

  The maximum number of concurrent processes to use when building.
  If ``<jobs>`` is omitted the native build tool's default number is used.

  The :envvar:`CMAKE_BUILD_PARALLEL_LEVEL` environment variable, if set,
  specifies a default parallel level when this option is not given.

  Some native build tools always build in parallel.  The use of ``<jobs>``
  value of ``1`` can be used to limit to a single job.

.. option:: -t <tgt>..., --target <tgt>...

  Build ``<tgt>`` instead of the default target.  Multiple targets may be
  given, separated by spaces.

.. option:: --config <cfg>

  For multi-configuration tools, choose configuration ``<cfg>``.

.. option:: --clean-first

  Build target ``clean`` first, then build.
  (To clean only, use :option:`--target clean <cmake--build --target>`.)

.. option:: --resolve-package-references=<value>

  .. versionadded:: 3.23

  Resolve remote package references from external package managers (e.g. NuGet)
  before build. When ``<value>`` is set to ``on`` (default), packages will be
  restored before building a target.  When ``<value>`` is set to ``only``, the
  packages will be restored, but no build will be performed.  When
  ``<value>`` is set to ``off``, no packages will be restored.

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

.. option:: --use-stderr

  Ignored.  Behavior is default in CMake >= 3.0.

.. option:: -v, --verbose

  Enable verbose output - if supported - including the build commands to be
  executed.

  This option can be omitted if :envvar:`VERBOSE` environment variable or
  :variable:`CMAKE_VERBOSE_MAKEFILE` cached variable is set.


.. option:: --

  Pass remaining options to the native tool.

Run :option:`cmake --build` with no options for quick help.

安装一个项目
=================

.. program:: cmake

CMake provides a command-line signature to install an already-generated
project binary tree:

.. code-block:: shell

  cmake --install <dir> [<options>]

这可以在构建项目后使用，以运行安装，而不使用生成的构建系统或本机构建工具。选项如下：

.. option:: --install <dir>

  Project binary directory to install. This is required and must be first.

.. program:: cmake--install

.. option:: --config <cfg>

  For multi-configuration generators, choose configuration ``<cfg>``.

.. option:: --component <comp>

  Component-based install. Only install component ``<comp>``.

.. option:: --default-directory-permissions <permissions>

  Default directory install permissions. Permissions in format ``<u=rwx,g=rx,o=rx>``.

.. option:: --prefix <prefix>

  Override the installation prefix, :variable:`CMAKE_INSTALL_PREFIX`.

.. option:: --strip

  Strip before installing.

.. option:: -v, --verbose

  Enable verbose output.

  This option can be omitted if :envvar:`VERBOSE` environment variable is set.

Run :option:`cmake --install` with no options for quick help.

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

 Define a variable for script mode.

.. program:: cmake

.. option:: -P <cmake-script-file>

 Process the given cmake file as a script written in the CMake
 language.  No configure or generate step is performed and the cache
 is not modified.  If variables are defined using ``-D``, this must be
 done before the ``-P`` argument.

``--`` 后面的任何选项都不会被CMake解析，但它们仍然包含在 :variable:`CMAKE_ARGV<n> <CMAKE_ARGV0>` 传递给脚本的变量（包括 ``--`` 本身）。


.. _`Run a Command-Line Tool`:

运行命令行工具
=======================

.. program:: cmake

CMake provides builtin command-line tools through the signature

.. code-block:: shell

  cmake -E <command> [<options>]

.. option:: -E [help]

  Run ``cmake -E`` or ``cmake -E help`` for a summary of commands.

.. program:: cmake-E

Available commands are:

.. option:: capabilities

  .. versionadded:: 3.7

  Report cmake capabilities in JSON format. The output is a JSON object
  with the following keys:

  ``version``
    A JSON object with version information. Keys are:

    ``string``
      The full version string as displayed by cmake :option:`--version <cmake --version>`.
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
      (:option:`-A ... <cmake -A>`).  The value is a list of platforms known to
      be supported.
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

  ``tls``
    .. versionadded:: 3.25

    ``true`` if TLS support is enabled and ``false`` otherwise.

.. option:: cat [--] <files>...

  .. versionadded:: 3.18

  Concatenate files and print on the standard output.

  .. program:: cmake-E_cat

  .. option:: --

    .. versionadded:: 3.24

    Added support for the double dash argument ``--``. This basic implementation
    of ``cat`` does not support any options, so using a option starting with
    ``-`` will result in an error. Use ``--`` to indicate the end of options, in
    case a file starts with ``-``.

.. program:: cmake-E

.. option:: chdir <dir> <cmd> [<arg>...]

  Change the current working directory and run a command.

.. option:: compare_files [--ignore-eol] <file1> <file2>

  Check if ``<file1>`` is same as ``<file2>``. If files are the same,
  then returns ``0``, if not it returns ``1``.  In case of invalid
  arguments, it returns 2.

  .. program:: cmake-E_compare_files

  .. option:: --ignore-eol

    .. versionadded:: 3.14

    The option implies line-wise comparison and ignores LF/CRLF differences.

.. program:: cmake-E

.. option:: copy <file>... <destination>, copy -t <destination> <file>...

  Copy files to ``<destination>`` (either file or directory).
  If multiple files are specified, or if ``-t`` is specified, the
  ``<destination>`` must be directory and it must exist. If ``-t`` is not
  specified, the last argument is assumed to be the ``<destination>``.
  Wildcards are not supported. ``copy`` does follow symlinks. That means it
  does not copy symlinks, but the files or directories it point to.

  .. versionadded:: 3.5
    Support for multiple input files.

  .. versionadded:: 3.26
    Support for ``-t`` argument.

.. option:: copy_directory <dir>... <destination>

  Copy content of ``<dir>...`` directories to ``<destination>`` directory.
  If ``<destination>`` directory does not exist it will be created.
  ``copy_directory`` does follow symlinks.

  .. versionadded:: 3.5
    Support for multiple input directories.

  .. versionadded:: 3.15
    The command now fails when the source directory does not exist.
    Previously it succeeded by creating an empty destination directory.

.. option:: copy_directory_if_different <dir>... <destination>

  .. versionadded:: 3.26

  Copy changed content of ``<dir>...`` directories to ``<destination>`` directory.
  If ``<destination>`` directory does not exist it will be created.

  ``copy_directory_if_different`` does follow symlinks.
  The command fails when the source directory does not exist.

.. option:: copy_if_different <file>... <destination>

  Copy files to ``<destination>`` (either file or directory) if
  they have changed.
  If multiple files are specified, the ``<destination>`` must be
  directory and it must exist.
  ``copy_if_different`` does follow symlinks.

  .. versionadded:: 3.5
    Support for multiple input files.

.. option:: create_symlink <old> <new>

  Create a symbolic link ``<new>`` naming ``<old>``.

  .. versionadded:: 3.13
    Support for creating symlinks on Windows.

  .. note::
    Path to where ``<new>`` symbolic link will be created has to exist beforehand.

.. option:: create_hardlink <old> <new>

  .. versionadded:: 3.19

  Create a hard link ``<new>`` naming ``<old>``.

  .. note::
    Path to where ``<new>`` hard link will be created has to exist beforehand.
    ``<old>`` has to exist beforehand.

.. option:: echo [<string>...]

  Displays arguments as text.

.. option:: echo_append [<string>...]

  Displays arguments as text but no new line.

.. option:: env [<options>] [--] <command> [<arg>...]

  .. versionadded:: 3.1

  Run command in a modified environment. Options are:

  .. program:: cmake-E_env

  .. option:: NAME=VALUE

    Replaces the current value of ``NAME`` with ``VALUE``.

  .. option:: --unset=NAME

    Unsets the current value of ``NAME``.

  .. option:: --modify ENVIRONMENT_MODIFICATION

    .. versionadded:: 3.25

    Apply a single :prop_test:`ENVIRONMENT_MODIFICATION` operation to the
    modified environment.

    The ``NAME=VALUE`` and ``--unset=NAME`` options are equivalent to
    ``--modify NAME=set:VALUE`` and ``--modify NAME=unset:``, respectively.
    Note that ``--modify NAME=reset:`` resets ``NAME`` to the value it had
    when :program:`cmake` launched (or unsets it), not to the most recent
    ``NAME=VALUE`` option.

  .. option:: --

    .. versionadded:: 3.24

    Added support for the double dash argument ``--``. Use ``--`` to stop
    interpreting options/environment variables and treat the next argument as
    the command, even if it start with ``-`` or contains a ``=``.

.. program:: cmake-E

.. option:: environment

  Display the current environment variables.

.. option:: false

  .. versionadded:: 3.16

  Do nothing, with an exit code of 1.

.. option:: make_directory <dir>...

  Create ``<dir>`` directories.  If necessary, create parent
  directories too.  If a directory already exists it will be
  silently ignored.

  .. versionadded:: 3.5
    Support for multiple input directories.

.. option:: md5sum <file>...

  Create MD5 checksum of files in ``md5sum`` compatible format::

     351abe79cd3800b38cdfb25d45015a15  file1.txt
     052f86c15bbde68af55c7f7b340ab639  file2.txt

.. option:: sha1sum <file>...

  .. versionadded:: 3.10

  Create SHA1 checksum of files in ``sha1sum`` compatible format::

     4bb7932a29e6f73c97bb9272f2bdc393122f86e0  file1.txt
     1df4c8f318665f9a5f2ed38f55adadb7ef9f559c  file2.txt

.. option:: sha224sum <file>...

  .. versionadded:: 3.10

  Create SHA224 checksum of files in ``sha224sum`` compatible format::

     b9b9346bc8437bbda630b0b7ddfc5ea9ca157546dbbf4c613192f930  file1.txt
     6dfbe55f4d2edc5fe5c9197bca51ceaaf824e48eba0cc453088aee24  file2.txt

.. option:: sha256sum <file>...

  .. versionadded:: 3.10

  Create SHA256 checksum of files in ``sha256sum`` compatible format::

     76713b23615d31680afeb0e9efe94d47d3d4229191198bb46d7485f9cb191acc  file1.txt
     15b682ead6c12dedb1baf91231e1e89cfc7974b3787c1e2e01b986bffadae0ea  file2.txt

.. option:: sha384sum <file>...

  .. versionadded:: 3.10

  Create SHA384 checksum of files in ``sha384sum`` compatible format::

     acc049fedc091a22f5f2ce39a43b9057fd93c910e9afd76a6411a28a8f2b8a12c73d7129e292f94fc0329c309df49434  file1.txt
     668ddeb108710d271ee21c0f3acbd6a7517e2b78f9181c6a2ff3b8943af92b0195dcb7cce48aa3e17893173c0a39e23d  file2.txt

.. option:: sha512sum <file>...

  .. versionadded:: 3.10

  Create SHA512 checksum of files in ``sha512sum`` compatible format::

     2a78d7a6c5328cfb1467c63beac8ff21794213901eaadafd48e7800289afbc08e5fb3e86aa31116c945ee3d7bf2a6194489ec6101051083d1108defc8e1dba89  file1.txt
     7a0b54896fe5e70cca6dd643ad6f672614b189bf26f8153061c4d219474b05dad08c4e729af9f4b009f1a1a280cb625454bf587c690f4617c27e3aebdf3b7a2d  file2.txt

.. option:: remove [-f] <file>...

  .. deprecated:: 3.17

  Remove the file(s). The planned behavior was that if any of the
  listed files already do not exist, the command returns a non-zero exit code,
  but no message is logged. The ``-f`` option changes the behavior to return a
  zero exit code (i.e. success) in such situations instead.
  ``remove`` does not follow symlinks. That means it remove only symlinks
  and not files it point to.

  The implementation was buggy and always returned 0. It cannot be fixed without
  breaking backwards compatibility. Use ``rm`` instead.

.. option:: remove_directory <dir>...

  .. deprecated:: 3.17

  Remove ``<dir>`` directories and their contents. If a directory does
  not exist it will be silently ignored.
  Use ``rm`` instead.

  .. versionadded:: 3.15
    Support for multiple directories.

  .. versionadded:: 3.16
    If ``<dir>`` is a symlink to a directory, just the symlink will be removed.

.. option:: rename <oldname> <newname>

  Rename a file or directory (on one volume). If file with the ``<newname>`` name
  already exists, then it will be silently replaced.

.. option:: rm [-rRf] [--] <file|dir>...

  .. versionadded:: 3.17

  Remove the files ``<file>`` or directories ``<dir>``.
  Use ``-r`` or ``-R`` to remove directories and their contents recursively.
  If any of the listed files/directories do not exist, the command returns a
  non-zero exit code, but no message is logged. The ``-f`` option changes
  the behavior to return a zero exit code (i.e. success) in such
  situations instead. Use ``--`` to stop interpreting options and treat all
  remaining arguments as paths, even if they start with ``-``.

.. option:: sleep <number>...

  .. versionadded:: 3.0

  Sleep for given number of seconds.

.. option:: tar [cxt][vf][zjJ] file.tar [<options>] [--] [<pathname>...]

  Create or extract a tar or zip archive.  Options are:

  .. program:: cmake-E_tar

  .. option:: c

    Create a new archive containing the specified files.
    If used, the ``<pathname>...`` argument is mandatory.

  .. option:: x

    Extract to disk from the archive.

    .. versionadded:: 3.15
      The ``<pathname>...`` argument could be used to extract only selected files
      or directories.
      When extracting selected files or directories, you must provide their exact
      names including the path, as printed by list (``-t``).

  .. option:: t

    List archive contents.

    .. versionadded:: 3.15
      The ``<pathname>...`` argument could be used to list only selected files
      or directories.

  .. option:: v

    Produce verbose output.

  .. option:: z

    Compress the resulting archive with gzip.

  .. option:: j

    Compress the resulting archive with bzip2.

  .. option:: J

    .. versionadded:: 3.1

    Compress the resulting archive with XZ.

  .. option:: --zstd

    .. versionadded:: 3.15

    Compress the resulting archive with Zstandard.

  .. option:: --files-from=<file>

    .. versionadded:: 3.1

    Read file names from the given file, one per line.
    Blank lines are ignored.  Lines may not start in ``-``
    except for ``--add-file=<name>`` to add files whose
    names start in ``-``.

  .. option:: --format=<format>

    .. versionadded:: 3.3

    Specify the format of the archive to be created.
    Supported formats are: ``7zip``, ``gnutar``, ``pax``,
    ``paxr`` (restricted pax, default), and ``zip``.

  .. option:: --mtime=<date>

    .. versionadded:: 3.1

    Specify modification time recorded in tarball entries.

  .. option:: --touch

    .. versionadded:: 3.24

    Use current local timestamp instead of extracting file timestamps
    from the archive.

  .. option:: --

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

.. program:: cmake-E

.. option:: time <command> [<args>...]

  Run command and display elapsed time.

  .. versionadded:: 3.5
    The command now properly passes arguments with spaces or special characters
    through to the child process. This may break scripts that worked around the
    bug with their own extra quoting or escaping.

.. option:: touch <file>...

  Creates ``<file>`` if file do not exist.
  If ``<file>`` exists, it is changing ``<file>`` access and modification times.

.. option:: touch_nocreate <file>...

  Touch a file if it exists but do not create it.  If a file does
  not exist it will be silently ignored.

.. option:: true

  .. versionadded:: 3.16

  Do nothing, with an exit code of 0.

Windows特定命令行工程
-----------------------------------

以下 ``cmake -E`` 命令仅在Windows操作系统下可用：

.. option:: delete_regv <key>

  Delete Windows registry value.

.. option:: env_vs8_wince <sdkname>

  .. versionadded:: 3.2

  Displays a batch file which sets the environment for the provided
  Windows CE SDK installed in VS2005.

.. option:: env_vs9_wince <sdkname>

  .. versionadded:: 3.2

  Displays a batch file which sets the environment for the provided
  Windows CE SDK installed in VS2008.

.. option:: write_regv <key> <value>

  Write Windows registry value.


运行包查找工具
=========================

.. program:: cmake--find-package

CMake provides a pkg-config like helper for Makefile-based projects:

.. code-block:: shell

  cmake --find-package [<options>]

它使用 :command:`find_package()` 搜索包，并将结果标记打印到stdout。这可以代替pkg-config在普通的基于Makefile的项目或基于autoconf的项目中找到已安装的库（通过 ``share/aclocal/cmake.m4``）。

.. note::
  由于一些技术限制，这种模式没有得到很好的支持。保留它是为了兼容，但不应该在新项目中使用。

.. _`Workflow Mode`:

Run a Workflow Preset
=====================

.. program:: cmake

:manual:`CMake Presets <cmake-presets(7)>` provides a way to execute multiple
build steps in order:

.. code-block:: shell

  cmake --workflow [<options>]

The options are:

.. option:: --workflow

  Select a :ref:`Workflow Preset` using one of the following options.

.. program:: cmake--workflow

.. option:: --preset <preset>, --preset=<preset>

  Use a workflow preset to specify a workflow. The project binary directory
  is inferred from the initial configure preset. The current working directory
  must contain CMake preset files.
  See :manual:`preset <cmake-presets(7)>` for more details.

.. option:: --list-presets

  Lists the available workflow presets. The current working directory must
  contain CMake preset files.

.. option:: --fresh

  Perform a fresh configuration of the build tree.
  This removes any existing ``CMakeCache.txt`` file and associated
  ``CMakeFiles/`` directory, and recreates them from scratch.

查看帮助
=========

.. program:: cmake

To print selected pages from the CMake documentation, use

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

Upon regular termination, the :program:`cmake` executable returns the exit code ``0``.

If termination is caused by the command :command:`message(FATAL_ERROR)`,
or another error condition, then a non-zero exit code is returned.


另行参阅
========

.. include:: LINKS.txt
