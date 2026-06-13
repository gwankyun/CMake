.. cmake-manual-description: CMake Instrumentation
.. |Data Collection| replace:: :ref:`cmake-instrumentation Data Collection`
.. |Indexing| replace:: :ref:`cmake-instrumentation Indexing`
.. |v1 Snippet File| replace:: :ref:`cmake-instrumentation v1 Snippet File`
.. |v1 Snippet Files| replace:: :ref:`v1 Snippet Files <cmake-instrumentation v1 Snippet File>`
.. |v1 Query Files| replace:: :ref:`cmake-instrumentation v1 Query Files`
.. |Callbacks| replace:: :ref:`cmake-instrumentation Callbacks`
.. |Google Trace File| replace:: :ref:`cmake-instrumentation Google Trace File`
.. |v1 CMake Content File| replace:: :ref:`cmake-instrumentation v1 CMake Content File`
.. |v1 CMake Content Files| replace:: :ref:`v1 CMake Content Files <cmake-instrumentation v1 CMake Content File>`
.. |v1 Indexing File| replace:: :ref:`cmake-instrumentation v1 Indexing File`
.. |v1 Indexing Files| replace:: :ref:`v1 Indexing Files <cmake-instrumentation v1 Indexing File>`

cmake-instrumentation(7)
************************

.. versionadded:: 4.3

.. only:: html

  .. contents::

引言
============

CMake插桩API允许在CMake项目的配置、生成、构建、测试和安装步骤期间收集计时数据、目标信息以及\
系统诊断信息。

All interactions with the CMake instrumentation API must specify both an API
version and a `Data Version`_. There is only one API version, see the `API v1`_.

.. note::

  此功能仅适用于使用\ :ref:`Makefile Generators`、\ :ref:`Ninja Generators`\ 或\
  :generator:`FASTBuild`\ 的项目。

概述
--------

CMake插桩的工作分为两个主要阶段：|Data Collection|\ 和\ |Indexing|。

|Data Collection|\ 是CMake将插桩数据写入项目构建树的过程。以此方式进行\
插桩的命令涵盖了从整体构建到单个编译命令。完整的插桩命令列表记录在\
|v1 Snippet File|\ 下。

收集的数据将持续累积，直到\ |Indexing|\ 发生：即整理生成数据的过程。索引在称为“钩子”的事件\
上发生，这些钩子可以作为\ |v1 Query Files|\ 的一部分进行配置。|v1 Indexing File|\ 将被创建\
并传递给任何用户定义的\ |Callbacks|，用于处理数据。一旦所有\ |Callbacks|\ 运行完毕，CMake\
将删除这些文件。

无需任何自定义\ |Callbacks|，CMake即可将插桩数据提交到\ `CDash`_，或生成\
|Google Trace File|\ 用于可视化。

.. _`cmake-instrumentation Data Collection`:

数据收集
---------------

每当在启用插桩的情况下执行命令时，会在项目构建树中创建一个\ |v1 Snippet File|，其中包含\
该命令的特定数据。这些文件会一直保留到\ |Indexing|\ 操作完成之后。

CMake设置\ :prop_gbl:`RULE_LAUNCH_COMPILE`、\ :prop_gbl:`RULE_LAUNCH_LINK`\ 和\
:prop_gbl:`RULE_LAUNCH_CUSTOM`\ 全局属性，将每个编译、链接和自定义命令的调用包装在一个启动器中，\
该启动器执行插桩并写入\ |v1 Snippet File|。如果项目已通过\
:module:`CTestUseLaunchers`\ 进行配置，该启动器将在执行该模块通常处理的通信功能之外，\
额外收集插桩数据。

.. _`cmake-instrumentation Indexing`:

索引
--------

索引是整理已生成插桩数据的过程。触发索引的可用钩子包括诸如每次构建后或每次\
:manual:`ctest <ctest(1)>`\ 调用后等选项，这些钩子作为\ |v1 Query Files|\ 的一部分进行配置。\
每当钩子被触发时，将生成一个包含比上次索引更新的snippet文件列表的索引文件。此索引文件将传递给用户\
定义的\ |Callbacks|\ 命令以处理数据。

也可以通过手动调用\ :option:`ctest --collect-instrumentation`\ 来生成索引。

