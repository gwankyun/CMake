.. cmake-manual-description: CMake Generators Reference

cmake-generators(7)
*******************

.. only:: html

   .. contents::

引言
============

*CMake生成器*\ 负责为本地构建系统编写输入文件。必须为构建树选择一个\ `CMake生成器`_，以确定要使用什么本地构建系统。可以选择一个\ `附加生成器`_\ 作为一些\ `命令行构建工具生成器`_\ 的变体，为辅助IDE生成项目文件。

CMake Generators are platform-specific so each may be available only
on certain platforms.  The :manual:`cmake(1)` command-line tool
:option:`--help <cmake --help>` output lists available generators on the
current platform.  Use its :option:`-G <cmake -G>` option to specify the
generator for a new build tree. The :manual:`cmake-gui(1)` offers
interactive selection of a generator when creating a new build tree.

CMake生成器
================

.. _`Command-Line Build Tool Generators`:

命令行构建工具生成器
----------------------------------

这些生成器支持命令行构建工具。为了使用它们，必须从命令行提示符启动CMake，命令行提示符的环境已经为所选的编译器和构建工具配置好了。

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

Some of the `CMake生成器`_ listed in the :manual:`cmake(1)`
command-line tool :option:`--help <cmake --help>` output may have
variants that specify an extra generator for an auxiliary IDE tool.
Such generator names have the form ``<extra-generator> - <main-generator>``.
The following extra generators are known to CMake.

.. toctree::
   :maxdepth: 1

   /generator/CodeBlocks
   /generator/CodeLite
   /generator/Eclipse CDT4
   /generator/Kate
   /generator/Sublime Text 2
