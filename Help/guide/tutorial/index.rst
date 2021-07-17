CMake教程
**************

引言
============

CMake教程提供了一个循序渐进的指南，涵盖了CMake帮助解决的常见构建系统问题。看各种各样的话题在一个示例项目中一起工作是非常有用的。

步骤
=====

教程文档和示例的源代码可以在CMake源代码树的 ``Help/guide/tutorial`` 目录中找到。每个步骤都有自己的子目录，其中包含可以用作起点的代码。教程示例是渐进的，因此每个步骤都为前一个步骤提供完整的解决方案。

.. toctree::
  :maxdepth: 2

  A Basic Starting Point
  Adding a Library
  Adding Usage Requirements for a Library
  Installing and Testing
  Adding System Introspection
  Adding a Custom Command and Generated File
  Packaging an Installer
  Adding Support for a Testing Dashboard
  Selecting Static or Shared Libraries
  Adding Generator Expressions
  Adding Export Configuration
  Packaging Debug and Release

..
  Whenever a step above is renamed or removed, leave forwarding text in
  its original document file, and list it below to preserve old links
  to cmake.org/cmake/help/latest/ URLs.

.. toctree::
  :maxdepth: 1
  :hidden:
