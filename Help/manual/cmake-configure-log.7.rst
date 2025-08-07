.. cmake-manual-description: CMake Configure Log

cmake-configure-log(7)
**********************

.. versionadded:: 3.26

.. only:: html

   .. contents::

介绍
============

CMake写一个运行日志，称为\ *configure log*，记录在配置步骤中发生的某些事件。配置日志\ *不*\
包含配置项目时打印的所有输出、错误或消息的日志。它是关于特定事件的详细信息的日志，例如由\
:command:`try_compile`\ 进行的工具链检查，用于调试构建树的配置。

对于人类使用，这个版本的CMake将配置日志写入文件：

.. code-block:: cmake

  ${CMAKE_BINARY_DIR}/CMakeFiles/CMakeConfigureLog.yaml

但是，在CMake的未来版本中，\ *日志文件的位置和名称可能会改变*。读取配置日志的工具应该使用对\
:manual:`cmake-file-api(7)`\ 的\ :ref:`configureLog <file-api configureLog>`\
查询来获取它的位置。有关详细信息，请参阅下面的\ `日志版本`_\ 控制部分。

日志结构
=============

配置日志被设计为机器可读和人类可读。

日志文件是一个YAML文档流，包含零个或多个用文档标记分隔的YAML文档。每个文档都以\ ``---``\
文档标记行开始，包含单个YAML映射，用于记录来自一个CMake “配置”步骤的事件，如果配置步\
骤正常完成，则以\ ``...``\ 文件标记线结束：

.. code-block:: yaml

  ---
  events:
    -
      kind: "try_compile-v1"
      # (other fields omitted)
    -
      kind: "try_compile-v1"
      # (other fields omitted)
  ...

每当CMake配置构建树并记录新事件时，都会将一个新文档追加到日志中。

每个文档根映射的键是：

``events``
  一个节点的YAML块序列，对应于在一个CMake“配置”步骤中记录的事件。每个事件都是一个YAML节点，\
  包含下面记录的\ `事件类型`_\ 之一。

日志版本
--------------

每种\ `事件类型`_\ 的版本都是独立的。事件的日志条目提供的键集特定于它的主版本。当一个事\
件被记录时，CMake运行版本所知道的事件类型的最新版本总是被写入日志。

读取配置日志的工具必须忽略它们不理解的事件类型和版本：

* CMake的未来版本可能会引入新的事件类型或版本。

* 如果使用不同版本的CMake重新配置现有的构建树，日志可能包含相同事件类型的不同版本。

* 如果\ :manual:`cmake-file-api(7)`\ 查询请求一个或多个\
  :ref:`configureLog <file-api configureLog>`\ 对象版本，日志可能包含同一事件的多个条\
  目，每个条目具有其事件类型的不同版本。

IDE应该在运行CMake之前写一个\ :manual:`cmake-file-api(7)`\ 查询请求一个特定的\
:ref:`configureLog <file-api configureLog>`\ 对象版本，然后只按照file-api回复的描述\
读取配置日志。

文本块编码
-------------------

为了使日志易于人类阅读，文本块总是使用YAML文字块标量（\ ``|``）表示。由于文字块标量不支持转义，\
反斜杠和不可打印字符在应用层编码：

* ``\\``\ 编码一个反斜杠。
* ``\xXX``\ 用两个十六进制数字\ ``XX``\ 编码一个字节。

.. _`configure-log event kinds`:

事件类型
===========

每个事件类型都由以下形式的YAML映射表示：

.. code-block:: yaml

  kind: "<kind>-v<major>"
  backtrace:
    - "<file>:<line> (<function>)"
  checks:
    - "Checking for something"
  #...event-specific keys...

所有事件的共同键是：

``kind``
  标识事件类型和主要版本的字符串。

``backtrace``
  一个YAML块序列，报告事件发生的CMake源位置的调用堆栈，从最近的到最近的。每个节点都是指定一\
  个位置的字符串，格式为\ ``<file>:<line> (<function>)``。

``checks``
  一个可选的键，当事件发生时，至少有一个挂起的\ :command:`message(CHECK_START)`\ 出现。\
  它的值是一个YAML块序列，报告挂起检查的堆栈，从最近的到最近的。每个节点是一个字符串，包含一\
  个挂起的检查消息。

其他映射键特定于每个（版本化的）事件类型，如下所述。

.. _`message configure-log event`:

事件类型\ ``message``
----------------------

:command:`message(CONFIGURE_LOG)`\ 命令记录\ ``message``\ 事件。

只有一个\ ``message``\ 事件主版本，即版本1。

