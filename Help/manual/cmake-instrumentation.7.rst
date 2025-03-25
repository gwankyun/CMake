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

每当在启用插桩的情况下执行命令时，会在项目构建树中创建一个\ `v1片段文件`_ ，其中包含\
该命令的特定数据。这些文件会一直保留到\ `索引`_\ 操作完成之后。

CMake会设置全局属性\ :prop_gbl:`RULE_LAUNCH_COMPILE`、\ :prop_gbl:`RULE_LAUNCH_LINK`\
和\ :prop_gbl:`RULE_LAUNCH_CUSTOM`，以使用\ ``ctest --instrument``\ 启动器，从而分别\
捕获每个编译、链接和自定义命令的详细信息。如果项目使用了\ :module:`CTestUseLaunchers`\
进行配置，\ ``ctest --instrument``\ 还将包含\ ``ctest --launch``\ 通常执行的行为。

索引
--------

索引是整理生成的插桩数据的过程。索引会在称为钩子的特定时间间隔进行，例如每次构建之后。这些钩子\
是作为\ `v1查询文件`_\ 的一部分进行配置的。每当钩子被触发时，就会生成一个索引文件，\
其中包含自上次索引以来更新的片段文件列表。

也可以通过手动调用\ ``ctest --collect-instrumentation <build>``\ 来生成索引。

回调函数
---------

作为\ `v1查询文件`_\ 的一部分，用户可以提供一个回调函数列表，用于处理此功能收集的数据。

每当\ `索引`_\ 操作发生时，每个提供的回调函数都会被执行，并将生成的索引文件的路径作为参数传递。

这些回调函数可以在用户级别或项目级别定义，应该读取插桩数据并执行任何所需的处理。一旦所有回调\
函数执行完毕，CMake会自动删除索引文件及其列出的片段文件。请注意，回调函数绝不应手动移动或\
删除这些数据文件，因为其他回调函数可能还需要它们。

启用插桩功能
========================

插桩功能可以为单个CMake项目启用，也可以为用户配置和构建的所有CMake项目启用。有关这两种情况的\
详细配置信息，请参阅\ `v1查询文件`_。

在项目级别启用插桩功能
---------------------------------------------

项目代码可以使用\ :command:`cmake_instrumentation`\ 命令包含插桩查询。

此外，查询文件可以手动放置在构建树顶部的\ ``<build>/.cmake/instrumentation/<version>/query/``\
目录下。此版本的CMake仅支持一种版本模式，即\ `API v1`_。

在用户级别启用插桩功能
------------------------------------------

可以通过将查询文件放置在\ :envvar:`CMAKE_CONFIG_DIR`\ 下的\
``<config_dir>/instrumentation/<version>/query/``\ 目录中来在用户级别配置插桩功能。

为CDash提交启用插桩功能
----------------------------------------------

在以\ :ref:`Dashboard Client`\ 模式使用CTest时，可以通过将\ :envvar:`CTEST_USE_INSTRUMENTATION`\
环境变量设置为\ ``CMAKE_EXPERIMENTAL_INSTRUMENTATION``\ 功能的当前UUID来启用插桩功能。\
这样做会自动启用\ ``dynamicSystemInformation``\ 查询。

下表显示了每种插桩命令类型如何映射到相应类型的CTest XML文件。

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

默认情况下，报告给CDash的命令行在第一个空格处截断。你可以通过将\
:envvar:`CTEST_USE_VERBOSE_INSTRUMENTATION`\ 设置为1来选择报告完整的命令行（包括参数）。

.. _`cmake-instrumentation API v1`:

API v1
======

API版本指定了插桩数据的子目录布局和查询文件的格式。

插桩API v1位于\ ``instrumentation/v1/``\ 目录下，对于输出数据和项目级查询，该目录位于\
``<build>/.cmake/``\ 下；对于用户级查询，该目录位于\ ``<config_dir>/``\ 下。此目录中的\
``v1``\ 部分表示API版本。它有以下子目录：

``query/``
  存放用户或客户端编写的查询文件。任何扩展名为\ ``.json``\ 的文件都将被识别为查询文件。\
  这些文件由创建它们的客户端或用户拥有。

``query/generated/``
  存放由CMake项目使用\ :command:`cmake_instrumentation`\ 命令生成的查询文件。这些文件由\
  CMake\ 拥有，并在CMake配置步骤期间自动删除和重新生成。