索引及随后的回调不会在单个构建树中并发执行。当多个钩子同时触发索引时，将使用基于文件的锁来确保\
一次索引完成、执行其所有回调、并删除插桩数据后，下一次索引才能开始。

.. _`cmake-instrumentation Callbacks`:

回调函数
^^^^^^^^^

作为\ |v1 Query Files|\ 的一部分，用户可以提供一个回调函数列表，用于处理此功能收集的数据。

Whenever |Indexing| occurs, each provided callback is executed, passing the
path to the generated |v1 Indexing File| as an additional argument.

这些回调函数可以在用户级别或项目级别定义，应该读取插桩数据并执行任何所需的处理。一旦所有回调\
函数执行完毕，CMake会自动删除索引文件及其列出的片段文件。请注意，回调函数绝不应手动移动或\
删除这些数据文件，因为其他回调函数可能还需要它们。

If indexing is triggered again before |Callbacks| have finished running,
the generated index file will contain only instrumentation data generated since
the previous indexing.

启用插桩功能
========================

Instrumentation can be enabled either for an individual CMake project, or
for all CMake projects configured and built by a user. In all cases, a "query"
represents a request for instrumentation behavior. See the |v1 Query Files|
for details on configuring this feature.

在项目级别启用插桩功能
---------------------------------------------

Project code can contain instrumentation queries by using the
:command:`cmake_instrumentation` command.

此外，查询文件可以手动放置在构建树顶部的\ ``<build>/.cmake/instrumentation/<version>/query/``\
目录下。此版本的CMake仅支持一种版本模式，即\ `API v1`_。

在用户级别启用插桩功能
------------------------------------------

可以通过将查询文件放置在\ :envvar:`CMAKE_CONFIG_DIR`\ 下的\
``<config_dir>/instrumentation/<version>/query/``\ 目录中来在用户级别配置插桩功能。

.. _`CDash`:

为CDash提交启用插桩功能
----------------------------------------------

You can enable instrumentation when using :module:`CTest` in
:ref:`Dashboard Client` mode by setting the :envvar:`CTEST_USE_INSTRUMENTATION`
environment variable. Doing so automatically enables the
``dynamicSystemInformation`` option.

下表显示了每种插桩命令类型如何映射到相应类型的CTest XML文件。

=========================================================== ==================
:ref:`Snippet Role <cmake-instrumentation v1 Snippet File>` CTest XML File
=========================================================== ==================
``configure``                                               ``Configure.xml``
``generate``                                                ``Configure.xml``
``compile``                                                 ``Build.xml``
``link``                                                    ``Build.xml``
``custom``                                                  ``Build.xml``
``build``                                                   unused!
``cmakeBuild``                                              ``Build.xml``
``cmakeInstall``                                            ``Build.xml``
``install``                                                 ``Build.xml``
``ctest``                                                   ``Build.xml``
``test``                                                    ``Test.xml``
=========================================================== ==================

默认情况下，报告给CDash的命令行在第一个空格处截断。你可以通过将\
:envvar:`CTEST_USE_VERBOSE_INSTRUMENTATION`\ 设置为1来选择报告完整的命令行（包括参数）。

Alternatively, you can use the |v1 Query Files| to enable instrumentation for
CDash using the ``cdashSubmit`` and ``cdashVerbose`` options.

In order for the submitted ``Build.xml`` file to group the snippet files
correctly, all configure and build commands should be executed with CTest in
Dashboard Client mode.

.. _`cmake-instrumentation API v1`:

API v1
======

The API version specifies the layout of the instrumentation directory, as well
as the general format of the query files and :command:`cmake_instrumentation`
command arguments.

插桩API v1位于\ ``instrumentation/v1/``\ 目录下，对于输出数据和项目级查询，该目录位于\
``<build>/.cmake/``\ 下；对于用户级查询，该目录位于\ ``<config_dir>/``\ 下。此目录中的\
``v1``\ 部分表示API版本。它有以下子目录：

``query/``
  存放用户或客户端编写的查询文件。任何扩展名为\ ``.json``\ 的文件都将被识别为查询文件。\
  这些文件由创建它们的客户端或用户拥有。

``query/generated/``
  Holds query files generated by a CMake project with the
  :command:`cmake_instrumentation` command or the
  :envvar:`CTEST_USE_INSTRUMENTATION` variable. These files are owned by CMake
  and are deleted and regenerated automatically during the CMake configure
  step.

