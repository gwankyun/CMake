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
  Report the compile build output and the output from running the executable
  in the given variable.  This option exists for legacy reasons and is only
  supported by the old ``try_run`` signature.
  Prefer ``COMPILE_OUTPUT_VARIABLE`` and ``RUN_OUTPUT_VARIABLE`` instead.

``RUN_OUTPUT_VARIABLE <var>``
  Report the output from running the executable in a given variable.

``RUN_OUTPUT_STDOUT_VARIABLE <var>``
  .. versionadded:: 3.25

  Report the output of stdout from running the executable in a given variable.

``RUN_OUTPUT_STDERR_VARIABLE <var>``
  .. versionadded:: 3.25

  Report the output of stderr from running the executable in a given variable.

``WORKING_DIRECTORY <var>``
  .. versionadded:: 3.20

  Run the executable in the given directory. If no ``WORKING_DIRECTORY`` is
  specified, the executable will run in ``<bindir>`` or the current build
  directory.

``ARGS <args>...``
  Additional arguments to pass to the executable when running it.

Other Behavior Settings
^^^^^^^^^^^^^^^^^^^^^^^

Set variable :variable:`CMAKE_TRY_COMPILE_CONFIGURATION` to choose a build
configuration:

* For multi-config generators, this selects which configuration to build.

* For single-config generators, this sets :variable:`CMAKE_BUILD_TYPE` in
  the test project.

Behavior when Cross Compiling
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. versionadded:: 3.3
  Use ``CMAKE_CROSSCOMPILING_EMULATOR`` when running cross-compiled binaries.

When cross compiling, the executable compiled in the first step
usually cannot be run on the build host.  The ``try_run`` command checks
the :variable:`CMAKE_CROSSCOMPILING` variable to detect whether CMake is in
cross-compiling mode.  If that is the case, it will still try to compile
the executable, but it will not try to run the executable unless the
:variable:`CMAKE_CROSSCOMPILING_EMULATOR` variable is set.  Instead it
will create cache variables which must be filled by the user or by
presetting them in some CMake script file to the values the executable
would have produced if it had been run on its actual target platform.
These cache entries are:

``<runResultVar>``
  Exit code if the executable were to be run on the target platform.

``<runResultVar>__TRYRUN_OUTPUT``
  Output from stdout and stderr if the executable were to be run on
  the target platform.  This is created only if the
  ``RUN_OUTPUT_VARIABLE`` or ``OUTPUT_VARIABLE`` option was used.

In order to make cross compiling your project easier, use ``try_run``
only if really required.  If you use ``try_run``, use the
``RUN_OUTPUT_STDOUT_VARIABLE``, ``RUN_OUTPUT_STDERR_VARIABLE``,
``RUN_OUTPUT_VARIABLE`` or ``OUTPUT_VARIABLE`` options only if really
required.  Using them will require that when cross-compiling, the cache
variables will have to be set manually to the output of the executable.
You can also "guard" the calls to ``try_run`` with an :command:`if`
block checking the :variable:`CMAKE_CROSSCOMPILING` variable and
provide an easy-to-preset alternative for this case.
