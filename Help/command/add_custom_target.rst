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

  :generator:`Ninja`\ 生成器支持显式指定副产品，以此告知\ ``ninja``\ 构建工具在\
  副产品缺失时如何重新生成它们。\
  当其他构建规则（例如自定义命令）依赖于这些副产品时，显式指定副产品同样有用。\
  Ninja要求，对于任何被其他规则依赖的生成文件，都必须有对应的构建规则，即便这些\
  依赖关系只是顺序依赖。这样做是为了确保在依赖这些副产品的规则执行之前，这些副产\
  品已经生成并可用。

  在执行\ ``make clean``\ 时，:ref:`Makefile Generators`\ 会移除\ ``BYPRODUCTS``\
  以及其他具有\ :prop_sf:`GENERATED`\ 属性的文件。

  .. versionadded:: 3.20
    ``BYPRODUCTS``\ 的参数可以使用一组有限的\
    :manual:`生成器表达式 <cmake-generator-expressions(7)>`。\
    不允许使用\ :ref:`依赖于目标的表达式 <Target-Dependent Expressions>`。

  .. versionchanged:: 3.28
    在使用\ :ref:`file sets`\ 的自定义目标中，除非副产品被列入非私有文件集，\
    否则它们现在被视为私有。请参阅策略\ :policy:`CMP0154`。

``COMMAND``
  指定在构建时要执行的命令行。\
  如果指定了多个\ ``COMMAND``，它们将按顺序执行，但\ *不*\ 一定会组合成一个有状态\
  的shell脚本或批处理脚本。\
  （若要运行完整脚本，可使用\ :command:`configure_file`\ 命令或\ :command:`file(GENERATE)`\
  命令创建脚本，然后指定一个\ ``COMMAND``\ 来启动它。）

  如果\ ``COMMAND``\ 指定了一个可执行目标名称（由\ :command:`add_executable`\
  命令创建），在满足以下任一条件时，它将自动被构建时生成的可执行文件的路径所替换：

  * 该目标未进行交叉编译（即\ :variable:`CMAKE_CROSSCOMPILING`\ 变量未设置为true）。
  * .. versionadded:: 3.6
      该目标正在进行交叉编译，并且提供了一个模拟器（即其\
      :prop_tgt:`CROSSCOMPILING_EMULATOR`\ 目标属性已设置）。\
      在这种情况下，:prop_tgt:`CROSSCOMPILING_EMULATOR`\ 的内容将被添加到命令前，\
      置于目标可执行文件路径之前。

  如果上述条件均不满足，则假定该命令名是一个在构建时可从\ ``PATH``\ 环境变量中找到的程序。

  ``COMMAND``\ 的参数可以使用\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`。
  使用\ :genex:`TARGET_FILE`\ 生成器表达式，在后续命令行里引用某个目标文件的位置\
  （即作为命令参数，而非作为要执行的命令）。

  当以下基于目标的生成器表达式中的任意一个被用作要执行的命令，或在命令参数中被提及，\
  CMake会自动添加一个目标级别的依赖项，确保被提及的目标在这个自定义目标构建之前\
  完成构建（详见策略\ :policy:`CMP0112`）。

  * ``TARGET_FILE``
  * ``TARGET_LINKER_FILE``
  * ``TARGET_SONAME_FILE``
  * ``TARGET_PDB_FILE``

  命令和参数是可选的。如果未指定，将创建一个空目标。

``COMMENT``
  在构建时执行命令之前，显示给定的消息。

  .. versionadded:: 3.26
    ``COMMENT``\ 的参数可以使用\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`。

``DEPENDS``
  引用同一目录（即\ ``CMakeLists.txt``\ 文件所在目录）下通过\
  :command:`add_custom_command`\ 命令创建的自定义命令所涉及的文件和输出内容。\
  当该目标构建时，这些文件和输出内容将被更新到最新状态。

  .. versionchanged:: 3.16
    如果任意依赖项是同一目录下某个目标或其任意构建事件的副产品，将添加一个目标\
    级别的依赖项，以确保在构建此目标之前，这些副产品可用。

  使用\ :command:`add_dependencies`\ 命令添加与其他目标之间的依赖关系。

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