``data/``
  存放项目上收集的插桩数据。CMake 拥有所有数据文件，其他进程绝不应删除它们。这里收集的数据会\
  一直保留，直到\ |Indexing|\ 操作完成且所有\ |Callbacks|\ 执行完毕。

``data/index/``
  A subset of the collected data, containing any
  |v1 Indexing Files|.

``data/content/``
  A subset of the collected data, containing any
  |v1 CMake Content Files|.

``data/trace/``
  A subset of the collected data, containing the |Google Trace File| created
  from the most recent |Indexing|. Unlike other data files, the most recent
  trace file remains even after |Indexing| occurs and all |Callbacks| are
  executed, until the next time |Indexing| occurs.

``data/compile-trace/``
  A subset of the collected data, containing any trace files generated by
  the compiler, when the ``compileTrace`` `option <v1 Query Files_>`_ is
  enabled.

``cdash/``
  存放内部用于生成要提交给CDash的XML内容的临时文件。

.. _`cmake-instrumentation Data Version`:

Data Version
------------

The data version specifies the contents of the output files generated by the
`API v1`_ as part of the |Data Collection| and |Indexing| processes.

|v1 Query Files|, or a :command:`cmake_instrumentation` invocation, should
request a specific Data Version, and `v1 Data Files`_ of the corresponding
version will be generated and sent to the user |Callbacks| defined in that
query.

Currently, the only supported major version is ``1``, and the maximum supported
minor version is also ``1``. A new major version number will be created whenever
previously included data is removed or reformatted such that scripts written to
parse this data may become incompatible with the new format. A new minor version
number will be created whenever new data becomes available.

.. _`cmake-instrumentation v1 Query Files`:

v1查询文件
--------------

``instrumentation/v1/query/``\ 目录下任何扩展名为\ ``.json``\ 的文件都被识别为插桩数据\
的查询文件。

这些文件必须包含一个具有以下键的JSON对象。\ ``version``\ 键是必需的，但所有其他字段都是可选的。

``version``
  The `Data Version`_ of snippet files to generate.

  In query files, this may be specified either as an integer major version or
  as an object with ``major`` and ``minor`` members. For example, ``1`` and
  ``{ "major": 1, "minor": 0 }`` both request version ``1.0``. Specifying a
  minor version is optional. CMake will always generate instrumentation data
  for the most recent minor version, even if an earlier minor version is
  requested.

  Currently, the only supported version is ``1.0``. Query files with an unknown
  data version will be ignored.

``callbacks``
  用于处理收集的插桩数据的\ |Callbacks|\ 的命令行字符串列表。每当执行这些回调时，\
  |v1 Indexing File|\ 的完整路径将附加到字符串中包含的参数后面。

``hooks``
  一个字符串列表，指定\ |Indexing|\ 应自动发生的时间。这些是应该整理插桩数据并调用用户\
  |Callbacks|\ 来处理数据的时间间隔。此列表中的元素应该是以下之一：

  * ``postGenerate``
  * ``preBuild`` (在调用\ ``ninja``\ 或\ ``make``\ 时调用)
  * ``postBuild`` (在\ ``ninja``\ 或\ ``make``\ 完成时调用)
  * ``preCMakeBuild`` (在调用\ :option:`cmake --build`\ 时调用)
  * ``postCMakeBuild`` (在\ :option:`cmake --build`\ 完成时调用)
  * ``postCMakeInstall``
  * ``postCMakeWorkflow``
  * ``postCTest``

  ``preBuild`` and ``postBuild`` are not supported when using the
  :generator:`MSYS Makefiles` or :generator:`FASTBuild` generators.
  Additionally, they will not be triggered when the build tool is invoked by
  :option:`cmake --build`.

