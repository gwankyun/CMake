.. cmake-manual-description: CPack Command-Line Reference

cpack(1)
********

概要
========

.. parsed-literal::

 cpack [<options>]

描述
===========

:program:`cpack`\ 可执行文件是CMake打包程序。它以各种格式生成安装程序和源包。

对于每个安装程序或包格式，:program:`cpack`\ 都有一个特定的后端，称为“生成器”。生成器负责生\
成所需的输入并调用特定的包创建工具。不要将这些安装程序或包生成器与\
:manual:`cmake <cmake(1)>`\ 命令的makefile生成器混淆。

所有支持的生成器都在\ :manual:`cpack-generators <cpack-generators(7)>`\ 手册中指定。\
命令\ ``cpack --help``\ 打印目标平台支持的生成器列表。可以通过\
:variable:`CPACK_GENERATOR`\ 变量或命令行选项\ :cpack-option:`-G`\ 来选择要使用\
哪一个。

:program:`cpack`\ 程序是由一个用\ :manual:`CMake语言 <cmake-language(7)>`\ 编写的配\
置文件控制的。除非通过命令行选项\ :cpack-option:`--config`\ 选择不同的选项，\
否则使用当前目录下的\ ``CPackConfig.cmake``\ 文件。

在标准的CMake工作流中，CMake可执行文件\ ``CPackConfig.cmake``\ 是由\
:manual:`cmake <cmake(1)>`\ 可执行文件生成的，前提是\ :module:`CPack`\ 模块包含在项目\
的\ ``CMakeLists.txt``\ 文件中。

选项
=======

.. program:: cpack

.. option:: -G <generators>

  ``<generators>``\ 是一个项为生成器名称的\
  :ref:`以分号分隔的列表 <CMake Language Lists>`。\ :program:`cpack`\ 将遍历该列表，\
  并根据\ ``CPackConfig.cmake``\ 配置文件中提供的详细信息以该生成器的格式生成包。如果没有\
  给出这个选项，:variable:`CPACK_GENERATOR`\ 变量决定将使用的默认生成器集。

.. option:: -C <configurations>

  指定要打包的项目配置（例如\ ``Debug``、\ ``Release``\ 等），其中\ ``<configurations>``\ 是\
  :ref:`以分号分隔的列表 <CMake Language Lists>`。当CMake项目使用多配置生成器（如\ :generator:`Xcode`\
  或\ :ref:`Visual Studio <Visual Studio Generators>`）时，需要这个选项来告诉\ :program:`cpack`\ 哪些构建的可执行文件要包含\
  在包中。用户有责任确保在调用\ :program:`cpack`\ 之前已经构建了列出的配置。

.. option:: -D <var>=<value>

  设置一个CPack变量。这将覆盖在\ :program:`cpack`\ 读取的输入文件中为\ ``<var>``\ 设置\
  的任何值。

.. option:: --config <configFile>

  指定由\ :program:`cpack`\ 读取的配置文件，以提供打包细节。默认将使用当前目录下的\
  ``CPackConfig.cmake``。

.. option:: -V, --verbose

  运行带有详细输出的\ :program:`cpack`。这可以用于显示来自包生成工具的更多细节，并且适合于\
  项目开发人员。

.. option:: --debug

  运行带有调试输出的\ :program:`cpack`。这个选项主要针对的是\ :program:`cpack`\ 本身的\
  开发人员，项目开发人员通常不需要这个选项。

.. option:: --trace

  将底层的cmake脚本置于跟踪模式。

.. option:: --trace-expand

  将底层cmake脚本置于扩展跟踪模式。

.. option:: -P <packageName>

  覆盖/定义用于打包的\ :variable:`CPACK_PACKAGE_NAME`\ 变量的值。在\
  ``CPackConfig.cmake``\ 文件中为该变量设置的任何值将被忽略。

.. option:: -R <packageVersion>

  覆盖/定义用于打包的\ :variable:`CPACK_PACKAGE_VERSION`\ 变量的值。它将覆盖\
  ``CPackConfig.cmake``\ 文件中设置的或者从\ :variable:`CPACK_PACKAGE_VERSION_MAJOR`、
  :variable:`CPACK_PACKAGE_VERSION_MINOR`\ 和\
  :variable:`CPACK_PACKAGE_VERSION_PATCH`\ 自动计算一个。

.. option:: -B <packageDirectory>

  覆盖/定义\ :variable:`CPACK_PACKAGE_DIRECTORY`，它控制CPack执行其打包工作的目录。生\
  成的包将在默认情况下在此位置创建，并且还将在此目录下创建\ ``_CPack_Packages``\ 子目录，\
  以便在包创建期间用作工作区。

.. option:: --vendor <vendorName>

  覆盖/定义\ :variable:`CPACK_PACKAGE_VENDOR`。

.. option:: --preset <preset>, --preset=<preset>

  Use a package :manual:`preset <cmake-presets(7)>` to specify package
  options. The project binary directory is inferred from the
  :preset:`packagePresets.configurePreset` key.

  .. versionchanged:: 4.4
    If :cpack-option:`--presets-file` is specified, neither of
    ``CMakePresets.json`` nor ``CMakeUserPresets.json`` are required to be
    present.  Otherwise, they are required to be present in the top level
    source directory.  In prior versions, this was strictly required.

.. option:: --presets-file <file>, --presets-file=<file>

  .. versionadded:: 4.4

  Reads :manual:`presets <cmake-presets(7)>` from the given ``<file>``. The
  specified path may be absolute or relative to the current working directory.
  If ``--presets-file`` is given, presets defined in ``CMakePresets.json`` and
  ``CMakeUserPresets.json`` will be ignored.

.. option:: --list-presets

  Lists the available package presets.

  .. versionchanged:: 4.4
    If :cpack-option:`--presets-file` is specified, neither of
    ``CMakePresets.json`` nor ``CMakeUserPresets.json`` are required to be
    present, and only presets defined in the given ``<file>`` will be listed.
    Otherwise, they are required to be present in the top level source
    directory.  In prior versions, this was strictly required.

.. include:: include/OPTIONS_HELP.rst

另行参阅
========

.. include:: include/LINKS.rst
