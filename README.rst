CMake
*****

简介
============

CMake是一个跨平台、开源的构建系统生成器。完整的文档请访问 `CMake Home Page`_ 和 
`CMake Documentation Page`_。也可以去 `CMake Community Wiki`_ 参考有用的资料。

.. _`CMake Home Page`: https://cmake.org
.. _`CMake Documentation Page`: https://cmake.org/documentation
.. _`CMake Community Wiki`: https://gitlab.kitware.com/cmake/community/-/wikis/home

`Kitware`_ 维护和支持CMake，与此同时也和与富有成效的贡献者社区合作。

.. _`Kitware`: http://www.kitware.com/cmake

许可
=======

CMake是在OSI认证BSD 3条款许可下发布的。详情见 `Copyright.txt`_。

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

其他类UNIX操作系统应该也能开箱即用，如果不是的话，将CMake移植到这个平台应该不是什么大问题。请发帖到 `CMake Discourse Forum`_ 询问其他人是否有该平台的相关经验。

.. _`CMake Discourse Forum`: https://discourse.cmake.org

从头开始建造CMake
---------------------------

UNIX/Mac OSX/MinGW/MSYS/Cygwin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

你需要有一个支持c++ 11的C++编译器和一个 ``make``。运行你在CMake的源目录中找到的 ``bootstrap`` 脚本。可以使用 ``--help`` 选项来查看支持的选项。可以使用 ``--prefix=<install_prefix>`` 选项指定CMake的自定义安装目录。执行无误后，运行 ``make`` 和 ``make install``。

例如，如果你只是想从源代码构建和安装CMake，你可以直接在源代码树中构建： ::

  $ ./bootstrap && make && sudo make install

或者，如果你计划开发CMake或以其他方式运行测试套件，创建
一个单独的构建树： ::

  $ mkdir cmake-build && cd cmake-build
  $ ../cmake-source/bootstrap && make

Windows
^^^^^^^

在Windows下有两种构建CMake的方法：

1. Compile with MSVC from VS 2015 or later.
   You need to download and install a binary release of CMake.  You can get
   these releases from the `CMake Download Page`_.  Then proceed with the
   instructions below for `Building CMake with CMake`_.

2. Bootstrap with MinGW under MSYS2.
   Download and install `MSYS2`_.  Then install the required build tools

     $ pacman -S --needed git base-devel mingw-w64-x86_64-gcc

   and bootstrap as above.
   
3. 使用VS 2015或更高版本VS的MSVC编译器。
   你需要下载并安装CMake的二进制版本。可以从 `CMake Download Page`_ 获得这些版本。然后继续 `Building CMake with CMake`_ 的步骤。
   
4. 使用MSYS2下的MinGW。
   下载并安装 `MSYS2`_。然后安装所需的构建工具： ::

.. _`CMake Download Page`: https://cmake.org/download
.. _`MSYS2`: https://www.msys2.org/

使用CMake构建CMake
-------------------------

您可以使用基于CMake的构建系统像构建任何其他项目一样构建CMake：使用你喜欢的选项和生成器在这个CMake的源代码上运行已安装的CMake。然后构建并安装它。有关如何操作的说明，请参阅有关 `Running CMake`_ 文档。

.. _`Running CMake`: https://cmake.org/runningcmake

要构建文档，请使用``-DSPHINX_HTML=ON`` 或者 ``-DSPHINX_MAN=ON`` 安装 `Sphinx`_ 并配置CMake，以启用“html”或“man”构建器。
如果没有自动找到该工具，则将添加 ``-DSPHINX_EXECUTABLE=/path/to/sphinx-build``。

.. _`Sphinx`: http://sphinx-doc.org

报告错误
==============

如果你发现了错误：

1. If you have a patch, please read the `CONTRIBUTING.rst`_ document.

2. Otherwise, please post to the `CMake Discourse Forum`_ and ask about
   the expected and observed behaviors to determine if it is really
   a bug.

3. Finally, if the issue is not resolved by the above steps, open
   an entry in the `CMake Issue Tracker`_.
   
4. 如果您有补丁，请阅读 `CONTRIBUTING.rst`_ 文档。

5. 否则，请发布到 `CMake Discourse Forum`_，询问预期和观察到的行为，以确定它是否是一个真正的错误。

6. 最后，如果上述步骤不能解决问题，在 `CMake Issue Tracker`_ 中新开一个条目。

.. _`CMake Issue Tracker`: https://gitlab.kitware.com/cmake/cmake/-/issues

贡献
============

请参阅 `CONTRIBUTING.rst`_，了解如何贡献。

.. _`CONTRIBUTING.rst`: CONTRIBUTING.rst