``options``
  A list of strings used to enable certain optional behavior, including the
  collection of certain additional data. Elements in this list should be one of
  the following:

    ``staticSystemInformation``
      启用收集运行CMake的主机的静态信息。此数据在\ |Indexing|\ 期间收集，并包含在生成的\
      |v1 Indexing File|\ 中。

    ``dynamicSystemInformation``
      启用收集运行CMake的主机的动态信息。为CMake生成的每个\ |v1 Snippet File|\ 收集数据，\
      包括命令执行前后的信息。

    ``captureOutput``
      .. versionadded:: 4.4

      Enables collection of command output in generated `v1 Snippet Files`_.
      When enabled, snippets for ``compile``, ``link``, ``custom``, ``test``, and
      ``install`` commands include ``stdout`` and ``stderr`` fields.

      Only available as of data version ``1.1``.

    ``compileTrace``
      .. versionadded:: 4.4

      Enables collection of JSON files generated by Clang's
      ``-ftime-trace`` option. When such files are created for an
      instrumented compile command, they are copied into the instrumentation
      ``data`` directory and referenced from the compile snippet.

      Only available as of data version ``1.1``.

    ``cdashSubmit``
      Enables including instrumentation data in CDash. This is
      equivalent to having the :envvar:`CTEST_USE_INSTRUMENTATION` environment
      variable enabled.

    ``cdashVerbose``
      Enables including the full untruncated commands in data submitted to
      CDash. Equivalent to having the
      :envvar:`CTEST_USE_VERBOSE_INSTRUMENTATION` and
      :envvar:`CTEST_USE_INSTRUMENTATION` environment variables enabled.

    ``trace``
      Enables generation of a |Google Trace File| during |Indexing| to
      visualize data from the |v1 Snippet Files| collected.

The ``callbacks`` listed will be invoked during the specified hooks
*at a minimum*. When there are multiple query files, the ``callbacks``,
``hooks`` and ``options`` between them will be merged. Therefore, if any query
file includes any ``hooks``, every ``callback`` across all query files will be
executed at every ``hook`` across all query files. Additionally, if any query
file requests optional data using the ``options`` field, any related data will
be present in all snippet files. User written ``callbacks`` should be able to
handle the presence of this optional data, since it may be requested by an
unrelated query.

The JSON format is described in machine-readable form by
:download:`this JSON schema </manual/instrumentation/query-v1-schema.json>`.

示例

.. code-block:: json

  {
    "version": 1,
    "callbacks": [
      "/usr/bin/python callback.py",
      "/usr/bin/cmake -P callback.cmake arg",
    ],
    "hooks": [
      "postCMakeBuild",
      "postCMakeInstall"
    ],
    "options": [
      "staticSystemInformation",
      "dynamicSystemInformation",
      "captureOutput",
      "cdashSubmit",
      "trace"
    ]
  }

In this example, after every :option:`cmake --build` or
:option:`cmake --install` invocation, an index file ``index-<timestamp>.json``
will be generated in ``<build>/.cmake/instrumentation/v1/data/index``
containing a list of data snippet files created since the previous indexing.
The commands ``/usr/bin/python callback.py index-<timestamp>.json`` and
``/usr/bin/cmake -P callback.cmake arg index-<timestamp>.json`` will be
executed in that order. The index file will contain the
``staticSystemInformation`` data and each snippet file listed in the index will
contain the ``dynamicSystemInformation`` data and captured command output.
Additionally, the index file will contain the path to the generated
`Google Trace File`_. Once both callbacks have completed, the index file and
data files listed by it (including snippet files, but not the trace file) will
be deleted from the project build tree. The instrumentation data will be
present in the XML files submitted to CDash, but with truncated command
strings because ``cdashVerbose`` was not enabled.

v1 Data Files
-------------

There are four types of data files generated as part of `API v1`_:
the |v1 Snippet File|, |v1 Indexing File|, |v1 CMake Content File|, and the
|Google Trace File|. These files live in
``<build>/.cmake/instrumentation/v1/data/`` under the project build tree.

Note that the ``v1`` delineation of these files refers to the `API v1`_.
The `Data Version`_ of these files is specified with a ``version`` field as
part of the file contents.


.. _`cmake-instrumentation v1 Snippet File`:

v1片段文件
---------------

片段文件会为CMake构建或安装步骤中调用的每个编译、链接和自定义命令生成，并包含有关执行命令的\
插桩数据。此外，还会为以下情况创建片段文件：

* CMake配置步骤
* CMake生成步骤
* 整个构建步骤（使用\ :option:`cmake --build`\ 执行）
* 整个安装步骤（使用\ :option:`cmake --install`\ 执行）
* Each time :manual:`ctest <ctest(1)>` is invoked to
  :ref:`run tests <Run Tests>` (even if no tests are found)
