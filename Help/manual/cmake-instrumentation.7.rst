.. cmake-manual-description: CMake Instrumentation

cmake-instrumentation(7)
************************

.. versionadded:: 4.0

.. only:: html

  .. contents::

引言
============

.. note::

   只有当通过\ ``CMAKE_EXPERIMENTAL_INSTRUMENTATION``\ 开关启用了对插桩的实验性支持时，\
   此功能才可用。

CMake插桩API允许在CMake项目的配置、生成、构建、测试和安装步骤期间收集计时数据、目标信息以及\
系统诊断信息。

此功能仅适用于使用\ :ref:`Makefile Generators`\ 或\ :ref:`Ninja Generators`\ 的项目。

与CMake插桩API进行的所有交互都必须同时指定API版本和数据版本。目前，这两者都只有一个版本：\
`API v1`_\ 和\ `Data v1`_。

数据收集
---------------

每当在启用插桩的情况下执行命令时，会在项目构建树中创建一个\ `v1 Snippet File`_ ，其中包含\
该命令的特定数据。这些文件会一直保留到\ `索引`_\ 操作完成之后。

CMake会设置全局属性\ :prop_gbl:`RULE_LAUNCH_COMPILE`、\ :prop_gbl:`RULE_LAUNCH_LINK`\
和\ :prop_gbl:`RULE_LAUNCH_CUSTOM`，以使用\ ``ctest --instrument``\ 启动器，从而分别\
捕获每个编译、链接和自定义命令的详细信息。如果项目使用了\ :module:`CTestUseLaunchers`\
进行配置，\ ``ctest --instrument``\ 还将包含\ ``ctest --launch``\ 通常执行的行为。

索引
--------

索引是整理生成的插桩数据的过程。索引会在称为钩子的特定时间间隔进行，例如每次构建之后。这些钩子\
是作为\ `v1 Query Files`_\ 的一部分进行配置的。每当钩子被触发时，就会生成一个索引文件，\
其中包含自上次索引以来更新的片段文件列表。

也可以通过手动调用\ ``ctest --collect-instrumentation <build>``\ 来生成索引。

Callbacks
---------

As part of the `v1 Query Files`_, users can provide a list of callbacks
intended to handle data collected by this feature.

Whenever `索引`_ occurs, each provided callback is executed, passing the
path to the generated index file as an argument.

These callbacks, defined either at the user-level or project-level should read
the instrumentation data and perform any desired handling of it. The index file
and its listed snippets are automatically deleted by CMake once all callbacks
have completed. Note that a callback should never move or delete these data
files manually as they may be needed by other callbacks.

Enabling Instrumentation
========================

Instrumentation can be enabled either for an individual CMake project, or
for all CMake projects configured and built by a user. For both cases,
see the `v1 Query Files`_ for details on configuring this feature.

Enabling Instrumentation at the Project-Level
---------------------------------------------

Project code can contain instrumentation queries with the
:command:`cmake_instrumentation` command.

In addition, query files can be placed manually under
``<build>/.cmake/instrumentation/<version>/query/`` at the top of a build tree.
This version of CMake supports only one version schema, `API v1`_.

Enabling Instrumentation at the User-Level
------------------------------------------

Instrumentation can be configured at the user-level by placing query files in
the :envvar:`CMAKE_CONFIG_DIR` under
``<config_dir>/instrumentation/<version>/query/``.

Enabling Instrumentation for CDash Submissions
----------------------------------------------

You can enable instrumentation when using CTest in :ref:`Dashboard Client`
mode by setting the :envvar:`CTEST_USE_INSTRUMENTATION` environment variable
to the current UUID for the ``CMAKE_EXPERIMENTAL_INSTRUMENTATION`` feature.
Doing so automatically enables the ``dynamicSystemInformation`` query.

The following table shows how each type of instrumented command gets mapped
to a corresponding type of CTest XML file.

