步骤1： CMake入门
==================================

CMake教程的第一步旨在作为使用CMake为小型项目编写实用构建脚本的快速入门。到最后，\
你将能够使用CMake描述可执行文件、库、源文件和头文件以及它们之间的链接关系。

本步骤中的每个练习都将从讨论该练习所需的概念和命令开始。然后，会提供一个目标和\
有用的资源列表。\ ``待编辑文件``\ 部分中的每个文件都位于\ ``Step1``\ 目录中，\
并包含一个或多个\ ``TODO``\ 注释。每个\ ``TODO``\ 代表需要修改或添加的一两行代码。\
这些\ ``TODOs``\ 应按数字顺序完成，先完成\ ``TODO 1``，然后是\ ``TODO 2``，依此类推。

.. note::
  教程中的每个步骤都建立在之前的步骤之上，但步骤并非严格连续。与学习CMake无关的\
  代码（例如C++函数实现或教程范围之外的CMake代码）有时会在步骤之间添加。

``开始操作``\ 部分将提供一些有用的提示并指导你完成练习。然后\ ``构建和运行``\
部分将逐步介绍如何构建和测试练习。最后，在每个练习的末尾会回顾预期的解决方案。

背景
^^^^^^^^^^

CMake的典型用法围绕着一个或多个名为\ ``CMakeLists.txt``\ 的文件展开。此文件有时\
也被称为“列表文件”或“CML”。在特定的软件项目中，任何我们希望向CMake提供关于如何处\
理该目录或子目录中本地文件和操作的指令的目录中，都会存在一个\ ``CMakeLists.txt``\
文件。每个文件都包含一组命令，这些命令描述了与构建软件项目相关的一些信息或操作。

并非软件项目中的每个目录都需要CML，但强烈建议项目根目录包含一个。它将作为CMake\
在配置期间进行初始设置的入口点。这个\ *根*\ CML文件在文件顶部或附近应该始终包含\
两个相同的命令。

.. code-block:: cmake

  cmake_minimum_required(VERSION 3.23)

  project(MyProjectName)

命令\ :command:`cmake_minimum_required`\ 是CMake向项目开发者提供的兼容性保证。\
调用它时，它确保CMake将采用列出版本的行为。如果在包含上述代码的CML上调用更高版本的\
CMake，它的行为将完全如同是CMake 3.23版本。

:command:`project`\ 命令在概念上是一个简单的命令，但却提供了复杂的功能。它告诉\
CMake，接下来是对一个具有给定名称的独立软件项目的描述（而不是类似shell的脚本）。\
当CMake看到\ :command:`project`\ 命令时，它会执行各种检查以确保环境适合构建软件；\
例如检查编译器和其他构建工具，以及发现主机和目标机器的字节序等属性。

.. note::
  虽然每个命令都提供了完整文档的链接，但并不要求读者理解他们使用的每个CMake命令\
  的全部语义。与学习任何软件一样，有效地学习CMake是一个渐进的过程。

本教程步骤的其余部分将主要关注四个命令的使用。\ :command:`add_executable`\ 和\
:command:`add_library`\ 命令用于描述软件项目想要生成的输出产物，\
:command:`target_sources`\ 命令用于将输入文件与其各自的输出产物相关联，以及\
:command:`target_link_libraries`\ 命令用于将输出产物彼此关联起来。

这四个命令是大多数CMake使用场景的核心。正如我们将了解到的，它们足以描述典型项目\
的大多数需求。

练习1 - 构建可执行文件
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

最基本的CMake项目是一个从单个源代码文件构建的可执行文件。对于这样的简单项目，\
只需要一个包含四个命令的\ ``CMakeLists.txt``\ 文件。

.. note::
  尽管CMake支持大写、小写和混合大小写的命令，但更推荐使用小写命令，并且在本教程\
  中将始终使用小写命令。

我们已经介绍了前两个命令：\ :command:`cmake_minimum_required`\ 和\ :command:`project`。\
在CMake使用中，根CML文件中的第一个命令必定是\ :command:`cmake_minimum_required`。\
虽然在一些高级用法中，\ :command:`project`\ 可能不是CML的第二个命令，但就我们的\
目的而言，它始终是第二个命令。

接下来我们需要的命令是\ :command:`add_executable`。\
这个命令会创建一个\ *目标*。在CMake术语中，目标是开发者为一组属性赋予的名称。

