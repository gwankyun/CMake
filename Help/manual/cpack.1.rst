.. cmake-manual-description: CPack Command-Line Reference

cpack(1)
********

概要
========

.. parsed-literal::

 cpack [<options>]

描述
===========

**cpack**\ 可执行文件是CMake打包程序。它以各种格式生成安装程序和源包。

对于每个安装程序或包格式，**cpack**\ 都有一个特定的后端，称为“生成器”。生成器负责生成所需的输入并调用特定的包创建工具。不要将这些安装程序或包生成器与\ :manual:`cmake <cmake(1)>`\ 命令的makefile生成器混淆。

所有支持的生成器在\ :manual:`cpack-generators
<cpack-generators(7)>`\ 手册中都有详细说明。命令\ ``cpack --help``\ 打印目标平台支持的生成器列表。可以通过\ :variable:`CPACK_GENERATOR`\ 变量或命令行选项\ ``-G``\ 选择要使用的选项。

**cpack**\ 程序由一个用\ :manual:`CMake language <cmake-language(7)>`\ 编写的配置文件控制。除非通过命令行选项\ ``--config``\ 进行不同的选择，否则将使用当前目录中的\ ``CPackConfig.cmake``\ 文件。

在标准的CMake工作流中，CMake可执行文件\ ``CPackConfig.cmake``\ 是由\ :manual:`cmake <cmake(1)>`\ 可执行文件生成的，前提是\ :module:`CPack`\ 模块包含在项目的\ ``CMakeLists.txt``\ 文件中。

选项
=======

``-G <generators>``
  ``<generators>``\ 是一个包含生成器名称的\ :ref:`以分号分隔的列表 <CMake Language Lists>`。``cpack``\ 将遍历这个列表，并根据\ ``CPackConfig.cmake``\ 配置文件中提供的详细信息，生成生成器格式的包。如果没有提供此选项，则\ :variable:`CPACK_GENERATOR`\ 变量将决定将使用的生成器的默认集合。

``-C <configs>``
  指定要打包的项目配置（例如\ ``Debug``、``Release``\ 等），其中\ ``<configs>``\ 是一个\ :ref:`以分号分隔的列表 <CMake Language Lists>`。当CMake项目使用Xcode或Visual Studio等多配置生成器时，需要使用此选项来告诉\ ``cpack``\ 包中要包含哪些构建的可执行文件。用户负责确保在调用\ ``cpack``\ 之前已经构建了列出的配置。

``-D <var>=<value>``
  设置CPack变量。这将覆盖\ ``cpack``\ 读取的输入文件中为\ ``<var>``\ 设置的任何值。

``--config <configFile>``
  指定\ ``cpack``\ 读取的配置文件，以提供打包细节。默认情况下，将使用当前目录中的\ ``CPackConfig.cmake``。

``--verbose, -V``
  运行\ ``cpack``\ 并输出详细信息。这可以用来显示包生成工具的更多细节，并且适合项目开发人员。

``--debug``
  运行带有调试输出的\ ``cpack``。这个选项主要针对\ ``cpack``\ 本身的开发人员，项目开发人员通常不需要。

``--trace``
  将底层的cmake脚本置于跟踪模式。

``--trace-expand``
  将底层的cmake脚本置于扩展跟踪模式。

``-P <packageName>``
  覆盖/定义用于打包的\ :variable:`CPACK_PACKAGE_NAME`\ 变量的值。在\ ``CPackConfig.cmake``\ 文件中为该变量设置的任何值将被忽略。

``-R <packageVersion>``
  覆盖/定义用于打包的\ :variable:`CPACK_PACKAGE_VERSION`\ 变量的值。它将覆盖\ ``CPackConfig.cmake``\ 文件中设置的或者由\ :variable:`CPACK_PACKAGE_VERSION_MAJOR`、:variable:`CPACK_PACKAGE_VERSION_MINOR`\ 和\ :variable:`CPACK_PACKAGE_VERSION_PATCH`\ 自动计算的值。

``-B <packageDirectory>``
  覆盖/定义\ :variable:`CPACK_PACKAGE_DIRECTORY`，它控制CPack执行打包工作的目录。生成的包将默认创建在这个位置，这个目录下还将创建\ ``_CPack_Packages``\ 子目录，用作包创建期间的工作区。

``--vendor <vendorName>``
  覆盖/定义\ :variable:`CPACK_PACKAGE_VENDOR`。

.. include:: OPTIONS_HELP.txt

另行参阅
========

.. include:: LINKS.txt
