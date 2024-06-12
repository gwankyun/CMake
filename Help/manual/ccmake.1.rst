.. cmake-manual-description: CMake Curses Dialog Command-Line Reference

ccmake(1)
*********

概要
========

.. parsed-literal::

 ccmake [<options>] -B <path-to-build> [-S <path-to-source>]
 ccmake [<options>] <path-to-source | path-to-existing-build>

描述
===========

:program:`ccmake`\ 可执行文件是CMake curses接口。项目配置设置可以通过这个GUI交互指定。\
当程序运行时，在终端的底部会提供简短的指令。

CMake是一个跨平台的构建系统生成器。项目使用与平台无关的CMake列表文件指定构建过程，这些列表\
文件包含在名为\ ``CMakeLists.txt``\ 的源代码树的每个目录中。用户通过使用CMake为其平台上\
的本地工具生成构建系统来构建项目。

选项
=======

.. program:: ccmake

.. include:: OPTIONS_BUILD.txt

.. include:: OPTIONS_HELP.txt

另行参阅
========

.. include:: LINKS.txt