``data/``
  存放项目上收集的插桩数据。CMake 拥有所有数据文件，其他进程绝不应删除它们。这里收集的数据会\
  一直保留，直到\ `索引`_\ 操作完成且所有\ `回调函数`_\ 执行完毕。

``cdash/``
  存放内部用于生成要提交给CDash的XML内容的临时文件。

.. _`cmake-instrumentation v1 Query Files`:

v1查询文件
--------------

``instrumentation/v1/query/``\ 目录下任何扩展名为\ ``.json``\ 的文件都被识别为插桩数据\
的查询文件。

这些文件必须包含一个具有以下键的JSON对象。\ ``version``\ 键是必需的，但所有其他字段都是可选的。

``version``
  要生成的片段文件的数据版本，一个整数。目前仅支持版本\ ``1``。

``callbacks``
  用于处理收集的插桩数据的\ `回调函数`_\ 的命令行字符串列表。每当执行这些回调时，\
  `v1索引文件`_\ 的完整路径将附加到字符串中包含的参数后面。

``hooks``
  一个字符串列表，指定\ `索引`_\ 应自动发生的时间。这些是应该整理插桩数据并调用用户\
  `回调函数`_\ 来处理数据的时间间隔。此列表中的元素应该是以下之一：

  * ``postGenerate``
  * ``preBuild`` (在调用\ ``ninja``\ 或\ ``make``\ 时调用；在Windows上不可用)
  * ``postBuild`` (在\ ``ninja``\ 或\ ``make``\ 完成时调用；在Windows上不可用)
  * ``preCMakeBuild`` (在调用\ ``cmake --build``\ 时调用)
  * ``postCMakeBuild`` (在\ ``cmake --build``\ 完成时调用)
  * ``postInstall``
  * ``postTest``

``queries``
  一个字符串列表，指定在插桩期间要收集的其他可选数据。此列表中的元素应该是以下之一：

    ``staticSystemInformation``
      启用收集运行CMake的主机的静态信息。此数据在\ `索引`_\ 期间收集，并包含在生成的\
      `v1索引文件`_\ 中。

    ``dynamicSystemInformation``
      启用收集运行CMake的主机的动态信息。为CMake生成的每个\ `v1片段文件`_\ 收集数据，\
      包括命令执行前后的信息。

列出的\ ``callbacks``\ *至少*\ 会在指定的钩子期间被调用。当有多个查询文件时，它们之间的\
``callbacks``、\ ``hooks``\ 和\ ``queries``\ 将被合并。因此，如果任何查询文件包含任何\
``hooks``，则所有查询文件中的每个\ ``callback``\ 都将在所有查询文件中的每个\ ``hook``\
处执行。此外，如果任何查询文件包含任何可选的\ ``queries``，则可选查询数据将出现在所有数据文件中。

示例：

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

在这个示例中，每次调用\ ``cmake --build``\ 或\ ``cmake --install``\ 后，会在\
``<build>/.cmake/instrumentation/v1/data``\ 中生成一个索引文件\ ``index-<timestamp>.json``，\
其中包含自上次索引以来创建的数据片段文件列表。命令\ ``/usr/bin/python callback.py index-<timestamp>.json``\
和\ ``/usr/bin/cmake -P callback.cmake arg index-<timestamp>.json``\ 将按此顺序执行。\
索引文件将包含\ ``staticSystemInformation``\ 数据，索引中列出的每个片段文件将包含\
``dynamicSystemInformation``\ 数据。一旦两个回调都完成，索引文件和它列出的所有片段文件将\
从项目构建树中删除。

.. _`cmake-instrumentation Data v1`:

Data v1
=======

数据版本指定了CMake插桩API作为\ `数据收集`_\ 和\ `索引`_\ 的一部分生成的输出文件的内容。\
生成两种类型的数据文件：\ `v1片段文件`_\ 和\ `v1索引文件`_。使用\ `API v1`_\
时，这些文件位于项目构建树下的\ ``<build>/.cmake/instrumentation/v1/data/``\ 中。

v1片段文件
---------------

片段文件会为CMake构建或安装步骤中调用的每个编译、链接和自定义命令生成，并包含有关执行命令的\
插桩数据。此外，还会为以下情况创建片段文件：