.. _`message-v1 event`:

``message-v1``\ 事件
^^^^^^^^^^^^^^^^^^^^

``message-v1``\ 事件是一个YAML映射：

.. code-block:: yaml

  kind: "message-v1"
  backtrace:
    - "CMakeLists.txt:123 (message)"
  checks:
    - "Checking for something"
  message: |
    # ...

特定于\ ``message-v1``\ 映射的键是：

``message``
  包含消息文本的YAML文字块标量，使用\ `文本块编码`_\ 表示。

.. _`try_compile configure-log event`:

事件类型\ ``try_compile``
--------------------------

:command:`try_compile`\ 命令记录\ ``try_compile``\ 事件。

只有一个\ ``try_compile``\ 事件主版本，即版本1。

.. _`try_compile-v1 event`:

``try_compile-v1``\ 事件
^^^^^^^^^^^^^^^^^^^^^^^^

``try_compile-v1``\ 事件是一个YAML映射：

.. code-block:: yaml

  kind: "try_compile-v1"
  backtrace:
    - "CMakeLists.txt:123 (try_compile)"
  checks:
    - "Checking for something"
  description: "Explicit LOG_DESCRIPTION"
  directories:
    source: "/path/to/.../TryCompile-01234"
    binary: "/path/to/.../TryCompile-01234"
  cmakeVariables:
    SOME_VARIABLE: "Some Value"
  buildResult:
    variable: "COMPILE_RESULT"
    cached: true
    stdout: |
      # ...
    exitCode: 0

特定于\ ``try_compile-v1``\ 映射的键是：

``description``
  当使用\ ``LOG_DESCRIPTION <text>``\ 选项时出现的可选键。它的值是一个字符串，\
  包含描述\ ``<text>``。

``directories``
  描述与编译尝试相关联的目录的映射。它有以下几个键：

  ``source``
    指定\ :command:`try_compile`\ 项目的源目录的字符串。

  ``binary``
    指定\ :command:`try_compile`\ 项目的二进制目录的字符串。对于非项目调用，这通常与源目录相同。

``cmakeVariables``
  当CMake自动或由于\ :variable:`CMAKE_TRY_COMPILE_PLATFORM_VARIABLES`\ 变量将变量\
  传播到测试项目时出现的可选键。它的值是从变量名到它们的值的映射。

``buildResult``
  描述编译测试代码的结果的映射。它有以下几个键：

  ``variable``
    一个字符串，指定CMake变量的名称，该变量存储尝试构建测试项目的结果。

  ``cached``
    一个布尔值，指示上述结果\ ``variable``\ 是否存储在CMake缓存中。

  ``stdout``
    一个YAML文字块标量，包含构建测试项目的输出，使用我们的\ `文本块编码`_\ 表示。它包含来\
    自标准输出和标准错误的构建输出。

  ``exitCode``
    一个整数，指定尝试构建测试项目时的构建工具退出代码。

.. _`try_run configure-log event`:

事件类型\ ``try_run``
----------------------

``try_run``\ 命令记录\ :command:`try_run`\ 事件。

只有一个\ ``try_run``\ 事件主版本，即版本1。

.. _`try_run-v1 event`:

``try_run-v1``\ 事件
^^^^^^^^^^^^^^^^^^^^

``try_run-v1``\ 事件是一个YAML映射：

.. code-block:: yaml

  kind: "try_run-v1"
  backtrace:
    - "CMakeLists.txt:456 (try_run)"
  checks:
    - "Checking for something"
  description: "Explicit LOG_DESCRIPTION"
  directories:
    source: "/path/to/.../TryCompile-56789"
    binary: "/path/to/.../TryCompile-56789"
  buildResult:
    variable: "COMPILE_RESULT"
    cached: true
    stdout: |
      # ...
    exitCode: 0
  runResult:
    variable: "RUN_RESULT"
    cached: true
    stdout: |
      # ...
    stderr: |
      # ...
    exitCode: 0

特定于\ ``try_run-v1``\ 映射的键包括\ `try_compile-v1事件 <try_compile-v1 event>`_\
记录的键，加上：