目标可能需要跟踪的一些属性示例包括:
  - 构件类型（可执行文件、库、头文件集合等）
  - 源文件
  - 包含目录
  - 可执行文件或库的输出名称
  - 依赖项
  - 编译器和链接器标志

CMake的机制通常最好被理解为对目标及其属性的描述和操作。目标的属性远不止这里列出的\
这些。CMake命令的文档通常会从它们所操作的目标属性的角度来讨论其功能。

目标本身只不过是名称，是这个属性集合的句柄。使用\ :command:`add_executable`\
命令就像指定我们想要用于目标的名称一样简单。

.. code-block:: cmake

  add_executable(MyProgram)

现在我们已经为目标命名，我们可以开始为其关联属性，如我们想要构建和链接的源文件。\
为此，主要命令是\ :command:`target_sources`，它接受目标名称以及一个或多个文件集合\
作为参数。

.. code-block:: cmake

  target_sources(MyProgram
    PRIVATE
      main.cxx
  )

.. note::
  CMake中的路径通常是绝对路径，或者相对于\ :variable:`CMAKE_CURRENT_SOURCE_DIR`\
  的路径。我们还没有讨论过这样的变量，所以你可以理解为“相对于当前CML的位置”。

每个文件集合都以一个\ :ref:`作用域关键字 <Target Command Scope>`\ 作为前缀。我们将\
在讨论链接目标时讨论这些关键字的完整语义，但简单解释是，这些关键字描述了属性应该\
如何被目标的依赖项继承。

通常，没有任何东西依赖于可执行文件。其他程序和库不需要链接到可执行文件，或者继承\
头文件，或者任何类似的东西。因此，这里使用的适当作用域是\ ``PRIVATE``，它告诉\
CMake该属性仅属于\ ``MyProgram``，不可被继承。

.. note::
  这条规则几乎在所有地方都适用。除了高级和深奥的用法外，可执行文件的作用域关键字\
  应该\ *始终*\ 是\ ``PRIVATE``。对于实现文件来说也是如此，无论目标是可执行文件\
  还是库。唯一需要“看到”\ ``.cxx``\ 文件的目标是构建它们的目标。

目标
----

了解如何创建一个包含单个可执行文件的简单CMake项目。

参考资源
-----------------

* :command:`project`
* :command:`cmake_minimum_required`
* :command:`add_executable`
* :command:`target_sources`

待编辑文件
-------------

* ``CMakeLists.txt``

开始操作
----------------

``Tutorial.cxx``\ 的源代码位于\ ``Help/guide/tutorial/Step1/Tutorial``\ 目录中，\
可用于计算一个数的平方根。本练习中无需编辑此文件。

在父目录\ ``Help/guide/tutorial/Step1``\ 中，有一个\ ``CMakeLists.txt``\ 文件需要\
你完成。从\ ``TODO 1``\ 开始，依次完成至\ ``TODO 4``。

构建和运行
-------------

一旦完成了\ ``TODO 1``\ 到\ ``TODO 4``，我们就可以构建并运行项目了！首先，运行\
:manual:`cmake <cmake(1)>`\ 可执行文件或\ :manual:`cmake-gui <cmake-gui(1)>`\
来配置项目，然后使用你选择的构建工具进行构建。

例如，从命令行我们可以导航到\ ``Help/guide/tutorial/Step1``\ 目录，并按如下方式\
调用CMake进行配置：

.. code-block:: console

  cmake -B build

:option:`-B <cmake -B>`\ 标志告诉CMake使用给定的相对路径作为在构建过程中生成文件\
和存储构件的位置。如果省略该标志，则使用当前工作目录。通常认为进行“in-source”\
构建是一种不良实践，即把这些生成的文件放在源码树本身中。

接下来，使用\ :option:`cmake --build <cmake --build>`\ 告诉CMake构建项目，并传递\
与\ :option:`-B <cmake -B>`\ 标志相同的相对路径。

.. code-block:: console

  cmake --build build

``Tutorial``\ 可执行文件将被构建到\ ``build``\ 目录中。对于多配置生成器\
（例如Visual Studio），它可能被放置在\ ``build/Debug``\ 之类的子目录中。

最后，尝试使用新构建的\ ``Tutorial``：

.. code-block:: console

  Tutorial 4294967296
  Tutorial 10
  Tutorial

.. note::
  根据shell的不同，正确的语法可能是\ ``Tutorial``、\ ``./Tutorial``、\
  ``.\Tutorial``，甚至是\ ``.\Tutorial.exe``。为简单起见，练习中将始终使用\
  ``Tutorial``。