* CMake配置步骤
* CMake生成步骤
* 整个构建步骤（使用\ ``cmake --build``\ 执行）
* 整个安装步骤（使用\ ``cmake --install``\ 执行）
* 每次\ ``ctest``\ 调用
* ``ctest``\ 执行的每个单独测试。

这些文件会一直保留在构建树中，直到\ `索引`_\ 操作完成且任何用户指定的\ `回调函数`_\ 执行完毕。

片段文件的文件名语法为\ ``<role>-<hash>-<timestamp>.json``，并包含以下数据：

  ``version``
    片段文件的数据版本，一个整数。目前版本始终为\ ``1``。

  ``command``
    执行的完整命令。当\ ``role``\ 为\ ``build``\ 时排除。

  ``workingDir``
    The working directory in which the ``command`` was executed.

  ``result``
    命令的退出值，一个整数。

  ``role``
    执行的命令类型，将是以下值之一：

    * ``configure``：CMake配置步骤
    * ``generate``：CMake生成步骤
    * ``compile``：构建期间调用的单个编译步骤
    * ``link``：构建期间调用的单个链接步骤
    * ``custom``：构建期间调用的单个自定义命令
    * ``build``：完整的\ ``make``\ 或\ ``ninja``\ 调用。仅当启用\ ``preBuild``\ 或\
      ``postBuild``\ 钩子时生成。
    * ``cmakeBuild``：完整的\ ``cmake --build``\ 调用
    * ``cmakeInstall``：完整的\ ``cmake --install``\ 调用
    * ``install``：单个\ ``cmake -P cmake_install.cmake``\ 调用
    * ``ctest``：完整的\ ``ctest``\ 调用
    * ``test``：CTest执行的单个测试

  ``target``
    与命令关联的CMake目标。仅当\ ``role``\ 为\ ``compile``\ 或 ``link``\ 时包含。

  ``targetType``
    目标的\ :prop_tgt:`TYPE`。仅当\ ``role``\ 为\ ``link``\ 时包含。

  ``targetLabels``
    目标的\ :prop_tgt:`LABELS`。仅当\ ``role``\ 为\ ``link``\ 时包含。

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
    正在编译的源文件的语言。仅当\ ``role``\ 为\ ``compile``\ 时包含。

  ``testName``
    正在执行的测试的名称。仅当\ ``role``\ 为\ ``test``\ 时包含。

  ``config``
    构建类型，如\ ``Release``\ 或\ ``Debug``。仅当\ ``role``\ 为\ ``compile``、\
    ``link``\ 或\ ``test``\ 时包含。

  ``dynamicSystemInformation``
    指定收集的有关运行CMake的主机的动态信息。为CMake生成的每个片段文件收集数据，包括命令执行\
    前后的数据。仅当由\ `v1查询文件`_\ 启用时包含。

    ``beforeHostMemoryUsed``
      在\ ``timeStart``\ 时使用的主机内存，以KiB为单位。

    ``afterHostMemoryUsed``
      在\ ``timeStop``\ 时使用的主机内存，以KiB为单位。

    ``beforeCPULoadAverage``
      在\ ``timeStart``\ 时的平均CPU负载。

    ``afterCPULoadAverage``
      在\ ``timeStop``\ 时的平均CPU负载。

示例：

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

v1索引文件
-------------

索引文件包含一个\ `v1片段文件`_\ 列表。它作为导航插桩数据的入口点。每当\ `索引`_\ 操作发生\
时生成，并在任何用户指定的\ `回调函数`_\ 执行完毕后删除。

``version``
  索引文件的数据版本，一个整数。目前版本始终为\ ``1``。

``buildDir``
  CMake项目的构建目录。

``dataDir``
  ``<build>/.cmake/instrumentation/v1/data/``\ 目录的完整路径。

``hook``
  负责生成索引文件的钩子名称。除了可以由\ `v1查询文件`_\ 指定的钩子之外，如果通过调用\
  ``ctest --collect-instrumentation <build>``\ 执行索引，此值可能设置为\ ``manual``。

``snippets``
  包含一个\ `v1片段文件`_\ 列表。这包括自上一个索引文件创建以来生成的所有片段文件。文件路径\
  相对于\ ``dataDir``。

``staticSystemInformation``
  指定收集的有关运行CMake的主机的静态信息。仅当由\ `v1查询文件`_\ 启用时包含。

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

示例：

.. code-block:: json

  {
    "version": 1,
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
    ]
  }
