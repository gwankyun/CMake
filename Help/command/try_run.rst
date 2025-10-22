try_run
-------

.. only:: html

   .. contents::

尝试编译并运行一些代码。

尝试编译并运行源文件
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: cmake

  try_run(<runResultVar> <compileResultVar>
          [SOURCES_TYPE <type>]
          <SOURCES <srcfile...>                 |
           SOURCE_FROM_CONTENT <name> <content> |
           SOURCE_FROM_VAR <name> <var>         |
           SOURCE_FROM_FILE <name> <path>       >...
          [LOG_DESCRIPTION <text>]
          [NO_CACHE]
          [NO_LOG]
          [CMAKE_FLAGS <flags>...]
          [COMPILE_DEFINITIONS <defs>...]
          [LINK_OPTIONS <options>...]
          [LINK_LIBRARIES <libs>...]
          [COMPILE_OUTPUT_VARIABLE <var>]
          [COPY_FILE <fileName> [COPY_FILE_ERROR <var>]]
          [<LANG>_STANDARD <std>]
          [<LANG>_STANDARD_REQUIRED <bool>]
          [<LANG>_EXTENSIONS <bool>]
          [RUN_OUTPUT_VARIABLE <var>]
          [RUN_OUTPUT_STDOUT_VARIABLE <var>]
          [RUN_OUTPUT_STDERR_VARIABLE <var>]
          [WORKING_DIRECTORY <var>]
          [ARGS <args>...]
          )

.. versionadded:: 3.25

尝试从一个或多个源文件构建可执行文件。\
构建成功时，会在\ ``<compileResultVar>``\ 中返回布尔值\ ``true``；构建失败时，\
则返回布尔值\ ``false``\ （该变量会被缓存，除非指定了\ ``NO_CACHE``\ 选项）。\
如果构建成功，该命令将运行可执行文件，并将退出代码存储在\ ``<runResultVar>``\ 中\
（该变量会被缓存，除非指定了\ ``NO_CACHE``\ 选项）。\
如果可执行文件构建成功，但运行失败，那么\ ``<runResultVar>``\ 将被设置为\ ``FAILED_TO_RUN``。\
有关这两个命令的通用选项文档，以及测试项目如何构建源文件的相关信息，请参阅\
:command:`try_compile`\ 命令。

必须提供一个或多个源文件。此外，\ ``SOURCES``\ 和/或\ ``SOURCE_FROM_*``\ 其中之一\
必须位于其他关键字之前。

.. versionadded:: 3.26
  如果未指定\ ``NO_LOG``\ 选项，此命令将记录一个\
  :ref:`配置日志try_run事件 <try_run configure-log event>`。

此命令支持CMake 3.25版本之前的另一种签名形式。\
为保证清晰性，建议使用上述签名形式。

.. code-block:: cmake

  try_run(<runResultVar> <compileResultVar>
          <bindir> <srcfile|SOURCES srcfile...>
          [CMAKE_FLAGS <flags>...]
          [COMPILE_DEFINITIONS <defs>...]
          [LINK_OPTIONS <options>...]
          [LINK_LIBRARIES <libs>...]
          [LINKER_LANGUAGE <lang>]
          [COMPILE_OUTPUT_VARIABLE <var>]
          [COPY_FILE <fileName> [COPY_FILE_ERROR <var>]]
          [<LANG>_STANDARD <std>]
          [<LANG>_STANDARD_REQUIRED <bool>]
          [<LANG>_EXTENSIONS <bool>]
          [RUN_OUTPUT_VARIABLE <var>]
          [OUTPUT_VARIABLE <var>]
          [WORKING_DIRECTORY <var>]
          [ARGS <args>...]
          )

.. _`try_run Options`:

选项
^^^^^^^

``try_run``\ 特有的选项如下：

``COMPILE_OUTPUT_VARIABLE <var>``
  将编译步骤的构建输出记录到指定变量中。

``OUTPUT_VARIABLE <var>``
  将编译构建输出以及可执行文件运行时的输出记录到指定变量中。\
  此选项因遗留原因而存在，且仅受旧版\ ``try_run``\ 签名支持。\
  建议使用\ ``COMPILE_OUTPUT_VARIABLE``\ 和\ ``RUN_OUTPUT_VARIABLE``\ 替代。

