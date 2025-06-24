add_custom_target
-----------------

添加一个没有输出的目标，这可以让它始终被构建。

.. code-block:: cmake

  add_custom_target(Name [ALL] [command1 [args1...]]
                    [COMMAND command2 [args2...] ...]
                    [DEPENDS depend depend depend ...]
                    [BYPRODUCTS [files...]]
                    [WORKING_DIRECTORY dir]
                    [COMMENT comment]
                    [JOB_POOL job_pool]
                    [JOB_SERVER_AWARE <bool>]
                    [VERBATIM] [USES_TERMINAL]
                    [COMMAND_EXPAND_LISTS]
                    [SOURCES src1 [src2...]])

添加一个具有指定名称的目标，该目标会执行给定的命令。\
该目标没有输出文件，并且\ *始终被视为过期状态*，即使命令试图创建一个与目标同名的\
文件也是如此。\
使用\ :command:`add_custom_command`\ 命令来生成具有依赖关系的文件。\
默认情况下，没有任何内容依赖于该自定义目标。\
使用\ :command:`add_dependencies`\ 命令来添加与其他目标之间的依赖关系。

选项如下：

``ALL``
  表示该目标应被添加到默认构建目标中，这样每次构建时都会执行它（命令名不能为\ ``ALL``）。

``BYPRODUCTS``
  .. versionadded:: 3.2

  指定命令预期生成的文件，这些文件的修改时间在后续构建时可能更新，也可能不更新。\
  如果副产品文件名是相对路径，则会将其解释为相对于当前源目录对应的构建树目录。\
  每个副产品文件都会自动标记为具有\ :prop_sf:`GENERATED`\ 源文件属性。

  *有关此功能的设计动机*，\ *请参阅策略*\ :policy:`CMP0058`。

  Explicit specification of byproducts is supported by the
  :generator:`Ninja` generator to tell the ``ninja`` build tool
  how to regenerate byproducts when they are missing.  It is
  also useful when other build rules (e.g. custom commands)
  depend on the byproducts.  Ninja requires a build rule for any
  generated file on which another rule depends even if there are
  order-only dependencies to ensure the byproducts will be
  available before their dependents build.

  The :ref:`Makefile Generators` will remove ``BYPRODUCTS`` and other
  :prop_sf:`GENERATED` files during ``make clean``.

  .. versionadded:: 3.20
    Arguments to ``BYPRODUCTS`` may use a restricted set of
    :manual:`generator expressions <cmake-generator-expressions(7)>`.
    :ref:`Target-dependent expressions <Target-Dependent Expressions>`
    are not permitted.

  .. versionchanged:: 3.28
    In custom targets using :ref:`file sets`, byproducts are now
    considered private unless they are listed in a non-private file set.
    See policy :policy:`CMP0154`.

``COMMAND``
  Specify the command-line(s) to execute at build time.
  If more than one ``COMMAND`` is specified they will be executed in order,
  but *not* necessarily composed into a stateful shell or batch script.
  (To run a full script, use the :command:`configure_file` command or the
  :command:`file(GENERATE)` command to create it, and then specify
  a ``COMMAND`` to launch it.)

  If ``COMMAND`` specifies an executable target name (created by the
  :command:`add_executable` command), it will automatically be replaced
  by the location of the executable created at build time if either of
  the following is true:

  * The target is not being cross-compiled (i.e. the
    :variable:`CMAKE_CROSSCOMPILING` variable is not set to true).
  * .. versionadded:: 3.6
      The target is being cross-compiled and an emulator is provided (i.e.
      its :prop_tgt:`CROSSCOMPILING_EMULATOR` target property is set).
      In this case, the contents of :prop_tgt:`CROSSCOMPILING_EMULATOR` will be
      prepended to the command before the location of the target executable.

  If neither of the above conditions are met, it is assumed that the
  command name is a program to be found on the ``PATH`` at build time.

  Arguments to ``COMMAND`` may use
  :manual:`generator expressions <cmake-generator-expressions(7)>`.
  Use the :genex:`TARGET_FILE` generator expression to refer to the location
  of a target later in the command line (i.e. as a command argument rather
  than as the command to execute).

  Whenever one of the following target based generator expressions are used as
  a command to execute or is mentioned in a command argument, a target-level
  dependency will be added automatically so that the mentioned target will be
  built before this custom target (see policy :policy:`CMP0112`).

  * ``TARGET_FILE``
  * ``TARGET_LINKER_FILE``
  * ``TARGET_SONAME_FILE``
  * ``TARGET_PDB_FILE``

  The command and arguments are optional and if not specified an empty
  target will be created.

