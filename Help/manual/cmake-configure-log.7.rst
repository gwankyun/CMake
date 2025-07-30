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
  A mapping of variable names to search paths specified by them (either a
  string or an array of strings depending on the variable). Environment
  variables are wrapped with ``ENV{`` and ``}``, otherwise CMake variables are
  used. Only variables with any paths specified are used.

  ``package_stack``
    An array of objects with paths which come from the stack of paths made
    available by :command:`find_package` calls.

    ``package_paths``
      The paths made available by :command:`find_package` commands in the call
      stack.

.. _`find_package configure-log event`:

Event Kind ``find_package``
---------------------------

.. versionadded:: 4.1

The :command:`find_package` command logs ``find_package`` events.

There is only one ``find_package`` event major version, version 1.

.. _`find_package-v1 event`:

``find_package-v1`` Event
^^^^^^^^^^^^^^^^^^^^^^^^^

A ``find_package-v1`` event is a YAML mapping:

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

The keys specific to ``find_package-v1`` mappings are:

``name``
  The name of the requested package.

``components``
  If present, an array of objects containing the fields:

  ``name``
    The name of the component.

  ``required``
    A boolean indicating whether the component is required or optional.

  ``found``
    A boolean indicating whether the component was found or not.

``configs``
  If present, an array of objects indicating the configuration files to search
  for.

  ``filename``
    The filename of the configuration file.

  ``kind``
    The kind of file. Either ``cmake`` or ``cps``.

``version_request``
  An object indicating the version constraints on the search.

  ``version``
    The minimum version required.

  ``version_complete``
    The user-provided version range.

  ``min``
    Whether to ``INCLUDE`` or ``EXCLUDE`` the lower bound on the version
    range.

  ``max``
    Whether to ``INCLUDE`` or ``EXCLUDE`` the upper bound on the version
    range.

  ``exact``
    A boolean indicating whether an ``EXACT`` version match was requested.

``settings``
  Search settings active for the search.

  ``required``
    The requirement request of the search. One of ``optional``,
    ``optional_explicit``, ``required_explicit``,
    ``required_from_package_variable``, or ``required_from_find_variable``.

  ``quiet``
    A boolean indicating whether the search is ``QUIET`` or not.

  ``global``
    A boolean indicating whether the ``GLOBAL`` keyword has been provided or
    not.

  ``policy_scope``
    A boolean indicating whether the ``NO_POLICY_SCOPE`` keyword has been
    provided or not.

  ``bypass_provider``
    A boolean indicating whether the ``BYPASS_PROVIDER`` keyword has been
    provided or not.

  ``hints``
    An array of paths provided as ``HINTS``.

  ``names``
    An array of package names to use when searching, provided by ``NAMES``.

  ``search_paths``
    An array of paths to search, provided by ``PATHS``.

  ``path_suffixes``
    An array of suffixes to use when searching, provided by ``PATH_SUFFIXES``.

  ``registry_view``
    The ``REGISTRY_VIEW`` requested for the search.

  ``paths``
    Path settings active for the search.

    ``CMAKE_FIND_USE_CMAKE_PATH``
      A boolean indicating whether or not CMake-specific cache variables are
      used when searching. See :variable:`CMAKE_FIND_USE_CMAKE_PATH`.

    ``CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH``
      A boolean indicating whether or not CMake-specific environment variables
      are used when searching. See
      :variable:`CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH`.

    ``CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH``
      A boolean indicating whether or not platform-specific environment
      variables are used when searching. See
      :variable:`CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH`.

    ``CMAKE_FIND_USE_CMAKE_SYSTEM_PATH``
      A boolean indicating whether or not platform-specific CMake variables are
      used when searching. See :variable:`CMAKE_FIND_USE_CMAKE_SYSTEM_PATH`.

    ``CMAKE_FIND_USE_INSTALL_PREFIX``
      A boolean indicating whether or not the install prefix is used when
      searching. See :variable:`CMAKE_FIND_USE_INSTALL_PREFIX`.

    ``CMAKE_FIND_USE_CMAKE_PACKAGE_REGISTRY``
      A boolean indicating whether or not to search the CMake package registry
      for the package. See :variable:`CMAKE_FIND_USE_PACKAGE_REGISTRY`.

    ``CMAKE_FIND_USE_SYSTEM_PACKAGE_REGISTRY``
      A boolean indicating whether or not to search the system CMake package
      registry for the package. See
      :variable:`CMAKE_FIND_USE_SYSTEM_PACKAGE_REGISTRY`.

    ``CMAKE_FIND_ROOT_PATH_MODE``
      A string indicating the root path mode in effect as selected by the
      ``CMAKE_FIND_ROOT_PATH_BOTH``, ``ONLY_CMAKE_FIND_ROOT_PATH``, and
      ``NO_CMAKE_FIND_ROOT_PATH`` arguments.

``candidates``
  An array of rejected candidate paths. Each element contains the following
  keys:

  ``path``
    The path to the considered file. In the case of a dependency provider, the
    value is in the form of ``dependency_provider::<COMMAND_NAME>``.

  ``mode``
    The mode which found the file. One of ``module``, ``cps``, ``cmake``, or
    ``provider``.

  ``reason``
    The reason the path was rejected. One of ``insufficient_version``,
    ``no_exist``, ``ignored``, ``no_config_file``, or ``not_found``.

  ``message``
    If present, a string describing why the package is considered as not
    found.

``found``
  If the package has been found, information on the found file. If it is not
  found, this is ``null``. Keys available:

  ``path``
    The path to the module or configuration that found the package. In the
    case of a dependency provider, the value is in the form of
    ``dependency_provider::<COMMAND_NAME>``.

  ``mode``
    The mode that considered the path. One of ``module``, ``cps``, ``cmake``,
    or ``provider``.

  ``version``
    The reported version of the package.

``search_context``
  A mapping of variable names to search paths specified by them (either a
  string or an array of strings depending on the variable). Environment
  variables are wrapped with ``ENV{`` and ``}``, otherwise CMake variables are
  used. Only variables with any paths specified are used.

  ``package_stack``
    An array of objects with paths which come from the stack of paths made
    available by :command:`find_package` calls.

    ``package_paths``
      The paths made available by :command:`find_package` commands in the call
      stack.
