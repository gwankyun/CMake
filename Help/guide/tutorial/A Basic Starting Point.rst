步骤1：一个基本的起点
==============================

我从哪里开始使用CMake？这一步将介绍CMake的一些基本语法、命令和变量。\
随着这些概念的介绍，我们将完成三个练习并创建一个简单的CMake项目。

这一步中的每个练习都将从一些背景信息开始。然后，提供了一个目标和有用的资源列表。\
``待编辑的文件``\ 部分中的每个文件都位于\ ``Step1``\ 目录中，并包含一个或多个\ ``TODO``\ 注释。\
每个\ ``TODO``\ 表示要更改或添加的一到两行代码。这些\ ``TODO``\ 将按数字顺序完成，\
首先完成\ ``TODO 1``，然后完成\ ``TODO 2``，以此类推。\ ``Getting Started``\ 部分将提供一些有用的提示并指导你完成练习。\
然后，\ ``Build and Run``\ 部分将逐步介绍如何构建和测试该练习。最后，在每次练习结束时讨论预期的解决方案。

还要注意，教程中的每个步骤都是建立在下一个步骤之上的。因此，如 \ ``Step2``\ 的开始代码就是\ ``Step1``\ 的完整解决方案。

练习1 - 创建一个基本项目
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

最基本的CMake项目是从单个源代码文件构建的可执行文件。对于像这样的简单项目，只需要一个带有三个命令的\ ``CMakeLists.txt``\ 文件。

**注意：**\ 尽管CMake支持大写、小写和混合大小写命令，但小写命令是首选，并将在整个教程中使用。

任何项目的最顶层的CMakeLists.txt必须通过使用\ :command:`cmake_minimum_required`\ 命令指定最小的CMake版本开始。\
这将建立策略设置，并确保随后的CMake函数在CMake的兼容版本中运行。

要启动一个项目，我们使用\ :command:`project`\ 命令来设置项目名称。每个项目都需要这个调用，应紧随\ :command:`cmake_minimum_required`\ 其后。\
正如我们稍后将看到的，该命令还可以用于指定其他项目级别的信息，如语言或版本号。

最后，:command:`add_executable`\ 命令告诉CMake使用指定的源代码文件创建一个可执行文件。

目标
----

了解如何创建一个简单的CMake项目。

有用的资源
-----------------

* :command:`add_executable`
* :command:`cmake_minimum_required`
* :command:`project`

待编辑的文件
-------------

* ``CMakeLists.txt``

开始
----------------

``tutorial.cxx``\ 的源代码在\ ``Help/guide/tutorial/Step1``\ 目录中提供，可用于计算一个数的平方根。在此步骤中不需要编辑此文件。

在同一个目录中有一个待你完成的\ ``CMakeLists.txt``\ 文件。从\ ``TODO 1``\ 开始，真到\ ``TODO 3``。

构建并运行
-------------

一旦完成了\ ``TODO 1``\ 到\ ``TODO 3``，我们就准备好构建和运行我们的项目了！\
首先，运行\ :manual:`cmake <cmake(1)>`\ 可执行文件或\ :manual:`cmake-gui <cmake-gui(1)>`\ 来配置项目，\
然后用你选择的构建工具构建它。

例如，我们可以在命令行中导航到CMake源代码树的\ ``Help/guide/tutorial``\ 目录，并创建一个构建目录：

.. code-block:: console

  mkdir Step1_build

接下来，导航到那个构建目录并运行\ :manual:`cmake <cmake(1)>`\ 来配置项目并生成一个本地构建系统：

.. code-block:: console

  cd Step1_build
  cmake ../Step1

然后调用构建系统来实际编译/链接项目：

.. code-block:: console

  cmake --build .

最后，试着用以下命令来使用新构建的\ ``Tutorial``：

.. code-block:: console

  Tutorial 4294967296
  Tutorial 10
  Tutorial

解决方案
--------

如上所述，一个三行的\ ``CMakeLists.txt``\ 是启动和运行所需要的全部内容。\
第一行是使用\ :command:`cmake_minimum_required`\ 设置CMake版本如下：

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. literalinclude:: Step2/CMakeLists.txt
  :caption: TODO 1: CMakeLists.txt
  :name: CMakeLists.txt-cmake_minimum_required
  :language: cmake
  :end-before: # 设置工程名和版本号

.. raw:: html

  </details>

创建基本项目的下一步是使用\ :command:`project`\ 命令设置项目名称，如下所示：

.. raw:: html

  <details><summary>TODO 2: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-project

  project(Tutorial)

.. raw:: html

  </details>

基本项目最后调用的一个命令是\ :command:`add_executable`。我们这样称呼它：

.. raw:: html

  <details><summary>TODO 3: 点击显示/隐藏答案</summary>