``COMMENT``
  Display the given message before the commands are executed at
  build time.

  .. versionadded:: 3.26
    Arguments to ``COMMENT`` may use
    :manual:`generator expressions <cmake-generator-expressions(7)>`.

``DEPENDS``
  Reference files and outputs of custom commands created with
  :command:`add_custom_command` command calls in the same directory
  (``CMakeLists.txt`` file).  They will be brought up to date when
  the target is built.

  .. versionchanged:: 3.16
    A target-level dependency is added if any dependency is a byproduct
    of a target or any of its build events in the same directory to ensure
    the byproducts will be available before this target is built.

  Use the :command:`add_dependencies` command to add dependencies
  on other targets.

``COMMAND_EXPAND_LISTS``
  .. versionadded:: 3.8

  Lists in ``COMMAND`` arguments will be expanded, including those
  created with
  :manual:`generator expressions <cmake-generator-expressions(7)>`,
  allowing ``COMMAND`` arguments such as
  ``${CC} "-I$<JOIN:$<TARGET_PROPERTY:foo,INCLUDE_DIRECTORIES>,;-I>" foo.cc``
  to be properly expanded.

``JOB_POOL``
  .. versionadded:: 3.15

  Specify a :prop_gbl:`pool <JOB_POOLS>` for the :generator:`Ninja`
  generator. Incompatible with ``USES_TERMINAL``, which implies
  the ``console`` pool.
  Using a pool that is not defined by :prop_gbl:`JOB_POOLS` causes
  an error by ninja at build time.

``JOB_SERVER_AWARE``
  .. versionadded:: 3.28

  Specify that the command is GNU Make job server aware.

  For the :generator:`Unix Makefiles`, :generator:`MSYS Makefiles`, and
  :generator:`MinGW Makefiles` generators this will add the ``+`` prefix to the
  recipe line. See the `GNU Make Documentation`_ for more information.

  This option is silently ignored by other generators.

.. _`GNU Make Documentation`: https://www.gnu.org/software/make/manual/html_node/MAKE-Variable.html

``SOURCES``
  Specify additional source files to be included in the custom target.
  Specified source files will be added to IDE project files for
  convenience in editing even if they have no build rules.

``VERBATIM``
  All arguments to the commands will be escaped properly for the
  build tool so that the invoked command receives each argument
  unchanged.  Note that one level of escapes is still used by the
  CMake language processor before ``add_custom_target`` even sees
  the arguments.  Use of ``VERBATIM`` is recommended as it enables
  correct behavior.  When ``VERBATIM`` is not given the behavior
  is platform specific because there is no protection of
  tool-specific special characters.

``USES_TERMINAL``
  .. versionadded:: 3.2

  The command will be given direct access to the terminal if possible.
  With the :generator:`Ninja` generator, this places the command in
  the ``console`` :prop_gbl:`pool <JOB_POOLS>`.

``WORKING_DIRECTORY``
  Execute the command with the given current working directory.
  If it is a relative path it will be interpreted relative to the
  build tree directory corresponding to the current source directory.

  .. versionadded:: 3.13
    Arguments to ``WORKING_DIRECTORY`` may use
    :manual:`generator expressions <cmake-generator-expressions(7)>`.

Ninja Multi-Config
^^^^^^^^^^^^^^^^^^

.. versionadded:: 3.20

  ``add_custom_target`` supports the :generator:`Ninja Multi-Config`
  generator's cross-config capabilities. See the generator documentation
  for more information.

See Also
^^^^^^^^

* :command:`add_custom_command`
