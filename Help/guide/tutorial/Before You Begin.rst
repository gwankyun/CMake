步骤0：开始之前
========================

CMake教程由一系列动手实践练习组成，内容包括编写和构建一个C++项目；逐步解决日益\
复杂的构建需求，例如库、代码生成器、测试和外部依赖项。在我们准备好开始这段旅程的\
第一步之前，我们需要确保手头有正确的工具并了解如何使用它们。

.. note::
  本教程材料假设用户拥有可用的C++20编译器和工具链，并且至少对C++语言有初步的了解。\
  在这里不可能涵盖获取这些先决条件的所有可能方式。

这个先决条件步骤提供了如何获取和运行CMake本身的建议，以便完成教程的其余部分。\
如果你已经熟悉运行CMake的基本知识，可以自由地继续教程的其余部分。

获取教程练习
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. include:: include/source.rst

|tutorial_source|
教程的每个步骤都有一个对应的子文件夹，该文件夹作为该步骤练习的起点。

获取CMake
^^^^^^^^^^^^^

获取CMake最明显的方式是从CMake网站下载。\
`网站的“下载”部分 <https://cmake.org/download/>`_\ 包含了适用于所有常见（以及一\
些不常见）桌面平台的最新CMake构建版本。

然而，最好通过你平台上开发者工具的常规分发机制来获取CMake。CMake可在大多数包管理\
仓库中找到，也可以作为Visual Studio的组件安装，甚至可以从 Python 包索引中安装。\
此外，在大多数针对C/C++的CI/CD运行器的基础镜像中通常也包含CMake。你应该查阅你的\
软件构建环境文档，确认是否已提供CMake。

CMake也可以根据CMake源码树根目录下的\ ``README.rst``\ 中描述的说明从源码编译。

与任何程序一样，为了能够从shell中运行CMake，它必须位于\ ``PATH``\ 环境变量所包含\
的路径中。你可以通过运行任意CMake命令来验证CMake是否可用。

.. code-block:: shell

  $ cmake --version
  cmake version 3.23.5

  CMake suite maintained and supported by Kitware (kitware.com/cmake).


.. note::
  如果使用的是由Visual Studio提供的开发环境，最好在Developer Command Prompt或\
  Developer PowerShell内部运行CMake。这样可以确保CMake能访问到所有必需的开发工具\
  和环境变量。

CMake生成器
^^^^^^^^^^^^^^^^

CMake是一个配置程序，有时被称为“元”构建系统。与其他配置系统一样，CMake最终并不负\
责运行生成软件构建的命令。相反，CMake会基于项目、环境和用户提供配置信息生成一个\
构建系统。

CMake支持多种构建系统作为此配置过程的输出。这些输出后端称为“生成器”，因为它们会生成\
构建系统。CMake支持许多生成器，其文档可以在\ :manual:`cmake-generators(7)`\ 中找\
到。有关特定CMake安装所支持生成器的信息可以通过\ :option:`cmake --help`\ 在\
“Generators”标题下找到。

因此，使用CMake需要提供一种消费此生成器输出的构建程序。\ ``Unix Makefiles``、\
``Ninja``\ 和\ ``Visual Studio``\  生成器分别需要兼容的\ ``make``、\ ``ninja``\
和\ ``Visual Studio``\ 安装。

.. note::
  Windows上的默认生成器通常是运行CMake机器上可用的最新Visual Studio版本，其他地方则\
  是\ ``Unix Makefiles``。

使用的生成器可通过\ :envvar:`CMAKE_GENERATOR`\ 环境变量或\ :option:`cmake -G`\
选项控制。

Single and Multi-Configuration Generators
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In many cases, it is possible to treat the underlying build system as an
implementation detail and not differentiate between, for example, ``ninja``
and ``make`` when using CMake. However, there is one significant property
of a given generator which we need to be aware of for even trivial workflows:
if the generator supports single configuration builds, or if it supports
multi-configuration builds.

Software builds often have several variants which we might be interested in.
These variants have names like ``Debug``, ``Release``, ``RelWithDebInfo``, and
``MinSizeRel``, with properties corresponding to the name of the given variant.

A single-configuration build system always builds the software the same way, if
it is generated to produce ``Debug`` builds it will always produce
a ``Debug`` build. A multi-configuration build system can produce different
outputs depending on the configuration specified at build time.