解决方案
--------

如上所述，一个包含四个命令的\ ``CMakeLists.txt``\ 就足以让我们启动并运行项目。\
第一行应该是\ :command:`cmake_minimum_required`，用于设置 CMake 版本，如下所示：

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/CMakeLists.txt
  :caption: TODO 1: CMakeLists.txt
  :name: CMakeLists.txt-cmake_minimum_required
  :language: cmake
  :start-at: cmake_minimum_required
  :end-at: cmake_minimum_required

.. raw:: html

  </details>

下一步是使用\ :command:`project`\ 命令来设置项目名称，并告知CMake我们打算用这个\
``CMakeLists.txt``\ 来构建软件。

.. raw:: html

  <details><summary>TODO 2: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/CMakeLists.txt
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-project
  :language: cmake
  :start-at: project
  :end-at: project

.. raw:: html

  </details>

现在我们可以使用\ :command:`add_executable`\ 为Tutorial设置可执行目标。

.. raw:: html

  <details><summary>TODO 3: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/Tutorial/CMakeLists.txt
  :caption: TODO 3: CMakeLists.txt
  :name: CMakeLists.txt-add_executable
  :language: cmake
  :start-at: add_executable
  :end-at: add_executable

.. raw:: html

  </details>

最后，我们可以使用\ :command:`target_sources`\ 将源文件与\ Tutorial\ 可执行目标关联起来。

.. raw:: html

  <details><summary>TODO 4: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 4: CMakeLists.txt
  :name: CMakeLists.txt-target_sources

  target_sources(Tutorial
    PRIVATE
      Tutorial/Tutorial.cxx
  )


.. raw:: html

  </details>

练习2 - 构建库
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

我们只需要再介绍一个命令来构建库，即\ :command:`add_library`。它的工作方式与\
:command:`add_executable`\ 完全相同，不过是用于库。

.. code-block:: cmake

  add_library(MyLibrary)

然而，现在是时候引入头文件了。头文件不会直接作为翻译单元进行构建，也就是说它们不是\
*构建*\ 要求，而是\ *使用*\ 要求。为了构建给定目标的其他部分，我们需要了解头文件。

因此，头文件的描述方式与\ ``tutorial.cxx``\ 这样的实现文件略有不同。它们还需要与\
我们目前使用的\ ``PRIVATE``\ 关键字不同的\ :ref:`作用域关键字 <Target Command Scope>`。

为了描述一组头文件，我们将使用所谓的\ ``FILE_SET``。

.. code-block:: cmake

  target_sources(MyLibrary
    PRIVATE
      library_implementation.cxx

    PUBLIC
      FILE_SET myHeaders
      TYPE HEADERS
      BASE_DIRS
        include
      FILES
        include/library_header.h
  )

这是相当复杂的，但我们会逐点进行讲解。首先，请注意我们的实现文件是\ ``PRIVATE``\
源文件，与之前的可执行文件相同。但是，现在我们的头文件使用\ ``PUBLIC``。这允许\
我们库的使用者“看到”库的头文件。

.. note::
  我们还没有完全准备好讨论作用域关键字的全部语义。我们将在练习3中更全面地介绍它们。

在作用域关键字之后是一个\ ``FILE_SET``，它是一个文件集合，被描述为一个单一的单元。\
一个\ ``FILE_SET``\ 包含以下部分：

* ``FILE_SET <name>``\ 是\ ``FILE_SET``\ 的名称。这是一个句柄，我们可以在其他\
  上下文中使用它来描述这个集合。

* ``TYPE <type>``\ 是我们正在描述的文件类型。最常见的是头文件，但较新版本的CMake\
  支持其他类型，如C++20模块。

* ``BASE_DIRS``\ 是文件的“基础”位置。这最容易理解为通过\ ``-I``\ 标志向编译器\
  描述的用于头文件发现的位置。

* ``FILES``\ 是文件列表，与前面提到的实现源文件列表相同。

要描述这么多信息，有一些有用的快捷方式可以使用。值得注意的是，如果\ ``FILE_SET``\
的名称与类型相同，我们就不需要提供\ ``TYPE``\ 字段。

.. code-block:: cmake

  target_sources(MyLibrary
    PRIVATE
      library_implementation.cxx

    PUBLIC
      FILE_SET HEADERS
      BASE_DIRS
        include
      FILES
        include/library_header.h
  )

还有其他一些快捷方式可以使用，但我们将在后续步骤中更详细地讨论它们。

目标
----

构建一个库。

