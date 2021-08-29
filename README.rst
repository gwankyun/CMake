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

CMake is distributed under the OSI-approved BSD 3-clause License.
See `Copyright.txt`_ for details.

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

Other UNIX-like operating systems may work too out of the box, if not
it should not be a major problem to port CMake to this platform.
Please post to the `CMake Discourse Forum`_ to ask if others have
had experience with the platform.

其他类UNIX操作系统应该也能开箱即用，如果不是的话，将CMake移植到这个平台应该不是什么大问题。请发帖到 `CMake Discourse Forum`_ 询问其他人是否有该平台的相关经验。

.. _`CMake Discourse Forum`: https://discourse.cmake.org

从头开始建造CMake
---------------------------

UNIX/Mac OSX/MinGW/MSYS/Cygwin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You need to have a C++ compiler (supporting C++11) and a ``make`` installed.
Run the ``bootstrap`` script you find in the source directory of CMake.
You can use the ``--help`` option to see the supported options.
You may use the ``--prefix=<install_prefix>`` option to specify a custom
installation directory for CMake.  Once this has finished successfully,
run ``make`` and ``make install``.

你需要有一个支持c++ 11的C++编译器和一个 ``make``。运行你在CMake的源目录中找到的 ``bootstrap`` 脚本。可以使用 ``--help`` 选项来查看支持的选项。可以使用 ``--prefix=<install_prefix>`` 选项指定CMake的自定义安装目录。执行无误后，运行 ``make`` 和 ``make install``。

For example, if you simply want to build and install CMake from source,
you can build directly in the source tree

例如，如果你只是想从源代码构建和安装CMake，你可以直接在源代码树中构建： ::

  $ ./bootstrap && make && sudo make install

Or, if you plan to develop CMake or otherwise run the test suite, create
a separate build tree

或者，如果你计划开发CMake或以其他方式运行测试套件，创建
一个单独的构建树： ::

  $ mkdir cmake-build && cd cmake-build
  $ ../cmake-source/bootstrap && make

Windows
^^^^^^^

There are two ways for building CMake under Windows:

在Windows下有两种构建CMake的方法：

1. Compile with MSVC from VS 2015 or later.
   You need to download and install a binary release of CMake.  You can get
   these releases from the `CMake Download Page`_.  Then proceed with the
   instructions below for `Building CMake with CMake`_.

2. Bootstrap with MinGW under MSYS2.
   Download and install `MSYS2`_.  Then install the required build tools::

     $ pacman -S --needed git base-devel mingw-w64-x86_64-gcc

   and bootstrap as above.

.. _`CMake Download Page`: https://cmake.org/download
.. _`MSYS2`: https://www.msys2.org/

Building CMake with CMake
-------------------------

You can build CMake as any other project with a CMake-based build system:
run the installed CMake on the sources of this CMake with your preferred
options and generators. Then build it and install it.
For instructions how to do this, see documentation on `Running CMake`_.

.. _`Running CMake`: https://cmake.org/runningcmake

To build the documentation, install `Sphinx`_ and configure CMake with
``-DSPHINX_HTML=ON`` and/or ``-DSPHINX_MAN=ON`` to enable the "html" or
"man" builder.  Add ``-DSPHINX_EXECUTABLE=/path/to/sphinx-build`` if the
tool is not found automatically.

.. _`Sphinx`: http://sphinx-doc.org

Reporting Bugs
==============

If you have found a bug:

1. If you have a patch, please read the `CONTRIBUTING.rst`_ document.

2. Otherwise, please post to the `CMake Discourse Forum`_ and ask about
   the expected and observed behaviors to determine if it is really
   a bug.

3. Finally, if the issue is not resolved by the above steps, open
   an entry in the `CMake Issue Tracker`_.

.. _`CMake Issue Tracker`: https://gitlab.kitware.com/cmake/cmake/-/issues

Contributing
============

See `CONTRIBUTING.rst`_ for instructions to contribute.

.. _`CONTRIBUTING.rst`: CONTRIBUTING.rst
