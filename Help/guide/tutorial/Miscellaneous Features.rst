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

Exercise 2: Generator Expressions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:manual:`Generator expressions <cmake-generator-expressions(7)>` are a
complicated domain-specific language supported in some contexts within CMake.
They are most easily understood as deferred-evaluation conditionals, they
express requirements where the inputs to determine the correct behavior are not
known during the CMake configuration stage.

.. note::
  This is where generator expressions get their name, they are evaluated when
  the underlying build system is being generated.

Generator expressions were commonly used in combination with
:command:`target_include_directories` to express include directory requirements
across the build and install tree, but file sets have superseded this use case.
Their most common applications now are in multi-config generators and
intricate dependency injection systems.

.. code-block:: cmake

  target_compile_definitions(MyApp PRIVATE "MYAPP_BUILD_CONFIG=$<CONFIG>")

Goal
----

Add a generator expression to ``SimpleTest`` that checks the build configuration
inside a compile definition.

Helpful Resources
-----------------

* :command:`target_compile_definitions`
* :manual:`cmake-generator-expressions(7)`

Files to Edit
-------------

* ``SimpleTest/CMakeLists.txt``

Getting Started
---------------

For this step we will only be editing the ``SimpleTest`` project in the
``Step11`` folder. Complete ``TODO 2``.

Build and Run
-------------

To build the project we first need configure and install ``SimpleTest``.
Navigate to ``Help/guide/Step11/SimpleTest`` and run the appropriate commands.

.. code-block:: console

  cmake --preset tutorial
  cmake --install build

Then navigate to ``Help/guide/Step11/TutorialProject`` and perform the usual build.

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

When running the ``TestMathFunctions`` binary directly, we should a message
naming the build configuration used to build the executable (not necessarily the
same as configuration used to configure ``SimpleTest``). On single configuration
generators, the build configuration can be changed by setting
:variable:`CMAKE_BUILD_TYPE`.

Solution
--------

We add a single line to the ``SimpleTest`` CML.

.. raw:: html

  <details><summary>TODO 2 Click to show/hide answer</summary>

.. literalinclude:: Complete/SimpleTest/CMakeLists.txt
  :caption: TODO 2: SimpleTest/CMakeLists.txt
  :name: SimpleTest/CMakeLists.txt-target_compile_definitions
  :language: cmake
  :start-at: target_compile_definitions
  :end-at: target_compile_definitions

.. raw:: html

  </details>
