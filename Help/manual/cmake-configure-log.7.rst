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

对于人类使用，这个版本的CMake将配置日志写入文件::

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
