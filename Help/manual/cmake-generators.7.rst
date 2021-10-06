.. cmake-manual-description: CMake Generators Reference

cmake-generators(7)
*******************

.. only:: html

   .. contents::

引言
============

*CMake生成器* 负责为本地构建系统编写输入文件。必须为构建树选择一个 `CMake生成器`_，以确定要使用什么本地构建系统。可以选择一个 `附加生成器`_ 作为一些 `命令行构建工具生成器`_ 的变体，为辅助IDE生成项目文件。

CMake生成器是特定于平台的，所以每个生成器可能只在某些平台上可用。:manual:`cmake(1)` 命令行工具 ``--help`` 输出当前平台上可用的生成器。使用它的 ``-G`` 选项为新的构建树指定生成器。当创建一个新的构建树时， :manual:`cmake-gui(1)` 提供了一个生成器的交互式选择。

CMake生成器
================

.. _`Command-Line Build Tool Generators`:

命令行构建工具生成器
----------------------------------

These generators support command-line build tools.  In order to use them,
one must launch CMake from a command-line prompt whose environment is
already configured for the chosen compiler and build tool.

.. _`Makefile Generators`:

Makefile Generators
^^^^^^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 1

   /generator/Borland Makefiles
   /generator/MSYS Makefiles
   /generator/MinGW Makefiles
   /generator/NMake Makefiles
   /generator/NMake Makefiles JOM
   /generator/Unix Makefiles
   /generator/Watcom WMake

.. _`Ninja Generators`:

Ninja Generators
^^^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 1

   /generator/Ninja
   /generator/Ninja Multi-Config

.. _`IDE Build Tool Generators`:

IDE Build Tool Generators
-------------------------

These generators support Integrated Development Environment (IDE)
project files.  Since the IDEs configure their own environment
one may launch CMake from any environment.

.. _`Visual Studio Generators`:

Visual Studio Generators
^^^^^^^^^^^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 1

   /generator/Visual Studio 6
   /generator/Visual Studio 7
   /generator/Visual Studio 7 .NET 2003
   /generator/Visual Studio 8 2005
   /generator/Visual Studio 9 2008
   /generator/Visual Studio 10 2010
   /generator/Visual Studio 11 2012
   /generator/Visual Studio 12 2013
   /generator/Visual Studio 14 2015
   /generator/Visual Studio 15 2017
   /generator/Visual Studio 16 2019
   /generator/Visual Studio 17 2022

Other Generators
^^^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 1

   /generator/Green Hills MULTI
   /generator/Xcode

附加生成器
================

Some of the `CMake生成器`_ listed in the :manual:`cmake(1)`
command-line tool ``--help`` output may have variants that specify
an extra generator for an auxiliary IDE tool.  Such generator
names have the form ``<extra-generator> - <main-generator>``.
The following extra generators are known to CMake.

.. toctree::
   :maxdepth: 1

   /generator/CodeBlocks
   /generator/CodeLite
   /generator/Eclipse CDT4
   /generator/Kate
   /generator/Sublime Text 2
