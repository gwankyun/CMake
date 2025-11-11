步骤11：其他功能
===============================

有些功能在主教程中不太适合介绍或者重要性不够，但值得提及。这些练习收集了其中一些\
功能。它们应该被视为“额外奖励”。

有许多CMake功能未在教程中涵盖，其中一些功能对于使用它们的项目来说被认为是必不可\
少的。其他功能在打包者中常见使用，但在本地构建软件的开发者中很少讨论。

此列表并非对CMake剩余功能的详尽讨论。它可能会随着时间的推移和相关性而增减。

练习1：目标别名
^^^^^^^^^^^^^^^^^^^^^^^^^^

本教程重点介绍安装依赖项并从安装树中使用它们。它还建议使用包管理器来促进此过程。\
然而，由于各种历史和当代原因，CMake项目的使用方式并不总是如此。

可以将依赖项的源代码完全包含在父项目中，并通过\ :command:`add_subdirectory`\
使用它们。执行此操作时，公开的目标名称是项目内部使用的名称，而不是通过\
:command:`install(EXPORT)`\ 导出的名称。这些目标名称不会具有该命令前缀到目标的\
命名空间字符串。

一些项目希望通过与向\ :command:`find_package`\ 使用者提供的接口一致的接口来支持\
此工作流程。CMake通过\ :command:`add_library(ALIAS)`\ 和\
:command:`add_executable(ALIAS)`\ 支持这一点。

.. code-block:: cmake

  add_library(MyLib INTERFACE)
  add_library(MyProject::MyLib ALIAS MyLib)

目标
----

为\ ``MathFunctions``\ 库添加一个库别名。

参考资源
-----------------

* :command:`add_library`

待编辑文件
-------------

* ``TutorialProject/MathFunctions/CMakeLists.txt``

待编辑文件
---------------

在这一步中，我们将只编辑\ ``Step11``\ 文件夹中的\ ``TutorialProject``\ 项目。\
完成\ ``TODO 1``。

构建和运行
-------------

要构建项目，我们首先需要配置和安装\ ``SimpleTest``。导航到\
``Help/guide/Step11/SimpleTest``\ 并运行相应的命令。

.. code-block:: console

  cmake --preset tutorial
  cmake --install build

然后导航到\ ``Help/guide/Step11/TutorialProject``\ 并执行常规构建。

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

添加别名应该不会导致行为上的可观察变化。

解决方案
--------

我们在\ ``MathFunctions``\ 的CML中添加了一行。

.. raw:: html

  <details><summary>TODO 1点击显示/隐藏答案</summary>

.. literalinclude:: Complete/TutorialProject/MathFunctions/CMakeLists.txt
  :caption: TODO 1: TutorialProject/MathFunctions/CMakeLists.txt
  :name: TutorialProject/MathFunctions/CMakeLists.txt-alias
  :language: cmake
  :start-at: ALIAS
  :end-at: ALIAS

.. raw:: html

  </details>

练习2：生成器表达式
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 是CMake中某些上下文中\
支持的一种复杂的领域特定语言。它们最容易被理解为延迟求值的条件语句，用于表达在\
CMake配置阶段无法确定正确行为输入的需求。

.. note::
  这就是生成器表达式名称的由来，它们在底层构建系统生成时进行求值。

生成器表达式通常与\ :command:`target_include_directories`\ 结合使用，以表达构建\
树和安装树之间的包含目录需求，但文件集已取代了这一用例。它们现在最常见的应用是\
在多配置生成器和复杂的依赖注入系统中。

.. code-block:: cmake

  target_compile_definitions(MyApp PRIVATE "MYAPP_BUILD_CONFIG=$<CONFIG>")

目标
----

向\ ``SimpleTest``\ 添加一个生成器表达式，用于在编译定义中检查构建配置

参考资源
-----------------

* :command:`target_compile_definitions`
* :manual:`cmake-generator-expressions(7)`

待编辑文件
-------------

* ``SimpleTest/CMakeLists.txt``

开始操作
---------------

在这一步中，我们将只编辑\ ``Step11``\ 文件夹中的\ ``SimpleTest``\ 项目。完成\
``TODO 2``。

构建和运行
-------------

要构建项目，我们首先需要配置并安装\ ``SimpleTest``。导航到\
``Help/guide/Step11/SimpleTest``\ 并运行相应的命令。

.. code-block:: console

  cmake --preset tutorial
  cmake --install build

然后导航到\ ``Help/guide/Step11/TutorialProject``\ 并执行常规构建。

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

直接运行\ ``TestMathFunctions``\ 二进制文件时，我们应该会看到一条消息，显示用于\
构建可执行文件的构建配置（不一定与用于配置\ ``SimpleTest``\ 的配置相同）。在单一\
配置生成器上，可以通过设置\ :variable:`CMAKE_BUILD_TYPE`\ 来更改构建配置。

解决方案
--------

我们在\ ``SimpleTest``\ 的CML文件中添加一行。

.. raw:: html

  <details><summary>TODO 2点击显示/隐藏答案</summary>

.. literalinclude:: Complete/SimpleTest/CMakeLists.txt
  :caption: TODO 2: SimpleTest/CMakeLists.txt
  :name: SimpleTest/CMakeLists.txt-target_compile_definitions
  :language: cmake
  :start-at: target_compile_definitions
  :end-at: target_compile_definitions

.. raw:: html

  </details>
