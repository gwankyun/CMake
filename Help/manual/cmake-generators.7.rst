.. cmake-manual-description: CMake Generators Reference

cmake-generators(7)
*******************

.. only:: html

   .. contents::

引言
============

*CMake生成器*\ 负责为本地构建系统编写输入文件。必须为构建树选择一个\ `CMake生成器`_，\
以确定要使用什么本地构建系统。可以选择一个\ `附加生成器`_\ 作为一些\ `命令行构建工具生成器`_\
的变体，为辅助IDE生成项目文件。

CMake生成器是特定于平台的，因此每个生成器可能只在某些平台上可用。\
:manual:`cmake(1)`\ 命令行工具\ :option:`--help <cmake --help>`\ 输出列出当前平台上\
可用的生成器。使用它的\ :option:`-G <cmake -G>`\ 选项为新的构建树指定生成器。当创建一个\
新的构建树时，\ :manual:`cmake-gui(1)`\ 提供了交互式的生成器选择。

CMake生成器
================

.. _`Command-Line Build Tool Generators`:

命令行构建工具生成器
----------------------------------

这些生成器支持命令行构建工具。为了使用它们，必须从命令行提示符启动CMake，\
命令行提示符的环境已经为所选的编译器和构建工具配置好了。

.. _`Makefile Generators`:

Makefile生成器
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

Ninja生成器
^^^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 1

   /generator/Ninja
   /generator/Ninja Multi-Config

.. _`IDE Build Tool Generators`:

IDE构建工具生成器
-------------------------

这些生成器支持集成开发环境（IDE）项目文件。由于IDE会配置它们自己的环境，所以可以从任何环境启动CMake。

.. _`Visual Studio Generators`:

Visual Studio生成器
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

其他生成器
^^^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 1

   /generator/Green Hills MULTI
   /generator/Xcode

.. _`Extra Generators`:

附加生成器
================

在\ :manual:`cmake(1)`\ 命令行工具\ :option:`--help <cmake --help>`\ 输出中列出的一些\
`CMake生成器`_\ 可能有变体，为辅助IDE工具指定额外的生成器。生成器名称的形式为\
``<extra-generator> - <main-generator>``。以下是CMake已知的额外的生成器。

.. toctree::
   :maxdepth: 1

   /generator/CodeBlocks
   /generator/CodeLite
   /generator/Eclipse CDT4
   /generator/Kate
   /generator/Sublime Text 2