``RUN_OUTPUT_VARIABLE <var>``
  将可执行文件运行时的输出记录到指定变量中。

``RUN_OUTPUT_STDOUT_VARIABLE <var>``
  .. versionadded:: 3.25

  将可执行文件运行时的标准输出记录到指定变量中。

``RUN_OUTPUT_STDERR_VARIABLE <var>``
  .. versionadded:: 3.25

  将可执行文件运行时的标准错误输出记录到指定变量中。

``WORKING_DIRECTORY <var>``
  .. versionadded:: 3.20

  在指定目录中运行可执行文件。如果未指定\ ``WORKING_DIRECTORY``，可执行文件将在\
  ``<bindir>``\ 或当前构建目录中运行。

``ARGS <args>...``
  运行可执行文件时要传递给它的额外参数。

其他行为设置
^^^^^^^^^^^^^^^^^^^^^^^

设置变量\ :variable:`CMAKE_TRY_COMPILE_CONFIGURATION`\ 以选择构建配置：

* 对于多配置生成器，这将选择要构建的配置。

* 对于单配置生成器，这会在测试项目中设置\ :variable:`CMAKE_BUILD_TYPE`。

交叉编译时的行为
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. versionadded:: 3.3
  运行交叉编译的二进制文件时，请使用\ ``CMAKE_CROSSCOMPILING_EMULATOR``。

在交叉编译时，第一步编译出的可执行文件通常无法在构建主机上运行。\
``try_run``\ 命令会检查\ :variable:`CMAKE_CROSSCOMPILING`\ 变量，以判断CMake是否\
处于交叉编译模式。\
如果处于交叉编译模式，这命令仍会尝试编译可执行文件，但除非设置了\
:variable:`CMAKE_CROSSCOMPILING_EMULATOR`\ 变量，否则不会尝试运行该可执行文件。\
相反，它会创建缓存变量，这些变量必须由用户填充，或者通过在某些CMake脚本文件中预先\
设置，使其值等同于可执行文件在实际目标平台上运行时所产生的值。\
这些缓存项如下：

``<runResultVar>``
  可执行文件在目标平台上运行时的退出代码。

``<runResultVar>__TRYRUN_OUTPUT``
  可执行文件在目标平台上运行时的标准输出和标准错误输出。\
  仅当使用了\ ``RUN_OUTPUT_VARIABLE``\ 或\ ``OUTPUT_VARIABLE``\ 选项时，才会创建此项。

``<runResultVar>__TRYRUN_OUTPUT_STDOUT``
  .. versionadded:: 3.25

  Output from stdout if the executable were to be run on the target
  platform.  This is created only if the ``RUN_OUTPUT_STDOUT_VARIABLE``
  or ``RUN_OUTPUT_STDERR_VARIABLE`` option was used.

``<runResultVar>__TRYRUN_OUTPUT_STDERR``
  .. versionadded:: 3.25

  Output from stderr if the executable were to be run on the target
  platform.  This is created only if the ``RUN_OUTPUT_STDOUT_VARIABLE``
  or ``RUN_OUTPUT_STDERR_VARIABLE`` option was used.

为了让项目的交叉编译过程更加简便，仅在确实必要时使用\ ``try_run``\ 命令。\
如果你使用\ ``try_run``\ 命令，仅在确实必要时使用\ ``RUN_OUTPUT_STDOUT_VARIABLE``、\
``RUN_OUTPUT_STDERR_VARIABLE``、\ ``RUN_OUTPUT_VARIABLE``\ 或\ ``OUTPUT_VARIABLE``\ 选项。\
使用这些选项意味着在进行交叉编译时，必须手动将缓存变量设置为可执行文件的输出。\
你也可以使用\ :command:`if`\ 代码块来 “保护” 对\ ``try_run``\ 的调用，检查\
:variable:`CMAKE_CROSSCOMPILING`\ 变量，并针对这种情况提供一个易于预设的替代方案
