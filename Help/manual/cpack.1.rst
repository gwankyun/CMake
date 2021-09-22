.. cmake-manual-description: CPack Command-Line Reference

cpack(1)
********

Synopsis
========

.. parsed-literal::

 cpack [<options>]

描述
===========

**cpack** 可执行文件是CMake打包程序。它以各种格式生成安装程序和源包。

对于每个安装程序或包格式，**cpack** 都有一个特定的后端，称为“生成器”。生成器负责生成所需的输入并调用特定的包创建工具。不要将这些安装程序或包生成器与 :manual:`cmake <cmake(1)>` 命令的makefile生成器混淆。

所有支持的生成器在 :manual:`cpack-generators
<cpack-generators(7)>` 手册中都有详细说明。命令 ``cpack --help`` 打印目标平台支持的生成器列表。可以通过 :variable:`CPACK_GENERATOR` 变量或命令行选项 ``-G`` 选择要使用的选项。

**cpack** 程序由一个用 :manual:`CMake language <cmake-language(7)>` 编写的配置文件控制。除非通过命令行选项 ``--config`` 进行不同的选择，否则将使用当前目录中的 ``CPackConfig.cmake`` 文件。

在标准的CMake工作流中，CMake可执行文件 ``CPackConfig.cmake`` 是由 :manual:`cmake <cmake(1)>` 可执行文件生成的，前提是 :module:`CPack` 模块包含在项目的 ``CMakeLists.txt`` 文件中。

Options
=======

``-G <generators>``
  ``<generators>`` is a :ref:`semicolon-separated list <CMake Language Lists>`
  of generator names.  ``cpack`` will iterate through this list and produce
  package(s) in that generator's format according to the details provided in
  the ``CPackConfig.cmake`` configuration file.  If this option is not given,
  the :variable:`CPACK_GENERATOR` variable determines the default set of
  generators that will be used.

``-C <configs>``
  Specify the project configuration(s) to be packaged (e.g. ``Debug``,
  ``Release``, etc.), where ``<configs>`` is a
  :ref:`semicolon-separated list <CMake Language Lists>`.
  When the CMake project uses a multi-configuration
  generator such as Xcode or Visual Studio, this option is needed to tell
  ``cpack`` which built executables to include in the package.
  The user is responsible for ensuring that the configuration(s) listed
  have already been built before invoking ``cpack``.

``-D <var>=<value>``
  Set a CPack variable.  This will override any value set for ``<var>`` in the
  input file read by ``cpack``.

``--config <configFile>``
  Specify the configuration file read by ``cpack`` to provide the packaging
  details.  By default, ``CPackConfig.cmake`` in the current directory will
  be used.

``--verbose, -V``
  Run ``cpack`` with verbose output.  This can be used to show more details
  from the package generation tools and is suitable for project developers.

``--debug``
  Run ``cpack`` with debug output.  This option is intended mainly for the
  developers of ``cpack`` itself and is not normally needed by project
  developers.

``--trace``
  Put the underlying cmake scripts in trace mode.

``--trace-expand``
  Put the underlying cmake scripts in expanded trace mode.

``-P <packageName>``
  Override/define the value of the :variable:`CPACK_PACKAGE_NAME` variable used
  for packaging.  Any value set for this variable in the ``CPackConfig.cmake``
  file will then be ignored.

``-R <packageVersion>``
  Override/define the value of the :variable:`CPACK_PACKAGE_VERSION`
  variable used for packaging.  It will override a value set in the
  ``CPackConfig.cmake`` file or one automatically computed from
  :variable:`CPACK_PACKAGE_VERSION_MAJOR`,
  :variable:`CPACK_PACKAGE_VERSION_MINOR` and
  :variable:`CPACK_PACKAGE_VERSION_PATCH`.

``-B <packageDirectory>``
  Override/define :variable:`CPACK_PACKAGE_DIRECTORY`, which controls the
  directory where CPack will perform its packaging work.  The resultant
  package(s) will be created at this location by default and a
  ``_CPack_Packages`` subdirectory will also be created below this directory to
  use as a working area during package creation.

``--vendor <vendorName>``
  Override/define :variable:`CPACK_PACKAGE_VENDOR`.

.. include:: OPTIONS_HELP.txt

See Also
========

.. include:: LINKS.txt