``runResult``
  描述运行测试代码的结果的映射。它有以下几个键：

  ``variable``
    一个字符串，指定CMake变量的名称，该变量存储尝试运行测试可执行文件的结果。

  ``cached``
    一个布尔值，指示上述结果\ ``variable``\ 是否存储在CMake缓存中。

  ``stdout``
    成功构建测试项目时出现的可选键。它的值是一个YAML文字块标量，包含运行测试可执行文件的输出，\
    使用我们的\ `文本块编码`_\ 表示。

    如果使用了\ ``RUN_OUTPUT_VARIABLE``，则标准输出和标准错误将被一起捕获，因此这将包含两者。\
    否则，这将只包含标准输出输出。

  ``stderr``
    当测试项目成功构建并且未使用\ ``RUN_OUTPUT_VARIABLE``\ 选项时出现的可选键。它的值是\
    一个YAML文字块标量，包含运行测试可执行文件的输出，使用我们的\ `文本块编码`_\ 表示。

    如果使用\ ``RUN_OUTPUT_VARIABLE``，则在\ ``stdout``\ 键中同时捕获标准输出和标准错误，\
    并且该键将不存在。否则，这将包含标准错误。

  ``exitCode``
    成功构建测试项目时出现的可选键。它的值是一个整数，指定试图运行测试可执行文件时的退出代码，\
    或者包含错误消息的字符串。

.. _`find configure-log event`:

事件类型\ ``find``
-------------------

:command:`find_file`、\ :command:`find_path`、\ :command:`find_library`\ 和\
:command:`find_program`\ 命令会记录\ ``find``\ 事件。

``find``\ 事件仅有一个主版本，即版本1。

.. _`find-v1 event`:

``find-v1``\ 事件
^^^^^^^^^^^^^^^^^

.. versionadded:: 4.1

一个\ ``find-v1``\ 事件是一个YAML映射：

.. code-block:: yaml

  kind: "find-v1"
  backtrace:
    - "CMakeLists.txt:456 (find_program)"
  mode: "program"
  variable: "PROGRAM_PATH"
  description: "Docstring for variable"
  settings:
    SearchFramework: "NEVER"
    SearchAppBundle: "NEVER"
    CMAKE_FIND_USE_CMAKE_PATH: true
    CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH: true
    CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH: true
    CMAKE_FIND_USE_CMAKE_SYSTEM_PATH: true
    CMAKE_FIND_USE_INSTALL_PREFIX: true
  names:
    - "name1"
    - "name2"
  candidate_directories:
    - "/path/to/search"
    - "/other/path/to/search"
    - "/path/to/found"
    - "/further/path/to/search"
  searched_directories:
    - "/path/to/search"
    - "/other/path/to/search"
  found: "/path/to/found/program"

特定于\ ``find-v1``\ 映射的键如下：

``mode``
  一个字符串，用于描述执行搜索操作所使用的命令。\
  取值为\ ``file``、\ ``path``、\ ``program``\ 或\ ``library``\ 之一。

``variable``
  搜索结果所存储到的变量。

``description``
  该变量的文档字符串。

``settings``
  搜索时启用的搜索设置。

  ``SearchFramework``
    一个描述如何执行框架搜索的字符串。取值为\ ``FIRST``、\ ``LAST``、\ ``ONLY``\
    或\ ``NEVER``\ 之一。请参阅\ :variable:`CMAKE_FIND_FRAMEWORK`\ 变量。

  ``SearchAppBundle``
    一个描述如何执行应用程序捆绑包搜索的字符串。取值为\ ``FIRST``、\ ``LAST``、\
    ``ONLY``\ 或\ ``NEVER``\ 之一。请参阅\ :variable:`CMAKE_FIND_APPBUNDLE`\ 变量。

  ``CMAKE_FIND_USE_CMAKE_PATH``
    一个布尔值，指示在搜索时是否使用CMake特定的缓存变量。\
    请参阅\ :variable:`CMAKE_FIND_USE_CMAKE_PATH`\ 变量。

  ``CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH``
    一个布尔值，指示在搜索时是否使用CMake特定的环境变量。\
    请参阅\ :variable:`CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH`\ 变量。

  ``CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH``
    一个布尔值，指示在搜索时是否使用特定于平台的环境变量。\
    请参阅\ :variable:`CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH`\ 变量。

  ``CMAKE_FIND_USE_CMAKE_SYSTEM_PATH``
    一个布尔值，指示在搜索时是否使用特定于平台的CMake变量。\
    请参阅\ :variable:`CMAKE_FIND_USE_CMAKE_SYSTEM_PATH`\ 变量

  ``CMAKE_FIND_USE_INSTALL_PREFIX``
    一个布尔值，指示在搜索时是否使用安装前缀。\
    请参阅\ :variable:`CMAKE_FIND_USE_INSTALL_PREFIX`\ 变量。

``names``
  用于查询的名称。

``candidate_directories``
  搜索过程中按顺序要查找的候选目录。

``searched_directories``
  搜索过程中按顺序查看的目录。

``found``
  可以是一个表示找到的值的字符串，若未找到则为\ ``false``。

``search_context``
  将变量名映射到由这些变量指定的搜索路径（根据变量的不同，搜索路径可以是一个字符串，\
  也可以是一个字符串数组）。环境变量会用\ ``ENV{``\ 和\ ``}``\ 包裹起来，否则将\
  使用CMake变量。仅使用指定了任意路径的变量。

  ``package_stack``
    一个对象数组，这些对象包含的路径来自于由\ :command:`find_package`\ 调用所提供的路径栈。

    ``package_paths``
      调用栈中由\ :command:`find_package`\ 命令提供的路径。

.. _`find_package configure-log event`:

事件类型\ ``find_package``
---------------------------

.. versionadded:: 4.1

:command:`find_package`\ 命令会记录\ ``find_package``\ 事件。

``find_package``\ 事件仅有一个主版本，即版本1。

.. _`find_package-v1 event`:

``find_package-v1``\ 事件
^^^^^^^^^^^^^^^^^^^^^^^^^

一个\ ``find_package-v1``\ 事件是一个YAML映射：

.. code-block:: yaml

  kind: "find_package-v1"
  backtrace:
    - "CMakeLists.txt:456 (find_program)"
  name: "PackageName"
  components:
    -
      name: "Component"
      required: true
      found: true
  configs:
    -
      filename: PackageNameConfig.cmake
      kind: "cmake"
    -
      filename: packagename-config.cmake
      kind: "cmake"
  version_request:
    version: "1.0"
    version_complete: "1.0...1.5"
    min: "INCLUDE"
    max: "INCLUDE"
    exact: false
  settings:
    required: "optional"
    quiet: false
    global: false
    policy_scope: true
    bypass_provider: false
    hints:
      - "/hint/path"
    names:
      - "name1"
      - "name2"
    search_paths:
      - "/search/path"
    path_suffixes:
      - ""
      - "suffix"
    registry_view: "HOST"
    paths:
      CMAKE_FIND_USE_CMAKE_PATH: true
      CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH: true
      CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH: true
      CMAKE_FIND_USE_CMAKE_SYSTEM_PATH: true
      CMAKE_FIND_USE_INSTALL_PREFIX: true
      CMAKE_FIND_USE_PACKAGE_ROOT_PATH: true
      CMAKE_FIND_USE_CMAKE_PACKAGE_REGISTRY: true
      CMAKE_FIND_USE_SYSTEM_PACKAGE_REGISTRY: true
      CMAKE_FIND_ROOT_PATH_MODE: "BOTH"
    candidates:
      -
        path: "/path/to/config/PackageName/PackageNameConfig.cmake"
        mode: "config"
        reason: "insufficient_version"
      -
        path: "/path/to/config/PackageName/packagename-config.cmake"
        mode: "config"
        reason: "no_exist"
    found:
      path: "/path/to/config/PackageName-2.5/PackageNameConfig.cmake"
      mode: "config"
      version: "2.5"

特定于\ ``find_package-v1``\ 映射的键如下：

``name``
  请求包名称。

``components``
  若存在，这是一个对象数组，包含以下字段：

  ``name``
    组件的名称。

  ``required``
    一个布尔值，指示该组件是必需的还是可选的。

  ``found``
    一个布尔值，指示该组件是否被找到。

``configs``
  若存在，这是一个对象数组，指示要搜索的配置文件。

  ``filename``
    配置文件的文件名。

  ``kind``
    文件类型。可以是\ ``cmake``\ 或\ ``cps``。

``version_request``
  一个对象，指示搜索的版本约束。

  ``version``
    所需的最低版本。

  ``version_complete``
    用户提供的版本范围。

  ``min``
    是否在版本范围中\ ``包含``\ 或\ ``排除``\ 下限。

  ``max``
    是否在版本范围中\ ``包含``\ 或\ ``排除``\ 上限。

  ``exact``
    一个布尔值，指示是否请求了\ ``精确的``\ 版本匹配。