.. literalinclude:: Step2/CMakeLists.txt
  :caption: TODO 3: CMakeLists.txt
  :name: CMakeLists.txt-add_executable
  :language: cmake
  :start-after: # add the executable
  :end-before: # TODO 9:

.. raw:: html

  </details>

练习2 - 指定c++标准
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

CMake有一些特殊的变量，这些变量是在幕后创建的，或者在项目代码设置时对CMake有意义。\
许多这些变量都以\ ``CMAKE_``\ 开头。在为项目创建变量时，要避免这种命名约定。\
其中两个特殊的用户可设置变量是\ :variable:`CMAKE_CXX_STANDARD`\ 和\ :variable:`CMAKE_CXX_STANDARD_REQUIRED`。这两个变量可以一起使用，以指定构建项目所需的C++标准。

目标
----

添加一个需要C++11的特性。

有用的资源
-----------------

* :variable:`CMAKE_CXX_STANDARD`
* :variable:`CMAKE_CXX_STANDARD_REQUIRED`
* :command:`set`

待编辑的文件
-------------

* ``CMakeLists.txt``
* ``tutorial.cxx``

开始
---------------

继续编辑\ ``Step1``\ 目录中的文件。从\ ``TODO 4``\ 开始，直到\ ``TODO 6``。

首先，通过编辑\ ``tutorial.cxx``\ 来添加一个需要C++11的特性。然后更新\ ``CMakeLists.txt``\ 以要求C++11。

构建并运行
-------------

让我们重新构建我们的项目。因为我们已经创建了一个构建目录并为练习1运行了CMake，我们可以跳到构建步骤：

.. code-block:: console

  cd Step1_build
  cmake --build .

现在我们可以尝试使用与之前相同的命令来使用新构建的\ ``Tutorial``：

.. code-block:: console

  Tutorial 4294967296
  Tutorial 10
  Tutorial

解决方案
--------

首先，我们在\ ``tutorial.cxx``\ 中将\ ``atof``\ 替换为\ ``std::stod``，从而为我们的项目添加一些C++11特性。\
如下所示：

.. raw:: html

  <details><summary>TODO 4: 点击显示/隐藏答案</summary>

.. literalinclude:: Step2/tutorial.cxx
  :caption: TODO 4: tutorial.cxx
  :name: tutorial.cxx-cxx11
  :language: c++
  :start-after: // 将输入转换为double类型
  :end-before: // TODO 12:

.. raw:: html

  </details>

要完成\ ``TODO 5``，只需删除\ ``#include <cstdlib>``。

我们需要在CMake代码中显式地声明它应该使用正确的标志。\
在CMake中启用对特定C++标准的支持的一种方法是使用\ :variable:`CMAKE_CXX_STANDARD`\ 变量。\
对于本教程，将\ ``CMakeLists.txt``\ 文件中的\ :variable:`CMAKE_CXX_STANDARD`\ 变量设置为\ ``11``，将\ :variable:`CMAKE_CXX_STANDARD_REQUIRED`\ 设置为\ ``True``。\
确保调用\ :command:`add_executable`\ 之前添加\ :variable:`CMAKE_CXX_STANDARD`\ 声明。

.. raw:: html

  <details><summary>TODO 6: 点击显示/隐藏答案</summary>

.. literalinclude:: Step2/CMakeLists.txt
  :caption: TODO 6: CMakeLists.txt
  :name: CMakeLists.txt-CXX_STANDARD
  :language: cmake
  :start-after: # 指定C++标准
  :end-before: # TODO 7:

.. raw:: html

  </details>

练习3 - 添加版本号和配置的头文件
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

有时，\ ``CMakelists.txt``\ 文件中定义的变量也可以在源代码中使用，这可能会很有用。\
在这种情况下，我们想打印项目版本。

实现这一点的一种方法是使用配置好的头文件。我们创建一个输入文件，其中包含一个或多个要替换的变量。\
这些变量具有类似\ ``@VAR@``\ 的特殊语法。然后，我们使用\ :command:`configure_file`\ 命令将输入文件复制到给定的输出文件，并用\ ``CMakelists.txt``\ 文件中的\ ``VAR``\ 当前值替换这些变量。

虽然我们可以直接在源代码中编辑版本，但最好使用这个特性，因为它创建了一个真实的单一来源，并避免了重复。

目标
----

定义并报告项目的版本号。

有用的资源
-----------------

* :variable:`<PROJECT-NAME>_VERSION_MAJOR`
* :variable:`<PROJECT-NAME>_VERSION_MINOR`
* :command:`configure_file`
* :command:`target_include_directories`

待编辑的文件
-------------

* ``CMakeLists.txt``
* ``tutorial.cxx``

