.. cmake-manual-description: CMake GUI Command-Line Reference

cmake-gui(1)
************

概要
========

.. parsed-literal::

 cmake-gui [<options>]
 cmake-gui [<options>] <path-to-source | path-to-existing-build>
 cmake-gui [<options>] -S <path-to-source> -B <path-to-build>
 cmake-gui [<options>] --browse-manual

描述
===========

:program:`cmake-gui`\ 可执行文件就是CMake GUI程序。可以交互设置项目配置。程序运行时，窗口底部会显示简短的说明。

CMake是一个跨平台的构建系统生成器。项目使用与平台无关的CMake列表文件指定构建过程，这些列表文件包含在名为\ ``CMakeLists.txt``\ 的源代码树的每个目录中。用户通过使用CMake为其平台上的本地工具生成构建系统来构建项目。

选项
=======

.. program:: cmake-gui

.. option:: -S <path-to-source>

 Path to root directory of the CMake project to build.

.. option:: -B <path-to-build>

 Path to directory which CMake will use as the root of build directory.

 如果目录不存在，CMake会创建它。

.. option:: --preset=<preset-name>

 Name of the preset to use from the project's
 :manual:`presets <cmake-presets(7)>` files, if it has them.

.. option:: --browse-manual

 Open the CMake reference manual in a browser and immediately exit.

.. include:: OPTIONS_HELP.txt

另行参阅
========

.. include:: LINKS.txt