``settings``
  搜索设置对当前搜索有效。

  ``required``
    搜索的需求请求。可选值之一：\ ``optional``、\ ``optional_explicit``、\
    ``required_explicit``、\ ``required_from_package_variable``\ 或\
    ``required_from_find_variable``。

  ``quiet``
    一个布尔值，指示搜索是否为\ ``QUIET``。

  ``global``
    一个布尔值，指示是否提供了\ ``GLOBAL``\ 关键字。

  ``policy_scope``
    一个布尔值，指示是否提供了\ ``NO_POLICY_SCOPE``\ 关键字。

  ``bypass_provider``
    一个布尔值，指示是否提供了\ ``BYPASS_PROVIDER``\ 关键字。

  ``hints``
    作为\ ``HINTS``\ 提供的路径数组。

  ``names``
    搜索时使用的、由\ ``NAMES``\ 提供的包名数组。

  ``search_paths``
    由\ ``PATHS``\ 提供的待搜索路径数组。

  ``path_suffixes``
    由\ ``PATH_SUFFIXES``\ 提供的搜索时使用的后缀数组。

  ``registry_view``
    搜索请求的\ ``REGISTRY_VIEW``。

  ``paths``
    搜索时启用的路径设置。

    ``CMAKE_FIND_USE_CMAKE_PATH``
      一个布尔值，指示在搜索时是否使用CMake特定的缓存变量。\
      请参阅\ :variable:`CMAKE_FIND_USE_CMAKE_PATH`\ 变量。

    ``CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH``
      一个布尔值，指示在搜索时是否使用CMake特定的环境变量。\
      请参阅\ :variable:`CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH`\ 变量。

    ``CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH``
      一个布尔值，指示在搜索时是否使用特定于平台的环境变量。\
      请参阅\ :variable:`CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH`\ 变量。

    ``CMAKE_FIND_USE_CMAKE_SYSTEM_PATH``
      一个布尔值，指示在搜索时是否使用特定于平台的CMake变量。\
      请参阅\ :variable:`CMAKE_FIND_USE_CMAKE_SYSTEM_PATH`\ 变量。

    ``CMAKE_FIND_USE_INSTALL_PREFIX``
      一个布尔值，指示在搜索时是否使用安装前缀。\
      请参阅\ :variable:`CMAKE_FIND_USE_INSTALL_PREFIX`\ 变量。

    ``CMAKE_FIND_USE_CMAKE_PACKAGE_REGISTRY``
      一个布尔值，指示是否在CMake包注册表中搜索该软件包。\
      请参阅\ :variable:`CMAKE_FIND_USE_PACKAGE_REGISTRY`\ 变量。

    ``CMAKE_FIND_USE_SYSTEM_PACKAGE_REGISTRY``
      一个布尔值，指示是否在系统CMake包注册表中搜索该软件包。\
      请参阅\ :variable:`CMAKE_FIND_USE_SYSTEM_PACKAGE_REGISTRY`\ 变量。

    ``CMAKE_FIND_ROOT_PATH_MODE``
      一个字符串，用于指示由\ ``CMAKE_FIND_ROOT_PATH_BOTH``、\ ``ONLY_CMAKE_FIND_ROOT_PATH``\
      和\ ``NO_CMAKE_FIND_ROOT_PATH``\ 参数所选定的生效根路径模式。

``candidates``
  一个被拒绝的候选路径数组。每个元素包含以下键：

  ``path``
    待考量文件的路径。若涉及依赖提供方，该值的格式为\ ``dependency_provider::<COMMAND_NAME>``。

  ``mode``
    找到该文件的模式。取值为\ ``module``、\ ``cps``、\ ``cmake``\ 或\ ``provider``\ 之一。

  ``reason``
    该路径被拒绝的原因。取值为\ ``insufficient_version``、\ ``no_exist``、\
    ``ignored``、\ ``no_config_file``\ 或\ ``not_found``\ 之一。

  ``message``
    如果存在，该字符串描述了为何认为该软件包未被找到。

``found``
  如果找到了软件包，则包含已找到文件的信息。如果未找到，则为\ ``null``。可用的键：

  ``path``
    找到该软件包模块或配置文件的路径。在依赖提供器的情况下，该值的格式为\
    ``dependency_provider::<COMMAND_NAME>``。

  ``mode``
    考量该路径时所采用的模式。取值为\ ``module``、\ ``cps``、\ ``cmake``\ 或\
    ``provider``\ 之一。

  ``version``
    所报告的软件包版本。

``search_context``
  将变量名映射到由这些变量指定的搜索路径（根据变量的不同，搜索路径可以是一个字符串，\
  也可以是一个字符串数组）。环境变量会用\ ``ENV{``\ 和\ ``}``\ 包裹起来，\
  否则将使用CMake变量。仅使用指定了任意路径的变量。

  ``package_stack``
    一个对象数组，这些对象包含的路径来自于由\ :command:`find_package`\ 调用所提供的路径栈。

    ``package_paths``
      调用栈中由\ :command:`find_package`\ 命令提供的路径。