* :manual:`ctest <ctest(1)>`\ 执行的每个单独测试。

这些文件会一直保留在构建树中，直到\ |Indexing|\ 操作完成且任何用户指定的\ |Callbacks|\ 执行完毕。

.. note::

  Configure and generate snippet files are not written by CMake until the
  generate step is complete. When using :manual:`cmake-gui(1)` or
  :manual:`ccmake(1)`, triggering only configure step(s) without generating the
  project files will not generate any configure snippets. Once the generate
  step is run, there will be one configure snippet for each time the configure
  step was run.

片段文件的文件名语法为\ ``<role>-<hash>-<timestamp>.json``，并包含以下数据

  ``version``
    The `Data Version`_ of the snippet file. Currently the version is
    always ``{ "major": 1, "minor": 0 }``.

  ``command``
    执行的完整命令。当\ ``role``\ 为\ ``build``\ 时排除。

  ``workingDir``
    The working directory in which the ``command`` was executed.

  ``result``
    命令的退出码，一个整数。 This will be ``null`` when
    ``role`` is ``build``.

  ``stdout``
    .. versionadded:: 4.4

    The standard output produced by the command. Only included when enabled by
    the ``captureOutput`` `option <v1 Query Files_>`_ and when ``role`` is one
    of: ``compile``, ``link``, ``custom``, ``install`` or ``test``. For
    ``test`` snippets, this field contains the merged standard out and standard
    error streams.

  ``stderr``
    .. versionadded:: 4.4

    The standard error output produced by the command. Only included when
    enabled by the ``captureOutput`` `option <v1 Query Files_>`_ and when
    ``role`` is one of: ``compile``, ``link``, ``custom``, ``install`` or
    ``test``. For ``test`` snippets, error output is merged with ``stdout``,
    and the value of ``stderr`` is always empty.

  ``role``
    执行的命令类型，将是以下值之一：

    * ``configure``：CMake配置步骤
    * ``generate``：CMake生成步骤
    * ``compile``：构建期间调用的单个编译步骤
    * ``link``：构建期间调用的单个链接步骤
    * ``custom``：构建期间调用的单个自定义命令
    * ``build``: a complete ``make`` or ``ninja`` invocation
      (not through :option:`cmake --build`).
    * ``cmakeBuild``：完整的\ :option:`cmake --build`\ 调用
    * ``cmakeInstall``：完整的\ :option:`cmake --install`\ 调用
    * ``install``：单个\ ``cmake -P cmake_install.cmake``\ 调用
    * ``ctest``：完整的\ :manual:`ctest <ctest(1)>`\ 命令\ 调用
    * ``test``：:manual:`ctest <ctest(1)>`\ 执行的单个测试

  ``target``
    The CMake target associated with the command. Only included when ``role``
    is ``compile`` or ``link``, or when ``role`` is ``custom`` and the custom
    command is attached to a target with :command:`add_custom_command(TARGET)`.
    In conjunction with ``cmakeContent``, this can be used to look up the
    target :prop_tgt:`TYPE` and :prop_tgt:`LABELS`.

  ``timeStart``
    命令开始的时间，以自系统纪元以来的毫秒数表示。

  ``duration``
    命令运行的持续时间，以毫秒表示。

  ``outputs``
    命令的输出文件数组。仅当\ ``role``\ 为以下之一时包含：\ ``compile``、\ ``link``、\
    ``custom``。

  ``outputSizes``
    ``outputs``\ 的大小数组，以字节为单位。对于不存在的文件，大小为0。在与\ ``outputs``\
    字段相同的条件下包含。

  ``source``
    正在编译的源文件。仅当\ ``role``\ 为\ ``compile``\ 时包含。

  ``language``
    正在编译的源文件的语言。仅当\ ``role``\ 为\ ``compile``\ 或\ ``link``\ 时包含。

  ``testName``
    正在执行的测试的名称。仅当\ ``role``\ 为\ ``test``\ 时包含。

  ``config``
    The :ref:`Build Configuration <Build Configurations>`, such as ``Release``
    or ``Debug``. Only included when ``role`` is one of: ``compile``, ``link``,
    ``custom``, ``install``, ``test``.

  ``traceFile``
    .. versionadded:: 4.4

    A path, relative to the instrumentation ``data`` directory, referencing a
    copied JSON file generated by Clang's ``-ftime-trace`` option. Only
    included when the ``compileTrace`` `option
    <v1 Query Files_>`_ is enabled and  ``role`` is
    ``compile``. If no JSON file was produced by the compile command, this value
    is ``null``.

  ``dynamicSystemInformation``
    指定收集的有关运行CMake的主机的动态信息。为CMake生成的每个片段文件收集数据，包括命令执行\
    前后的数据。仅当由\ |v1 Query Files|\ 启用时包含。

    ``beforeHostMemoryUsed``
      在\ ``timeStart``\ 时使用的主机内存，以KiB为单位。

    ``afterHostMemoryUsed``
      在\ ``timeStart + duration``\ 时使用的主机内存，以KiB为单位。

    ``beforeCPULoadAverage``
      在\ ``timeStart``\ 时的平均CPU负载, or ``null`` if it cannot be
      determined.

    ``afterCPULoadAverage``
      在\ ``timeStart + duration``\ 时的平均CPU负载, or ``null`` if it cannot
      be determined.

  ``cmakeContent``
    The path to a |v1 CMake Content File| located under ``data``, which
    contains information about the CMake configure and generate steps
    responsible for generating the ``command`` in this snippet. When using
    :manual:`cmake-gui(1)` or :manual:`ccmake(1)`, this field may be ``null``
    for all configure steps up to the most recent one before the generate step.

  ``showOnly``
    A boolean representing whether the
    :option:`--show-only <ctest --show-only>` option was passed to
    :manual:`ctest <ctest(1)>`. Only included when ``role`` is ``ctest``.