参考资源
-----------------

* :command:`add_library`
* :command:`target_sources`

待编辑文件
-------------

* ``CMakeLists.txt``

开始操作
---------------

继续在\ ``Step1``\ 目录中编辑文件。从\ ``TODO 5``\ 开始，完成到\ ``TODO 6``。

构建和运行
-------------

让我们再次构建项目。由于我们已经为练习1创建了构建目录并运行了CMake，我们可以直接\
跳到构建步骤：

.. code-block:: console

  cmake --build build

我们应该能够看到库与Tutorial可执行文件一起被创建。

解决方案
--------

我们首先以与Tutorial可执行文件相同的方式添加库目标。

.. raw:: html

  <details><summary>TODO 5: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/MathFunctions/CMakeLists.txt
  :caption: TODO 5: CMakeLists.txt
  :name: CMakeLists.txt-add_library
  :language: cmake
  :start-at: add_library
  :end-at: add_library

.. raw:: html

  </details>

接下来我们需要描述源文件。对于实现文件\ ``MathFunctions.cxx``，这很简单；但对于\
头文件\ ``MathFunctions.h``，我们需要使用一个\ ``FILE_SET``。

我们可以给这个\ ``FILE_SET``\ 起一个自己的名字，或者使用命名为\ ``HEADERS``\
的快捷方式。在本教程中，我们将使用快捷方式，但两种解决方案都是有效的。

对于\ ``BASE_DIRS``，我们需要确定能够实现所需\ ``#include <MathFunctions.h>``\
指令的目录。为了实现这一点，\ ``MathFunctions``\ 文件夹本身将成为基础目录。如果\
我们希望的包含指令是\ ``#include <MathFunctions/MathFunctions.h>``\ 或类似形式，\
我们会做出不同的选择。

.. raw:: html

  <details><summary>TODO 6: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 6: CMakeLists.txt
  :name: CMakeLists.txt-library_sources

  target_sources(MathFunctions
    PRIVATE
      MathFunctions/MathFunctions.cxx

    PUBLIC
      FILE_SET HEADERS
      BASE_DIRS
        MathFunctions
      FILES
        MathFunctions/MathFunctions.h
  )

.. raw:: html

  </details>

练习3 - 链接库和可执行文件
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

我们已经准备好将库与可执行文件结合起来，为此我们必须引入一个新命令\
：:command:`target_link_libraries`。这个命令的名称可能会有些误导，因为它做的远\
不止调用链接器那么简单。它通常用于描述目标之间的关系。

.. code-block:: cmake

  target_link_libraries(MyProgram
    PRIVATE
      MyLibrary
  )

现在我们终于可以讨论\ :ref:`作用域关键字 <Target Command Scope>`\ 了。有三个关键字：\
``PRIVATE``、\ ``INTERFACE``\ 和\ ``PUBLIC``。这些关键字描述了属性如何对目标可用。

* ``PRIVATE``\ 属性（也称为“非接口”属性）仅对拥有它的目标可用，例如\ ``PRIVATE``\
  头文件只会对该头文件所附加的目标可见。

* ``INTERFACE``\ 属性仅对\ *链接*\ 拥有目标的目标可用。拥有目标本身无法访问这些\
  属性。仅包含头文件的库就是一个 ``INTERFACE`` 属性集合的例子，因为仅包含头文件\
  的库本身不会构建任何内容，也不需要访问自己的文件。

* ``PUBLIC``\ 并不是一种独立的属性，而是\ ``PRIVATE``\ 和\ ``INTERFACE``\ 属性的\
  并集。因此，使用\ ``PUBLIC``\ 描述的需求对拥有目标和使用目标都可用。

考虑以下具体示例：

.. code-block:: cmake

  target_sources(MyLibrary
    PRIVATE
      FILE_SET internalOnlyHeaders
      TYPE HEADERS
      FILES
        InternalOnlyHeader.h

    INTERFACE
      FILE_SET consumerOnlyHeaders
      TYPE HEADERS
      FILES
        ConsumerOnlyHeader.h

    PUBLIC
      FILE_SET publicHeaders
      TYPE HEADERS
      FILES
        PublicHeader.h
  )

.. note::
  我们在每个文件集中省略了\ ``BASE_DIRS``，这是另一个快捷方式。当省略时，\
  ``BASE_DIRS``\ 默认为当前源目录。

