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

单配置和多配置生成器
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

在许多情况下，可以将底层构建系统视为实现细节，在使用CMake时不需要区分例如\
``ninja``\ 和\ ``make``。然而，对于即使是简单的工作流程，我们也需要了解给定生成器\
的一个重要属性：该生成器是支持单配置构建，还是支持多配置构建。

软件构建通常有几种我们可能感兴趣的变体。这些变体的名称如\ ``Debug``、\ ``Release``、\
``RelWithDebInfo``\ 和\ ``MinSizeRel``，其属性与给定变体的名称相对应。

单配置构建系统总是以相同的方式构建软件，如果生成用于产生\ ``Debug``\ 构建的系统，\
它将始终产生\ ``Debug``\ 构建。多配置构建系统可以根据构建时指定的配置产生不同的输出。

.. note::
  **构建配置**\ 和\ **构建类型**\ 这两个术语是同义的。在处理仅支持单个变体的单\
  配置生成器时，生成的变体通常被称为“构建类型”。

  在处理多配置生成器时，可用的变体通常被称为“构建配置”。在构建时选择变体通常被称\
  为“选择配置”，并用标志和变量称为“config”。

  然而，这一约定并不普遍。技术和通俗文档经常混用这两个术语。在通用地处理单配置和\
  多配置生成器的上下文中，\ *配置*\ 和\ *config*\ 被认为是更正确的。

常用的生成器如下：

+-----------------------------+---------------------------------+
| 单配置                      | 多配置                          |
+=============================+=================================+
| :generator:`Ninja`          | :generator:`Ninja Multi-Config` |
+-----------------------------+---------------------------------+
| :generator:`Unix Makefiles` | Visual Studio (all versions)    |
+-----------------------------+---------------------------------+
| :generator:`FASTBuild`      | :generator:`Xcode`              |
+-----------------------------+---------------------------------+

使用单配置生成器时，构建类型基于\ :envvar:`CMAKE_BUILD_TYPE`\ 环境变量选择，\
或者可以通过\ ``cmake -DCMAKE_BUILD_TYPE=<config>``\ 直接在调用CMake时指定。

.. note::
  就本教程而言，使用单配置生成器时通常不需要指定构建类型。特定于平台的默认行为\
  将适用于所有练习。

使用多配置生成器时，构建配置在构建时通过构建系统特定的机制或通过\
:option:`cmake --build --config <cmake--build --config>`\ 选项指定。

其他使用基础
^^^^^^^^^^^^^^^^^^

本教程的其余部分将更深入地介绍剩余的使用基础知识，但为了确保我们拥有一个有效的\
开发环境，这里将列举一些其他的CMake选项标志。


  :option:`cmake -S \<dir\> <cmake -S>`
    指定项目根目录，CMake将在其中查找要构建的项目。这包含根\ ``CMakeLists.txt``\
    文件，将在教程的步骤1中讨论。

    未指定时，默认为当前工作目录。

  :option:`cmake -B \<dir\> <cmake -B>`
    指定构建目录，CMake将在其中输出生成的构建系统的文件，以及运行构建系统时产生\
    的构建产物。

    未指定时，默认为当前工作目录。

  :option:`cmake --build \<dir\> <cmake --build>`
    在指定的构建目录中运行构建系统。这是适用于所有生成器的通用命令。对于多配置\
    生成器，可以通过以下方式请求所需的配置：

    ``cmake --build <dir> --config <cfg>``

试试看
^^^^^^^^^^

``Help/guide/tutorial/Step0``\ 目录包含一个简单的“Hello World” C++项目。CMake如\
何配置这个项目的具体细节将在教程的步骤1中讨论，我们现在只需要关注运行CMake程序本身。

如上所述，根据我们想要用于构建的生成器，有许多可能的CMake运行方式。\
如果我们导航到\ ``Help/guide/tutorial/Step0``\ 目录并运行：

.. code-block:: shell

  cmake -B build

CMake将使用平台的默认生成器为Step0项目生成构建系统到\
``Help/guide/tutorial/Step0/build``\ 中。或者我们可以指定一个特定的生成器，\
例如\ ``Ninja``：

.. code-block:: shell

  cmake -G Ninja -B build

效果类似，但将使用\ ``Ninja``\ 生成器而不是平台默认生成器。

.. note::
  我们不能在不同的生成器之间重用构建目录。如果你想切换到使用相同构建目录的不同\
  生成器，则有必要在CMake运行之间删除构建目录。

生成构建系统后，我们如何构建和运行项目取决于我们使用的生成器类型。如果是在非\
Windows平台上的单配置生成器，我们可以简单地执行：

.. code-block:: shell

  cmake --build build
  ./build/hello

.. note::
  在Windows上，我们可能需要根据使用的shell指定文件扩展名，即\ ``./build/hello.exe``

如果我们在使用多配置生成器，我们将需要指定构建配置。\
默认配置是\ ``Debug``、\ ``Release``、\ ``RelWithDebInfo``\ 和\ ``MinRelSize``。\
构建结果将存储在构建文件夹的特定配置子目录中。例如，我们可以运行：

.. code-block:: shell

  cmake --build build --config Debug
  ./build/Debug/hello

获取帮助和额外资源
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

如需获得CMake社区的帮助，你可以在\
`CMake Discourse论坛 <https://discourse.cmake.org/>`_\ 上联系我们。

.. only:: cmakeorg

  For professional training related to CMake, please see
  `the CMake training landing page <https://www.kitware.com/courses/cmake-training/>`_.
  For other professional CMake services,
  `please reach out to us using our contact form <https://www.kitware.com/contact/>`_.