Example:

.. code-block:: json

  {
    "version": {
      "major": 1,
      "minor": 1
    },
    "command" : "\"/usr/bin/c++\" \"-MD\" \"-MT\" \"CMakeFiles/main.dir/main.cxx.o\" \"-MF\" \"CMakeFiles/main.dir/main.cxx.o.d\" \"-o\" \"CMakeFiles/main.dir/main.cxx.o\" \"-c\" \"<src>/main.cxx\"",
    "role" : "compile",
    "result" : 1,
    "stdout" : "<compiler stdout>",
    "stderr" : "<compiler stderr>",
    "target": "main",
    "language" : "C++",
    "outputs" : [ "CMakeFiles/main.dir/main.cxx.o" ],
    "outputSizes" : [ 0 ],
    "traceFile" : "compile-trace/main.cxx-<hash>.json",
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
    "duration" : 31,
    "cmakeContent" : "content/cmake-2025-07-11T12-46-32-0572.json"
  }

.. _`cmake-instrumentation v1 Indexing File`:

v1索引文件
-------------

索引文件包含一个\ |v1 Snippet File|\ 列表。它作为导航插桩数据的入口点。每当\ |Indexing|\ 操作发生\
时生成，并在任何用户指定的\ |Callbacks|\ 执行完毕后删除。

``version``
  The `Data Version`_ of the index file. Currently this is always written as:
  ``{ "major": 1, "minor": 0 }``.

``buildDir``
  CMake项目的构建目录。

``dataDir``
  ``<build>/.cmake/instrumentation/v1/data/``\ 目录的完整路径。

``hook``
  负责生成索引文件的钩子名称。除了可以由\ |v1 Query Files|\ 指定的钩子之外，如果通过调用\
  :option:`ctest --collect-instrumentation`\ 执行索引，此值可能设置为\ ``manual``。

  Note that the hook is not directly tied to what data may be available.
  A ``postBuild`` hook, for example, may include ``test`` or ``install``
  snippets, if these steps were run since the previous indexing.

``snippets``
  包含一个\ |v1 Snippet File|\ 列表。这包括自上一个索引文件创建以来生成的所有片段文件。文件路径\
  相对于\ ``dataDir``。

  This list may be empty if indexing was run twice in succession, such as when
  building multiple times with both the ``preBuild`` and ``postBuild`` hooks
  enabled.

``trace``
  Contains the path to the |Google Trace File|. This includes data from all
  corresponding ``snippets`` in the index file. The file path is relative to
  ``dataDir``. Only included when enabled by the |v1 Query Files|.