``MyLibrary``\ 目标有几个属性会被这次调用\ :command:`target_sources`\ 修改。\
到目前为止，我们一直泛泛地使用“属性”这个词，但属性本身是我们可以推理的命名值。\
这里将被修改的两个具体属性是\ :prop_tgt:`HEADER_SETS`\ 和\
:prop_tgt:`INTERFACE_HEADER_SETS`，它们都包含了通过\ :command:`target_sources`\
添加的头文件集合列表。

值\ ``internalOnlyHeaders``\ 将被添加到\ :prop_tgt:`HEADER_SETS`\ 中，\
``consumerOnlyHeaders``\ 被添加到\ :prop_tgt:`INTERFACE_HEADER_SETS`\ 中，而\
``publicHeaders``\ 则同时被添加到两者中。

当构建某个目标时，它将使用自己本身的\ *非接口*\ 属性（例如\ :prop_tgt:`HEADER_SETS`\ ），\
并结合其所链接的任何目标的\ *接口*\ 属性（例如\ :prop_tgt:`INTERFACE_HEADER_SETS`\ ）。

.. note::
  **不需要在这个细节层面上推理CMake属性。**\ 上述内容是为了完整性而描述的。\
  大多数时候你不需要关心命令正在修改哪些具体属性。

  从目标应用命令的角度来看，作用域关键字有一个简单的直观理解：\
  **PRIVATE**\ 是为我自己，\ **INTERFACE**\ 是为其他人，\ **PUBLIC**\ 是为我们所有人。

目标
----

在Tutorial可执行文件中，使用由\ ``MathFunctions``\ 库提供的\ ``sqrt()``\ 函数。

参考资源
-----------------

* :command:`target_link_libraries`

待编辑文件
-------------

* ``CMakeLists.txt``
* ``Tutorial/Tutorial.cxx``

开始操作
---------------

继续编辑来自\ ``Step1``\ 的文件。从\ ``TODO 7``\ 开始，完成到\ ``TODO 9``。\
在此练习中，我们需要使用\ :command:`target_link_libraries`\ 将\ ``MathFunctions``\
目标添加到\ ``Tutorial``\ 目标的链接库中。

修改完CML后，更新\ ``Tutorial.cxx``\ 以使用\ ``mathfunctions::sqrt()``\ 函数\
代替\ ``std::sqrt``。

构建和运行
-------------

让我们再次构建项目。像之前一样，我们已经创建了构建目录并运行了CMake，所以我们可以\
直接跳到构建步骤：

.. code-block:: console

  cmake --build build

验证输出是否符合你对\ ``MathFunctions``\ 库的预期。

解决方案
--------

在本练习中，我们通过将\ ``MathFunctions``\ 添加到\ ``Tutorial``\ 可执行文件的链\
接库中，将\ ``Tutorial``\ 可执行文件描述为\ ``MathFunctions``\ 目标的使用者。

为实现这一点，我们修改\ ``CMakeLists.txt``\ 文件以使用\
:command:`target_link_libraries`\ 命令，使用\ ``Tutorial``\ 作为要修改的目标，\
``MathFunctions``\ 作为我们要添加的库。

.. raw:: html

  <details><summary>TODO 7: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/Tutorial/CMakeLists.txt
  :caption: TODO 7: CMakeLists.txt
  :name: CMakeLists.txt-target_link_libraries
  :language: cmake
  :start-at: target_link_libraries(Tutorial
  :end-at: )

.. raw:: html

  </details>

.. note::
  这里的顺序只是大致相关。在使用\ :command:`add_library`\ 定义\ ``MathFunctions``\
  之前调用\ :command:`target_link_libraries`\ 对CMake来说并不重要。我们只是记录\
  ``Tutorial``\ 依赖于名为\ ``MathFunctions``\ 的某些东西，但\ ``MathFunctions``\
  的具体含义在此阶段并未解析。

  调用\ :command:`target_sources`\ 或\ :command:`target_link_libraries`\ 等CMake\
  命令时，唯一需要定义的目标是正在修改的目标。

最后，剩下要做的就是修改\ ``Tutorial.cxx``\ 以使用新提供的\ ``mathfunctions::sqrt``\
函数。这意味着添加适当的头文件并修改我们的\ ``sqrt()``\ 调用。

.. raw:: html

  <details><summary>TODO 8-9: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/Tutorial/Tutorial.cxx
  :caption: TODO 8: Tutorial/Tutorial.cxx
  :name: Tutorial/Tutorial.cxx-MathFunctions-headers
  :language: c++
  :start-at: iostream
  :end-at: MathFunctions.h