.. note::
  The terms **build configuration** and **build type** are synonymous. When
  dealing with single-configuration generators, which only support a single
  variant, the generated variant is usually called the "build type".

  When dealing with multi-configuration generators, the available variants are
  usually called the "build configurations". Selecting a variant at build
  time is usually called "selecting a configuration" and referred to by flags
  and variables as the "config".

  However, this convention is not universal. Both technical and colloquial
  documentation often mix the two terms. *Configuration* and *config* are
  considered the more correct in contexts which generically address both single
  and multi-configuration generators.

The commonly used generators are as follows:

+-----------------------------+---------------------------------+
| Single-Configuration        | Multi-Configuration             |
+=============================+=================================+
| :generator:`Ninja`          | :generator:`Ninja Multi-Config` |
+-----------------------------+---------------------------------+
| :generator:`Unix Makefiles` | Visual Studio (all versions)    |
+-----------------------------+---------------------------------+
| :generator:`FASTBuild`      | :generator:`Xcode`              |
+-----------------------------+---------------------------------+

When using a single-configuration generator, the build type is selected based on
the :envvar:`CMAKE_BUILD_TYPE` environment variable, or can be specified
directly when invoking CMake via ``cmake -DCMAKE_BUILD_TYPE=<config>``.

.. note::
  For the purpose of the tutorial, it is generally unnecessary to specify a
  build type when working with single-configuration generators. The
  platform-specific default behavior will work for all exercises.

When using a multi-configuration generator, the build configuration is specified
at build time using either a build-system specific mechanism, or via the
:option:`cmake --build --config <cmake--build --config>` option.

Other Usage Basics
^^^^^^^^^^^^^^^^^^

The rest of the tutorial will cover the remaining usage basics in greater depth,
but for the purpose of ensuring we have a working development environment a few
more CMake option flags will be enumerated here.


  :option:`cmake -S \<dir\> <cmake -S>`
    Specifies the project root directory, where CMake will find the project
    to be built. This contains the root ``CMakeLists.txt`` file which will
    be discussed in Step 1 of the tutorial.

    When unspecified, defaults to the current working directory.

  :option:`cmake -B \<dir\> <cmake -B>`
    Specifies the build directory, where CMake will output the files for the
    generated build system, as well as artifacts of the build itself when
    the build system is run.

    When unspecified, defaults to the current working directory.

  :option:`cmake --build \<dir\> <cmake --build>`
    Runs the build system in the specified build directory. This is a generic
    command for all generators. For multi-configuration generators, the desired
    configuration can be requested via:

    ``cmake --build <dir> --config <cfg>``

Try It Out
^^^^^^^^^^

The ``Help/guide/tutorial/Step0`` directory contains a simple "Hello World"
C++ project. The specifics of how CMake configures this project will be
discussed in Step 1 of the tutorial, we need only concern ourselves with
running the CMake program itself.

As described above, there are many possible ways we could run CMake depending
on which generator we want to use for the build. If we navigate to the
``Help/guide/tutorial/Step0`` directory and run:

.. code-block:: shell

  cmake -B build

CMake will generate a build system for the Step0 project into
``Help/guide/tutorial/Step0/build`` using the default generator for the
platform. Alternatively we can specify a specific generator, ``Ninja`` for
example, with:

.. code-block:: shell

  cmake -G Ninja -B build

The effect is similar, but will use the ``Ninja`` generator instead of the
platform default.

.. note::
  We can't reuse the build directory with different generators. It is necessary
  to delete the build directory between CMake runs if you want to switch to a
  different generator using the same build directory.

How we build and run the project after generating the build system depends on
the kind of generator we're using. If it is a single-configuration generator on
a non-Windows platform, we can simply do:

.. code-block:: shell

  cmake --build build
  ./build/hello

.. note::
  On Windows we might need to specify the file extension depending on which
  shell is in use, ie ``./build/hello.exe``

If we're using a multi-configuration generator, we will want to specify the
build configuration. The default configurations are ``Debug``, ``Release``,
``RelWithDebInfo``, and ``MinRelSize``. The result of the build will be stored
in a configuration-specific subdirectory of the build folder. So for example we
could run:

.. code-block:: shell

  cmake --build build --config Debug
  ./build/Debug/hello

Getting Help and Additional Resources
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For help from the CMake community, you can reach out on
`the CMake Discourse Forums <https://discourse.cmake.org/>`_.

.. only:: cmakeorg

  For professional training related to CMake, please see
  `the CMake training landing page <https://www.kitware.com/courses/cmake-training/>`_.
  For other professional CMake services,
  `please reach out to us using our contact form <https://www.kitware.com/contact/>`_.
