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

对于每个安装程序或包格式，:program:`cpack`\ 都有一个特定的后端，称为“生成器”。\
生成器负责生成所需的输入并调用特定的包创建工具。不要将这些安装程序或包生成器与\ :manual:`cmake <cmake(1)>`\ 命令的makefile生成器混淆。

All supported generators are specified in the :manual:`cpack-generators
<cpack-generators(7)>` manual.  The command ``cpack --help`` prints a
list of generators supported for the target platform.  Which of them are
to be used can be selected through the :variable:`CPACK_GENERATOR` variable
or through the command-line option :option:`-G <cpack -G>`.

The :program:`cpack` program is steered by a configuration file written in the
:manual:`CMake language <cmake-language(7)>`. Unless chosen differently
through the command-line option :option:`--config <cpack --config>`, the
file ``CPackConfig.cmake`` in the current directory is used.

在标准的CMake工作流中，CMake可执行文件\ ``CPackConfig.cmake``\ 是由\ :manual:`cmake <cmake(1)>`\ 可执行文件生成的，前提是\ :module:`CPack`\ 模块包含在项目的\ ``CMakeLists.txt``\ 文件中。

选项
=======

.. program:: cpack

.. option:: -G <generators>

  ``<generators>`` is a :ref:`semicolon-separated list <CMake Language Lists>`
  of generator names.  :program:`cpack` will iterate through this list and produce
  package(s) in that generator's format according to the details provided in
  the ``CPackConfig.cmake`` configuration file.  If this option is not given,
  the :variable:`CPACK_GENERATOR` variable determines the default set of
  generators that will be used.

.. option:: -C <configs>

  Specify the project configuration(s) to be packaged (e.g. ``Debug``,
  ``Release``, etc.), where ``<configs>`` is a
  :ref:`semicolon-separated list <CMake Language Lists>`.
  When the CMake project uses a multi-configuration
  generator such as Xcode or Visual Studio, this option is needed to tell
  :program:`cpack` which built executables to include in the package.
  The user is responsible for ensuring that the configuration(s) listed
  have already been built before invoking :program:`cpack`.

.. option:: -D <var>=<value>

  Set a CPack variable.  This will override any value set for ``<var>`` in the
  input file read by :program:`cpack`.

.. option:: --config <configFile>

  Specify the configuration file read by :program:`cpack` to provide the packaging
  details.  By default, ``CPackConfig.cmake`` in the current directory will
  be used.

.. option:: -V, --verbose

  Run :program:`cpack` with verbose output.  This can be used to show more details
  from the package generation tools and is suitable for project developers.

.. option:: --debug

  Run :program:`cpack` with debug output.  This option is intended mainly for the
  developers of :program:`cpack` itself and is not normally needed by project
  developers.

.. option:: --trace

  Put the underlying cmake scripts in trace mode.

.. option:: --trace-expand

  Put the underlying cmake scripts in expanded trace mode.

.. option:: -P <packageName>

  Override/define the value of the :variable:`CPACK_PACKAGE_NAME` variable used
  for packaging.  Any value set for this variable in the ``CPackConfig.cmake``
  file will then be ignored.

.. option:: -R <packageVersion>

  Override/define the value of the :variable:`CPACK_PACKAGE_VERSION`
  variable used for packaging.  It will override a value set in the
  ``CPackConfig.cmake`` file or one automatically computed from
  :variable:`CPACK_PACKAGE_VERSION_MAJOR`,
  :variable:`CPACK_PACKAGE_VERSION_MINOR` and
  :variable:`CPACK_PACKAGE_VERSION_PATCH`.

.. option:: -B <packageDirectory>

  Override/define :variable:`CPACK_PACKAGE_DIRECTORY`, which controls the
  directory where CPack will perform its packaging work.  The resultant
  package(s) will be created at this location by default and a
  ``_CPack_Packages`` subdirectory will also be created below this directory to
  use as a working area during package creation.

.. option:: --vendor <vendorName>

  Override/define :variable:`CPACK_PACKAGE_VENDOR`.

.. option:: --preset <presetName>

  Use a preset from :manual:`cmake-presets(7)`.

.. option:: --list-presets

  List presets from :manual:`cmake-presets(7)`.

.. include:: OPTIONS_HELP.txt

另行参阅
========

.. include:: LINKS.txt