.. literalinclude:: Step3/Tutorial/Tutorial.cxx
  :caption: TODO 9: Tutorial/Tutorial.cxx
  :name: Tutorial/Tutorial.cxx-MathFunctions-code
  :language: c++
  :start-at: calculate square root
  :end-at: mathfunctions::sqrt
  :dedent: 2

.. raw:: html

  </details>

练习4 - 子目录
^^^^^^^^^^^^^^^^^^^^^^^^^^^

在我们继续本教程的过程中，我们将添加更多命令来操作\ ``Tutorial``\ 可执行文件和
``MathFunctions``\ 库。我们要确保将命令保持在与其处理的文件相同的局部范围内。\
虽然对于像这样的小项目来说这并不是一个主要问题，但对于包含许多目标和数千个文件的\
大型项目来说，这样做非常有用。

:command:`add_subdirectory`\ 命令允许我们引入位于项目子目录中的CML文件。

.. code-block:: cmake

  add_subdirectory(SubdirectoryName)

当CMake处理子目录中的\ ``CMakeLists.txt``\ 时，该子目录CML中描述的所有相对路径\
都是相对于该子目录的，而不是相对于顶层CML的。

目标
----

使用\ :command:`add_subdirectory`\ 组织项目。

参考资源
-----------------

* :command:`add_subdirectory`

待编辑文件
-------------

* ``CMakeLists.txt``
* ``Tutorial/CMakeLists.txt``
* ``MathFunctions/CMakeLists.txt``

开始操作
---------------

此步骤的\ ``TODO``\ 分布在三个\ ``CMakeLists.txt``\ 文件中。\
在将\ :command:`target_sources`\ 命令移入子目录时，请务必注意路径变化。

.. note::
  我们之前提到\ ``BASE_DIRS``\ 默认为当前源目录。由于\ ``MathFunctions``\ 所需的\
  包含目录现在将与调用\ :command:`target_sources`\ 的 CML 文件处于同一目录，我们\
  应该完全移除\ ``BASE_DIRS``\ 关键字和参数。

完成\ ``TODO 10``\ 到\ ``TODO 13``。

构建和运行
-------------

由于重新组织，我们需要在重新构建之前清理原始构建目录（否则我们新的\ ``Target``\
构建文件夹将与之前创建的\ ``Target``\ 可执行文件冲突）。我们可以使用\
:option:`--clean-first <cmake--build --clean-first>`\ 标志来实现这一点。

无需重新配置。CMake会由于CML文件的更改而自动重新配置。

.. code-block:: console

  cmake --build build --clean-first

.. note::
  我们的可执行文件和库将输出到构建树中的新位置。\
  一个子目录，它反映了在源码树中调用\ :command:`add_executable`\ 和
  :command:`add_library`\ 的位置。在未来的步骤中，你需要导航到构建树中的这个子\
  目录来运行教程可执行文件。

  你可以通过删除旧的\ ``Tutorial``\ 可执行文件来验证此行为，\
  并观察新文件在\ ``Tutorial/Tutorial``\ 处生成。

解决方案
--------

我们需要将所有与\ ``Tutorial``\ 可执行文件相关的命令移入\ ``Tutorial/CMakeLists.txt``，\
并用\ :command:`add_subdirectory`\ 命令替换它们。我们还需要更新\ ``Tutorial.cxx``\
的路径。

.. raw:: html

  <details><summary>TODO 10-11: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/Tutorial/CMakeLists.txt
  :caption: TODO 10: Tutorial/CMakeLists.txt
  :name: Tutorial/CMakeLists.txt-moved
  :language: cmake

.. code-block:: cmake
  :caption: TODO 11: CMakeLists.txt
  :name: CMakeLists.txt-add_subdirectory-Tutorial

  add_subdirectory(Tutorial)

.. raw:: html

  </details>

我们需要对\ ``MathFunctions``\ 的命令执行相同操作，适当更改相对路径并移除\
``BASE_DIRS``，因为它不再必要，默认值即可工作。

.. raw:: html

  <details><summary>TODO 12-13: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/MathFunctions/CMakeLists.txt
  :caption: TODO 12: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-moved
  :language: cmake

.. literalinclude:: Step3/CMakeLists.txt
  :caption: TODO 13: CMakeLists.txt
  :name: CMakeLists.txt-add_subdirectory-MathFunctions
  :language: cmake
  :start-at: add_subdirectory(MathFunctions
  :end-at: add_subdirectory(MathFunctions

.. raw:: html

  </details>