``staticSystemInformation``
  Specifies the static information collected about the host machine
  CMake is being run from. If CMake is unable to determine the value of any
  given field, it will be ``null``. See :command:`cmake_host_system_information`
  for a description of each of the following fields.

  Only included when enabled by the |v1 Query Files|.

  * ``OSName``
  * ``OSPlatform``
  * ``OSRelease``
  * ``OSVersion``
  * ``familyId``
  * ``hostname``
  * ``is64Bits``
  * ``modelId``
  * ``modelName``
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

示例：

.. code-block:: json

  {
    "version": {
      "major": 1,
      "minor": 0
    },
    "hook": "manual",
    "buildDir": "<build>",
    "dataDir": "<build>/.cmake/instrumentation/v1/data",
    "snippets": [
      "configure-<hash>-<timestamp>.json",
      "generate-<hash>-<timestamp>.json",
      "compile-<hash>-<timestamp>.json",
      "compile-<hash>-<timestamp>.json",
      "link-<hash>-<timestamp>.json",
      "install-<hash>-<timestamp>.json",
      "ctest-<hash>-<timestamp>.json",
      "test-<hash>-<timestamp>.json",
      "test-<hash>-<timestamp>.json",
    ],
    "trace": "trace/trace-<timestamp>.json"
  }

.. versionadded:: 4.4
  The JSON format is described in machine-readable form by
  :download:`this JSON schema </manual/instrumentation/index-v1-schema.json>`.

.. _`cmake-instrumentation v1 CMake Content File`:

v1 CMake内容文件
---------------------

CMake content files contain information about the CMake configure and generate
steps. Each |v1 Snippet File| provides the path to one of these files
corresponding to the CMake invocation responsible for generating its command.

Each CMake content file contains the following:

  ``version``
    The `Data Version`_ of the content file. Currently the version is
    always ``{ "major": 1, "minor": 0 }``.

  ``project``
    The value of :variable:`CMAKE_PROJECT_NAME`.

  ``custom``
    An object containing arbitrary JSON data specified by the user with the
    :ref:`cmake_instrumentation CUSTOM_CONTENT` functionality of the
    :command:`cmake_instrumentation` command.

  ``targets``
    An object containing CMake targets, indexed by name, that have
    corresponding instrumentation data. Each target contains the following:

    ``type``
      The :prop_tgt:`TYPE` property of the target. Only ``EXECUTABLE``,
      ``STATIC_LIBRARY``, ``SHARED_LIBRARY``, ``MODULE_LIBRARY`` and
      ``OBJECT_LIBRARY`` targets are included.

    ``labels``
      The :prop_tgt:`LABELS` property of the target.

.. _`cmake-instrumentation Google Trace File`:

Google跟踪文件
-----------------

CMake can generate a file in the `Google Trace Event Format`_ to help visualize
collected instrumentation data. Enabling the ``trace`` option in the
|v1 Query Files| causes such a file to be generated under
``<build>/.cmake/instrumentation/v1/data/trace`` whenever |Indexing| occurs.

Generated trace files include data from all
|v1 Snippet Files| listed in the current index file.

When instrumentation data is deleted by CMake after |Indexing|, the most
recent trace file remains so that it can be manually inspected without the need
for any custom |Callbacks|.

Trace files are stored in the ``JSON Array Format``, where each
|v1 Snippet File| corresponds to a single trace event object. Each trace
event contains the following data:

``name``
  A descriptive name generated by CMake based on the given snippet data.

``cat``
  The ``role`` from the |v1 Snippet File|.

``ph``
  Currently, always ``"X"`` to represent "Complete Events".

``ts``
  The ``timeStart`` from the |v1 Snippet File|, converted from milliseconds to
  microseconds.

``dur``
  The ``duration`` from the |v1 Snippet File|, converted from milliseconds to
  microseconds.

``pid``
  Unused (always zero).

``tid``
  An integer ranging from zero to the number of concurrent jobs with which the
  processes being indexed ran. This is a synthetic ID calculated by CMake
  based on the ``ts`` and ``dur`` of all snippet files being indexed in
  order to produce a more useful visualization of the process concurrency.

``args``
  Contains all data from the |v1 Snippet File| corresponding to this trace
  event.

.. _`Google Trace Event Format`: https://docs.google.com/document/d/1CvAClvFfyA5R-PhYUmn5OOQtYMH4h6I0nSsKchNAySU/preview