开始
---------------

继续编辑\ ``Step1``\ 中的文件。从\ ``TODO 7``\ 开始，直到\ ``TODO 12``。\
在这个练习中，我们首先在\ ``CMakeLists.txt``\ 中添加一个项目版本号。\
在同一个文件中，使用\ :command:`configure_file`\ 将给定的输入文件复制到输出文件中，并在输入文件内容中替换一些变量值。

接下来，在定义版本号时创建一个输入头文件\ ``TutorialConfig.h.in``。\
它将接受来自\ :command:`configure_file`\ 的变量。

最后，更新\ ``tutorial.cxx``\ 以打印出它的版本号。

构建并运行
-------------

让我们重新构建我们的项目。和前面一样，我们已经创建了一个构建目录并运行CMake，所以我们可以跳到构建步骤：

.. code-block:: console

  cd Step1_build
  cmake --build .

在不带任何参数运行可执行文件时，验证版本号现已可报告。

解决方案
--------

在本练习中，我们通过打印版本号来改进可执行文件。\
虽然我们可以在源代码中单独完成这一点，但是使用\ ``CMakeLists.txt``\ 可以让我们维护版本号的单个数据源。

首先，我们修改\ ``CMakeLists.txt``\ 文件，以使用\ :command:`project`\ 命令设置项目名称和版本号。\
当\ :command:`project`\ 命令被调用时，CMake在幕后定义\ ``Tutorial_VERSION_MAJOR``\ 和\ ``Tutorial_VERSION_MINOR``。

.. raw:: html

  <details><summary>TODO 7: 点击显示/隐藏答案</summary>

.. literalinclude:: Step2/CMakeLists.txt
  :caption: TODO 7: CMakeLists.txt
  :name: CMakeLists.txt-project-VERSION
  :language: cmake
  :start-after: # 设置工程名和版本号
  :end-before: # 指定C++标准

.. raw:: html

  </details>

然后我们使用\ :command:`configure_file`\ 复制输入文件，替换指定的CMake变量：

.. raw:: html

  <details><summary>TODO 8: 点击显示/隐藏答案</summary>

.. literalinclude:: Step2/CMakeLists.txt
  :caption: TODO 8: CMakeLists.txt
  :name: CMakeLists.txt-configure_file
  :language: cmake
  :start-after: # to the source code
  :end-before: # TODO 8:

.. raw:: html

  </details>

因为配置的文件将被写入项目二进制文件目录，我们必须将该目录添加到要搜索的包括文件路径列表中。

**注意：**\ 在本教程中，我们将交替使用项目构建和项目二进制目录。它们是相同的，并不意味着要引用\ `bin/`\ 目录。

我们使用\ :command:`target_include_directories`\ 来指定可执行目标应该在哪里查找包含文件。

.. raw:: html

  <details><summary>TODO 9: 点击显示/隐藏答案</summary>

.. literalinclude:: Step2/CMakeLists.txt
  :caption: TODO 9: CMakeLists.txt
  :name: CMakeLists.txt-target_include_directories
  :language: cmake
  :start-after: # so that we will find TutorialConfig.h

.. raw:: html

  </details>

``TutorialConfig.h.in``\ 是要配置的输入头文件。\
当\ :command:`configure_file`\ 从我们的\ ``CMakeLists.txt``\ 中被调用时，\
\ ``@Tutorial_VERSION_MAJOR@``\ 和\ ``@Tutorial_VERSION_MINOR@``\ 的值将被\ ``TutorialConfig.h``\ 中来自项目的相应版本号替换。

.. raw:: html

  <details><summary>TODO 10: 点击显示/隐藏答案</summary>

.. literalinclude:: Step2/TutorialConfig.h.in
  :caption: TODO 10: TutorialConfig.h.in
  :name: TutorialConfig.h.in
  :language: c++
  :end-before: // TODO 13:

.. raw:: html

  </details>

接下来，我们需要修改\ ``tutorial.cxx``，以包含配置的头文件\ ``TutorialConfig.h``。

.. raw:: html

  <details><summary>TODO 11: 点击显示/隐藏答案</summary>

.. code-block:: c++
  :caption: TODO 11: tutorial.cxx

  #include "TutorialConfig.h"

.. raw:: html

  </details>

最后，我们通过如下方式更新\ ``tutorial.cxx``，打印出可执行文件的名称和版本号：

.. raw:: html

  <details><summary>TODO 12: 点击显示/隐藏答案</summary>

.. literalinclude:: Step2/tutorial.cxx
  :caption: TODO 12 : tutorial.cxx
  :name: tutorial.cxx-print-version
  :language: c++
  :start-after: {
  :end-before: // 将输入转换为double类型

.. raw:: html

  </details>