=================================================== ==================
:ref:`Snippet Role <cmake-instrumentation Data v1>` CTest XML File
=================================================== ==================
``configure``                                       ``Configure.xml``
``generate``                                        ``Configure.xml``
``compile``                                         ``Build.xml``
``link``                                            ``Build.xml``
``custom``                                          ``Build.xml``
``build``                                           unused!
``cmakeBuild``                                      ``Build.xml``
``cmakeInstall``                                    ``Build.xml``
``install``                                         ``Build.xml``
``ctest``                                           ``Build.xml``
``test``                                            ``Test.xml``
=================================================== ==================

By default the command line reported to CDash is truncated at the first space.
You can instead choose to report the full command line (including arguments)
by setting :envvar:`CTEST_USE_VERBOSE_INSTRUMENTATION` to 1.

.. _`cmake-instrumentation API v1`:

API v1
======

The API version specifies both the subdirectory layout of the instrumentation data,
and the format of the query files.

The Instrumentation API v1 is housed  in the ``instrumentation/v1/`` directory
under either ``<build>/.cmake/`` for output data and project-level queries, or
``<config_dir>/`` for user-level queries. The ``v1`` component of this
directory is what signifies the API version. It has the following
subdirectories:

``query/``
  Holds query files written by users or clients. Any file with the ``.json``
  file extension will be recognized as a query file. These files are owned by
  whichever client or user creates them.

``query/generated/``
  Holds query files generated by a CMake project with the
  :command:`cmake_instrumentation` command. These files are owned by CMake and
  are deleted and regenerated automatically during the CMake configure step.

``data/``
  Holds instrumentation data collected on the project. CMake owns all data
  files, they should never be removed by other processes. Data collected here
  remains until after `索引`_ occurs and all `Callbacks`_ are executed.

``cdash/``
  Holds temporary files used internally to generate XML content to be submitted
  to CDash.

.. _`cmake-instrumentation v1 Query Files`:

v1 Query Files
--------------

Any file with the ``.json`` extension under the ``instrumentation/v1/query/``
directory is recognized as a query for instrumentation data.

These files must contain a JSON object with the following keys. The ``version``
key is required, but all other fields are optional.

``version``
  The Data version of snippet file to generate, an integer. Currently the only
  supported version is ``1``.

``callbacks``
  A list of command-line strings for `Callbacks`_ to handle collected
  instrumentation data. Whenever these callbacks are executed, the full path to
  a `v1 Index File`_ is appended to the arguments included in the string.

``hooks``
  A list of strings specifying when `索引`_ should occur automatically.
  These are the intervals when instrumentation data should be collated and user
  `Callbacks`_ should be invoked to handle the data. Elements in this list
  should be one of the following:

  * ``postGenerate``
  * ``preBuild`` (called when ``ninja``  or ``make`` is invoked; unavailable on Windows)
  * ``postBuild`` (called when ``ninja`` or ``make`` completes; unavailable on Windows)
  * ``preCMakeBuild`` (called when ``cmake --build`` is invoked)
  * ``postCMakeBuild`` (called when ``cmake --build`` completes)
  * ``postInstall``
  * ``postTest``

``queries``
  A list of strings specifying additional optional data to collect during
  instrumentation. Elements in this list should be one of the following:

    ``staticSystemInformation``
      Enables collection of the static information about the host machine CMake
      is being run from. This data is collected during `索引`_ and is
      included in the generated `v1 Index File`_.

    ``dynamicSystemInformation``
      Enables collection of the dynamic information about the host machine
      CMake is being run from. Data is collected for every `v1 Snippet File`_
      generated by CMake, and includes information from immediately before and
      after the command is executed.

The ``callbacks`` listed will be invoked during the specified hooks
*at a minimum*. When there are multiple query files, the ``callbacks``,
``hooks`` and ``queries`` between them will be merged. Therefore, if any query
file includes any ``hooks``, every ``callback`` across all query files will be
executed at every ``hook`` across all query files. Additionally, if any query
file includes any optional ``queries``, the optional query data will be present
in all data files.

Example:

.. code-block:: json

  {
    "version": 1,
    "callbacks": [
      "/usr/bin/python callback.py",
      "/usr/bin/cmake -P callback.cmake arg",
    ],
    "hooks": [
      "postCMakeBuild",
      "postInstall"
    ],
    "queries": [
      "staticSystemInformation",
      "dynamicSystemInformation"
    ]
  }

In this example, after every ``cmake --build`` or ``cmake --install``
invocation, an index file ``index-<hash>.json`` will be generated in
``<build>/.cmake/instrumentation/v1/data`` containing a list of data snippet
files created since the previous indexing. The commands
``/usr/bin/python callback.py index-<hash>.json`` and
``/usr/bin/cmake -P callback.cmake arg index-<hash>.json`` will be executed in
that order. The index file will contain the ``staticSystemInformation`` data and
each snippet file listed in the index will contain the
``dynamicSystemInformation`` data. Once both callbacks have completed, the index
file and all snippet files listed by it will be deleted from the project build
tree.

.. _`cmake-instrumentation Data v1`:

Data v1
=======

Data version specifies the contents of the output files generated by the CMake
instrumentation API as part of the `数据收集`_ and `索引`_. There are
two types of data files generated: the `v1 Snippet File`_ and `v1 Index File`_.
When using the `API v1`_, these files live in
``<build>/.cmake/instrumentation/v1/data/`` under the project build tree.

v1 Snippet File
---------------

Snippet files are generated for every compile, link and custom command invoked
as part of the CMake build or install step and contain instrumentation data about
the command executed. Additionally, snippet files are created for the following:

* The CMake configure step
* The CMake generate step
* Entire build step (executed with ``cmake --build``)
* Entire install step (executed with ``cmake --install``)
* Each ``ctest`` invocation
* Each individual test executed by ``ctest``.

These files remain in the build tree until after `索引`_ occurs and any
user-specified `Callbacks`_ are executed.

Snippet files have a filename with the syntax ``<role>-<timestamp>-<hash>.json``
and contain the following data:

  ``version``
    The Data version of the snippet file, an integer. Currently the version is
    always ``1``.

  ``command``
    The full command executed. Excluded when ``role`` is ``build``.

  ``result``
    The exit-value of the command, an integer.

  ``role``
    The type of command executed, which will be one of the following values:

    * ``configure``: the CMake configure step
    * ``generate``: the CMake generate step
    * ``compile``: an individual compile step invoked during the build
    * ``link``: an individual link step invoked during the build
    * ``custom``: an individual custom command invoked during the build
    * ``build``: a complete ``make`` or ``ninja`` invocation. Only generated if ``preBuild`` or ``postBuild`` hooks are enabled.
    * ``cmakeBuild``: a complete ``cmake --build`` invocation
    * ``cmakeInstall``: a complete ``cmake --install`` invocation
    * ``install``: an individual ``cmake -P cmake_install.cmake`` invocation
    * ``ctest``: a complete ``ctest`` invocation
    * ``test``: a single test executed by CTest

  ``target``
    The CMake target associated with the command. Only included when ``role`` is
    ``compile`` or ``link``.

  ``targetType``
    The :prop_tgt:`TYPE` of the target. Only included when ``role`` is
    ``link``.

  ``targetLabels``
    The :prop_tgt:`LABELS` of the target. Only included when ``role`` is
    ``link``.

  ``timeStart``
    Time at which the command started, expressed as the number of milliseconds
    since the system epoch.

  ``duration``
    The duration that the command ran for, expressed in milliseconds.

  ``outputs``
    The command's output file(s), an array. Only included when ``role`` is one
    of: ``compile``, ``link``, ``custom``.

  ``outputSizes``
    The size(s) in bytes of the ``outputs``, an array. For files which do not
    exist, the size is 0. Included under the same conditions as the ``outputs``
    field.

  ``source``
    The source file being compiled. Only included when ``role`` is ``compile``.

  ``language``
    The language of the source file being compiled. Only included when ``role`` is
    ``compile``.

  ``testName``
    The name of the test being executed. Only included when ``role`` is ``test``.

  ``config``
    The type of build, such as ``Release`` or ``Debug``. Only included when
    ``role`` is ``compile``, ``link`` or ``test``.

  ``dynamicSystemInformation``
    Specifies the dynamic information collected about the host machine
    CMake is being run from. Data is collected for every snippet file
    generated by CMake, with data immediately before and after the command is
    executed. Only included when enabled by the `v1 Query Files`_.

    ``beforeHostMemoryUsed``
      The Host Memory Used in KiB at ``timeStart``.

    ``afterHostMemoryUsed``
      The Host Memory Used in KiB at ``timeStop``.

    ``beforeCPULoadAverage``
      The Average CPU Load at ``timeStart``.

    ``afterCPULoadAverage``
      The Average CPU Load at ``timeStop``.

