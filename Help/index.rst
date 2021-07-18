.. title:: CMake参考文档

引言
############

CMake是一个管理源代码构建的工具。
最初，CMake被设计为 ``Makefile`` 各种方言的生成器，现在CMake可以生成像 ``Ninja`` 这样的现代构建系统，也可以生成像Visual Studio和Xcode这样的IDE项目文件。

CMake被广泛用于C和C++，但它也可以用于构建其他语言的源代码。

第一次接触CMake的人可能有会不同的初始目标。学习如何建立一个从互联网上下载的源代码包，从 :guide:`用户交互指南` 开始。这将详细说明运行 :manual:`cmake(1)` 或  :manual:`cmake-gui(1)` 可执行文件所需的步骤，以及如何选择生成器、如何完成构建。

:guide:`使用依赖项指南` 针对的是希望使用第三方库的开发人员。

对于使用CMake启动项目的开发人员来说，:guide:`CMake教程` 是一个合适的起点。:manual:`cmake-buildsystem(7)` 手册的目标是开发人员扩展他们维护构建系统的知识，并熟悉可以用CMake表示的构建目标。:manual:`cmake-packages(7)` 手册解释了如何创建可以被基于cmake的第三方构建系统轻松使用的包。

命令行工具
##################

.. toctree::
   :maxdepth: 1

   /manual/cmake.1
   /manual/ctest.1
   /manual/cpack.1

交互式对话框
###################

.. toctree::
   :maxdepth: 1

   /manual/cmake-gui.1
   /manual/ccmake.1

参考手册
#################

.. toctree::
   :maxdepth: 1

   /manual/cmake-buildsystem.7
   /manual/cmake-commands.7
   /manual/cmake-compile-features.7
   /manual/cmake-developer.7
   /manual/cmake-env-variables.7
   /manual/cmake-file-api.7
   /manual/cmake-generator-expressions.7
   /manual/cmake-generators.7
   /manual/cmake-language.7
   /manual/cmake-modules.7
   /manual/cmake-packages.7
   /manual/cmake-policies.7
   /manual/cmake-presets.7
   /manual/cmake-properties.7
   /manual/cmake-qt.7
   /manual/cmake-server.7
   /manual/cmake-toolchains.7
   /manual/cmake-variables.7
   /manual/cpack-generators.7

.. only:: not man

 指南
 ######

 .. toctree::
    :maxdepth: 1

    /guide/tutorial/index
    /guide/user-interaction/index
    /guide/using-dependencies/index
    /guide/importing-exporting/index
    /guide/ide-integration/index

.. only:: html or text

 发行说明
 #############

 .. toctree::
    :maxdepth: 1

    /release/index

.. only:: html

 索引和搜索
 ################

 * :ref:`genindex`
 * :ref:`search`
