CMake
*****

简介
============

`中文翻译说明`_

.. _`中文翻译说明`: zh_CN.rst

CMake是一个跨平台、开源的构建系统生成器。完整的文档请访问\ `CMake主页`_\ 和\
`CMake文档页`_。也可以去\ `CMake社区维基`_\ 参考有用的资料。

.. _`CMake主页`: https://cmake.org
.. _`CMake文档页`: https://cmake.org/documentation
.. _`CMake社区维基`: https://gitlab.kitware.com/cmake/community/-/wikis/home

`Kitware`_\ 维护和支持CMake，与此同时也和与富有成效的贡献者社区合作。

.. _`Kitware`: https://www.kitware.com/cmake

许可
=======

CMake是在OSI认证BSD 3条款许可下发布的。详情见\ `Copyright.txt`_。

.. _`Copyright.txt`: Copyright.txt

构建CMake
==============

支持的平台
-------------------

* Microsoft Windows
* Apple macOS
* Linux
* FreeBSD
* OpenBSD
* Solaris
* AIX

其他类UNIX操作系统应该也能开箱即用，如果不是的话，将CMake移植到这个平台应该不是什么大问题。\
请在\ `CMake论坛`_\ 发帖询问其他人是否有该平台的相关经验。

.. _`CMake论坛`: https://discourse.cmake.org

从头开始建造CMake
---------------------------

UNIX/Mac OSX/MinGW/MSYS/Cygwin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

你需要有一个支持C++11的C++编译器和一个\ ``make``。运行你在CMake的源目录中找到的\
``bootstrap``\ 脚本。可以使用\ ``--help``\ 选项来查看支持的选项。可以使用\
``--prefix=<install_prefix>``\ 选项指定CMake的自定义安装目录。执行无误后，运行\
``make``\ 和\ ``make install``。

例如，如果你只是想从源代码构建和安装CMake，你可以直接在源代码树中构建：\ ::

  $ ./bootstrap && make && sudo make install

或者，如果你计划开发CMake或以其他方式运行测试套件，创建
一个单独的构建树：\ ::

  $ mkdir build && cd build
  $ ../bootstrap && make

Windows
^^^^^^^

在Windows下有两种构建CMake的方法：
   
1. 使用VS 2015或更高版本VS的MSVC编译器。
   你需要下载并安装CMake的二进制版本。可以从\ `CMake下载页`_\ 获得这些版本。然后继续\
   `使用CMake构建CMake`_\ 的步骤。
   
2. 使用MSYS2下的MinGW。
   下载并安装\ `MSYS2`_。然后安装所需的构建工具：\ ::

     $ pacman -S --needed git base-devel mingw-w64-x86_64-gcc
     
   然后和上面一样引导。

.. _`CMake下载页`: https://cmake.org/download
.. _`MSYS2`: https://www.msys2.org/

使用CMake构建CMake
-------------------------

你可以使用基于CMake的构建系统像构建任何其他项目一样构建CMake：使用你喜欢的选项和生成器在这\
个CMake的源代码上运行已安装的CMake。然后构建并安装它。有关如何操作的说明，请参阅有关\
`运行CMake`_\ 文档。

.. _`运行CMake`: https://cmake.org/runningcmake

要构建文档，请使用\ ``-DSPHINX_HTML=ON``\ 或者\ ``-DSPHINX_MAN=ON``\ 安装\
`Sphinx`_\ 并配置CMake，以启用“html”或“man”构建器。如果没有自动找到该工具，则将添加\
``-DSPHINX_EXECUTABLE=/path/to/sphinx-build``。

.. _`Sphinx`: https://sphinx-doc.org

报告错误
==============

如果你发现了错误：
   
1. 如果您有补丁，请阅读\ `CONTRIBUTING.rst`_\ 文档。

2. 否则，请发布到\ `CMake论坛`_，询问预期和观察到的行为，以确定它是否是一个真正的错误。

3. 最后，如果上述步骤不能解决问题，在\ `CMake问题跟踪`_\ 中新开一个条目。

.. _`CMake问题跟踪`: https://gitlab.kitware.com/cmake/cmake/-/issues

贡献
============

请参阅\ `CONTRIBUTING.rst`_，了解如何贡献。

.. _`CONTRIBUTING.rst`: CONTRIBUTING.rst