Example:

.. code-block:: json

  {
    "version": 1,
    "command" : "\"/usr/bin/c++\" \"-MD\" \"-MT\" \"CMakeFiles/main.dir/main.cxx.o\" \"-MF\" \"CMakeFiles/main.dir/main.cxx.o.d\" \"-o\" \"CMakeFiles/main.dir/main.cxx.o\" \"-c\" \"<src>/main.cxx\"",
    "role" : "compile",
    "return" : 1,
    "target": "main",
    "language" : "C++",
    "outputs" : [ "CMakeFiles/main.dir/main.cxx.o" ],
    "outputSizes" : [ 0 ],
    "source" : "<src>/main.cxx",
    "config" : "Debug",
    "dynamicSystemInformation" :
    {
      "afterCPULoadAverage" : 2.3500000000000001,
      "afterHostMemoryUsed" : 6635680.0
      "beforeCPULoadAverage" : 2.3500000000000001,
      "beforeHostMemoryUsed" : 6635832.0
    },
    "timeStart" : 1737053448177,
    "duration" : 31
  }

v1 Index File
-------------

Index files contain a list of `v1 Snippet File`_. It serves as an entry point
for navigating the instrumentation data. They are generated whenever `索引`_
occurs and deleted after any user-specified `Callbacks`_ are executed.

``version``
  The Data version of the index file, an integer. Currently the version is
  always ``1``.

``buildDir``
  The build directory of the CMake project.

``dataDir``
  The full path to the ``<build>/.cmake/instrumentation/v1/data/`` directory.

``hook``
  The name of the hook responsible for generating the index file. In addition
  to the hooks that can be specified by one of the `v1 Query Files`_, this value may
  be set to ``manual`` if indexing is performed by invoking
  ``ctest --collect-instrumentation <build>``.

``snippets``
  Contains a list of `v1 Snippet File`_. This includes all snippet files
  generated since the previous index file was created. The file paths are
  relative to ``dataDir``.

``staticSystemInformation``
  Specifies the static information collected about the host machine
  CMake is being run from. Only included when enabled by the `v1 Query Files`_.

  * ``OSName``
  * ``OSPlatform``
  * ``OSRelease``
  * ``OSVersion``
  * ``familyId``
  * ``hostname``
  * ``is64Bits``
  * ``modelId``
  * ``numberOfLogicalCPU``
  * ``numberOfPhysicalCPU``
  * ``processorAPICID``
  * ``processorCacheSize``
  * ``processorClockFrequency``
  * ``processorName``
  * ``totalPhysicalMemory``
  * ``totalVirtualMemory``
  * ``vendorID``
  * ``vendorString``

Example:

.. code-block:: json

  {
    "version": 1,
    "hook": "manual",
    "buildDir": "<build>",
    "dataDir": "<build>/.cmake/instrumentation/v1/data",
    "snippets": [
      "configure-<timestamp>-<hash>.json",
      "generate-<timestamp>-<hash>.json",
      "compile-<timestamp>-<hash>.json",
      "compile-<timestamp>-<hash>.json",
      "link-<timestamp>-<hash>.json",
      "install-<timestamp>-<hash>.json",
      "ctest-<timestamp>-<hash>.json",
      "test-<timestamp>-<hash>.json",
      "test-<timestamp>-<hash>.json",
    ]
  }
