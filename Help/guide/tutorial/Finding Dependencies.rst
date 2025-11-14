步骤10：查找依赖项
=============================

在C/C++软件开发中，管理构建依赖项一直是现代开发者面临的最高排名挑战之一。CMake\
提供了丰富的工具集来发现和验证不同类型的依赖项。

然而，对于正确打包的项目，无需使用这些高级工具。如今许多流行的库和实用程序项目都\
会生成正确的安装树，就像我们在\ ``Step 9``\ 中设置的那样，这些安装树很容易集成到\
CMake中。

在这种最佳情况下，我们只需要使用\ :command:`find_package`\ 命令将依赖项导入到\
我们的项目中。

背景
^^^^^^^^^^

CMake中有五个用于发现依赖项的主要命令，前四个是：

  :command:`find_file`
    查找并报告命名文件的完整路径，这往往是\ ``find``\ 命令中最灵活的一个。

  :command:`find_library`
    查找并报告静态归档文件或共享对象的完整路径，适用于与\
    :command:`target_link_libraries`\ 一起使用。

  :command:`find_path`
    查找并报告\ *包含*\ 文件的目录的完整路径。这最常用于头文件与\
    :command:`target_include_directories`\ 的组合。

  :command:`find_program`
    查找并报告程序的可调用名称或路径。通常与\ :command:`execute_process`\ 或\
    :command:`add_custom_command`\ 结合使用。

这些命令应被视为“备用”，在主find命令不适用时使用。主find命令是\
:command:`find_package`。它使用全面的内置启发式方法和上游提供的打包文件，为请求\
的依赖项提供最佳接口。

练习1 - 使用\ ``find_package()``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:command:`find_package`\ 命令使用的搜索路径和行为在其文档中有完整描述，但过于冗长，\
此处不做复述。简而言之，它会搜索众所周知的、不太知名的、晦涩的以及用户提供的位置，\
尝试找到满足给定要求的包。

.. code-block:: cmake

  find_package(ForeignLibrary)

使用\ :command:`find_package`\ 的最佳方法是确保所有依赖项在构建前已安装到单个安\
装树中，然后通过\ :variable:`CMAKE_PREFIX_PATH`\ 变量让\ :command:`find_package`\
知道该安装树的位置。

.. note::
  构建和安装依赖项本身可能需要大量工作。虽然本教程为了说明目的目的目的会这样做，\
  但\ **强烈**\ 建议使用包管理器进行项目本地依赖管理。

除了要查找的包之外，\ :command:`find_package`\ 还接受几个参数。最值得注意的有：

* 位置参数\ ``<version>``，用于描述要对照包的配置版本文件进行检查的版本。这个参\
  数应谨慎使用，通过包管理器控制正在安装的依赖项版本比可能在其他无害的版本更新中\
  破坏构建更好。

  如果已知包依赖于旧版本的依赖项，那么使用版本要求可能是合适的。

* ``REQUIRED``\ 用于非可选依赖项，如果找不到这些依赖项，构建应该中止。

* ``QUIET``\ 用于可选依赖项，找不到这些依赖项时不应向用户报告任何内容。

:command:`find_package`\ 通过\ ``<PackageName>_FOUND``\ 变量报告其结果，对于找到\
和未找到的包，这些变量将分别设置为true或false值。

目标
----

将外部安装的测试框架集成到Tutorial项目中。

参考资源
-----------------

* :command:`find_package`
* :command:`target_link_libraries`

待编辑文件
-------------

* ``TutorialProject/CMakePresets.json``
* ``TutorialProject/Tests/CMakeLists.txt``
* ``TutorialProject/Tests/TestMathFunctions.cxx``

开始操作
---------------

``Step10``\ 文件夹的组织结构与前面步骤不同。我们需要编辑的教程项目位于\
``Step10/TutorialProject``\ 下。现在还出现了另一个项目\ ``SimpleTest``，以及一个\
部分填充的安装树，我们将在后续练习中使用它。在本次练习中，你无需编辑这些其他目录\
中的任何内容，所有的\ ``TODO``\ 和解决方案步骤都是针对\ ``TutorialProject``\ 的。

``SimpleTest``\ 包提供了两个有用的结构：可链接到测试二进制文件的\
``SimpleTest::SimpleTest``\ 目标，以及用于自动向CTest添加测试的\
``simpletest_discover_tests``\ 函数。

与其他测试框架类似，\ ``simpletest_discover_tests``\ 只需要传入包含测试的可执行\
目标名称即可。

.. code-block:: cmake

  simpletest_discover_tests(MyTestExe)

``TestMathFunctions.cxx``\ 文件已更新为使用\ ``SimpleTest``\ 框架，其风格类似于\
GoogleTest或Catch2。按顺序执行\ ``TODO 1``\ 到\ ``TODO 5``，以使用新的测试框架。

.. note::
  也许无需多言，但\ ``SimpleTest``\ 是一个非常简陋的测试框架，只是表面上类似于\
  功能性测试库。虽然本教程中的大部分CMake代码可以原封不动地用于其他项目，但你不\
  应在本教程之外使用\ ``SimpleTest``，也不应尝试从它提供的CMake代码中学习。

构建和运行
-------------

首先，我们必须安装\ ``SimpleTest``\ 框架。导航到\ ``Help/guide/Step10/SimpleTest``\
目录并运行以下命令：

.. code-block:: console

  cmake --preset tutorial
  cmake --install build

.. note::
  ``SimpleTest``\ 预设配置了为教程安装\ ``SimpleTest``\ 所需的一切。由于超出本\
  教程范围的原因，无需构建或为\ ``SimpleTest``\ 提供任何其他配置。

我们可以观察到，\ ``Step10/install``\ 目录现在已被填充了\ ``SimpleTest``\
的头文件和包文件。

现在我们可以像往常一样配置和构建Tutorial项目，导航到\
``Help/guide/Step10/TutorialProject``\ 并运行：

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

通过使用CTest运行测试来验证\ ``SimpleTest``\ 框架是否已正确加载。

解决方案
--------

首先，我们调用\ :command:`find_package`\ 来发现\ ``SimpleTest``\ 包。我们添加\
``REQUIRED``\ 参数是因为没有\ ``SimpleTest``，测试将无法构建。

.. raw:: html

  <details><summary>TODO 1点击显示/隐藏答案</summary>

.. literalinclude:: Step11/TutorialProject/Tests/CMakeLists.txt
  :caption: TODO 1: TutorialProject/Tests/CMakeLists.txt
  :name: TutorialProject/Tests/CMakeLists.txt-find_package
  :language: cmake
  :start-at: find_package
  :end-at: find_package

.. raw:: html

  </details>

接下来，我们将\ ``SimpleTest::SimpleTest``\ 目标添加到\ ``TestMathFunctions``\ 中

.. raw:: html

  <details><summary>TODO 2点击显示/隐藏答案</summary>

.. literalinclude:: Step11/TutorialProject/Tests/CMakeLists.txt
  :caption: TODO 2: TutorialProject/Tests/CMakeLists.txt
  :name: TutorialProject/Tests/CMakeLists.txt-link-simple-test
  :language: cmake
  :start-at: target_link_libraries(TestMathFunctions
  :end-at: )

.. raw:: html

  </details>

现在我们可以用对\ ``simpletest_discover_tests``\ 的调用来替换测试描述代码。

.. raw:: html

  <details><summary>TODO 3点击显示/隐藏答案</summary>

.. literalinclude:: Step11/TutorialProject/Tests/CMakeLists.txt
  :caption: TODO 3: TutorialProject/Tests/CMakeLists.txt
  :name: TutorialProject/Tests/CMakeLists.txt-simpletest_discover_tests
  :language: cmake
  :start-at: simpletest_discover_tests
  :end-at: simpletest_discover_tests

.. raw:: html

  </details>

我们通过将安装树添加到\ :variable:`CMAKE_PREFIX_PATH`\ 来确保\
:command:`find_package`\ 能够发现\ ``SimpleTest``。

.. raw:: html

  <details><summary>TODO 4点击显示/隐藏答案</summary>

.. literalinclude:: Step11/TutorialProject/CMakePresets.json
  :caption: TODO 4: TutorialProject/CMakePresets.json
  :name: TutorialProject/CMakePresets.json-CMAKE_PREFIX_PATH
  :language: json
  :start-at: cacheVariables
  :end-at: TUTORIAL_ENABLE_IPO
  :dedent: 6
  :append: }

.. raw:: html

  </details>

最后，我们通过移除占位符并包含适当的头文件来更新测试，以使用\ ``SimpleTest``\
提供的宏。

.. raw:: html

  <details><summary>TODO 5点击显示/隐藏答案</summary>

.. literalinclude:: Step11/TutorialProject/Tests/TestMathFunctions.cxx
  :caption: TODO 5: TutorialProject/Tests/TestMathFunctions.cxx
  :name: TutorialProject/Tests/TestMathFunctions.cxx-simpletest
  :language: c++
  :start-at: #include <MathFunctions.h>
  :end-at: {

.. raw:: html

  </details>

练习2 - 传递依赖
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

库通常是相互构建的。一个多媒体应用程序可能依赖于一个提供各种容器格式支持的库，\
而这个库又可能依赖于一个或多个其他库来提供压缩算法。

我们需要在放置在安装树中的包配置文件中表达这些传递性需求。我们通过\
:module:`CMakeFindDependencyMacro`\ 模块来实现，该模块提供了一种安全的机制，\
使已安装的包能够递归地发现彼此。

.. code-block:: cmake

  include(CMakeFindDependencyMacro)
  find_dependency(zlib)

:module:`find_dependency() <CMakeFindDependencyMacro>`\ 还会转发来自顶层\
:command:`find_package`\ 调用的参数。如果\ :command:`find_package`\ 调用时带有\
``QUIET``\ 或\ ``REQUIRED``，那么\ :module:`find_dependency() <CMakeFindDependencyMacro>`\
也会使用\ ``QUIET``\ 和/或\ ``REQUIRED``。

目标
----

向\ ``SimpleTest``\ 添加一个依赖项，并确保依赖于\ ``SimpleTest``\ 的包也能发现\
这个传递依赖。

参考资源
-----------------

* :module:`CMakeFindDependencyMacro`
* :command:`find_package`
* :command:`target_link_libraries`

待编辑文件
-------------

* ``SimpleTest/CMakeLists.txt``
* ``SimpleTest/cmake/SimpleTestConfig.cmake``

开始操作
---------------

在这一步中，我们将只编辑\ ``SimpleTest``\ 项目。传递性依赖\ ``TransitiveDep``\
是一个空依赖，它不提供任何行为。但是CMake并不知道这一点，如果CMake找不到所有必需\
的依赖项，\ ``TutorialProject``\ 测试将无法配置和构建。

``TransitiveDep``\ 包已经被安装到\ ``Step10/install``\ 树中。我们不需要像安装\
``SimpleTest``\ 那样再次安装它。

请完成\ ``TODO 6``\ 到\ ``TODO 8``。

构建和运行
-------------

我们需要重新安装SimpleTest框架。导航到\ ``Help/guide/Step10/SimpleTest``\ 目录\
并运行与之前相同的命令。

.. code-block:: console

  cmake --preset tutorial
  cmake --install build

现在我们可以重新配置并重建\ ``TutorialProject``，导航到\
``Help/guide/Step10/TutorialProject``\ 并执行通常的步骤来完成这一操作。

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

如果构建通过，我们很可能已经成功地传递了传递性依赖。通过在\ ``TutorialProject``\
的\ ``CMakeCache.txt``\ 中搜索名为\ ``TransitiveDep_DIR``\ 的条目来验证这一点。\
这表明即使\ ``TutorialProject``\ 没有对它的直接需求，它也搜索并找到了\
``TransitiveDep``。

解决方案
--------

首先，我们调用\ :command:`find_package`\ 来发现\ ``TransitiveDep``\ 包。我们使用\
``REQUIRED``\ 来验证我们已经找到了\ ``TransitiveDep``。

.. raw:: html

  <details><summary>TODO 6点击显示/隐藏答案</summary>

.. literalinclude:: Step11/SimpleTest/CMakeLists.txt
  :caption: TODO 6: SimpleTest/CMakeLists.txt
  :name: SimpleTest/CMakeLists.txt-find_package
  :language: cmake
  :start-at: find_package
  :end-at: find_package

.. raw:: html

  </details>

接下来，我们将\ ``TransitiveDep::TransitiveDep``\ 目标添加到\ ``SimpleTest``\ 中。

.. raw:: html

  <details><summary>TODO 7点击显示/隐藏答案</summary>

.. literalinclude:: Step11/SimpleTest/CMakeLists.txt
  :caption: TODO 7: SimpleTest/CMakeLists.txt
  :name: SimpleTest/CMakeLists.txt-link-transitive-dep
  :language: cmake
  :start-at: target_link_libraries(SimpleTest
  :end-at: )

.. raw:: html

  </details>

.. note::
  如果我们此时构建\ ``TutorialProject``，我们预计配置会失败，因为\
  ``TransitiveDep::TransitiveDep``\ 目标在该项目中不可用。

最后，我们在\ ``SimpleTest``\ 包配置文件中包含\ :module:`CMakeFindDependencyMacro`\
并调用\ :module:`find_dependency() <CMakeFindDependencyMacro>`，以传递依赖。

.. raw:: html

  <details><summary>TODO 8点击显示/隐藏答案</summary>

.. literalinclude:: Step11/SimpleTest/cmake/SimpleTestConfig.cmake
  :caption: TODO 8: SimpleTest/cmake/SimpleTestConfig.cmake
  :name: SimpleTest/cmake/SimpleTestConfig.cmake-find_dependency
  :language: cmake
  :start-at: include
  :end-at: find_dependency

.. raw:: html

  </details>

  </details>

Exercise 3 - Finding Other Kinds of Files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In a perfect world every dependency we care about would be packaged correctly,
or at least some other developer would have written a module that discovers it
for us. We do not live in a perfect world, and sometimes we will have to get
our hands dirty and discover build requirements manually.

For this we have the other find commands enumerated earlier in the step, such
as :command:`find_path`.

.. code-block:: cmake

  find_path(PackageIncludeFolder Package.h REQUIRED
    PATH_SUFFIXES
      Package
  )
  target_include_directories(MyApp
    PRIVATE
      ${PackageIncludeFolder}
  )

Goal
----

Add an unpackaged header to the ``Tutorial`` executable of the
``TutorialProject``.

Helpful Resources
-----------------

* :command:`find_path`
* :command:`target_include_directories`

Files to Edit
-------------

* ``TutorialProject/Tutorial/CMakeLists.txt``
* ``TutorialProject/Tutorial/Tutorial.cxx``

Getting Started
---------------

For this step we will only be editing the ``TutorialProject`` project. The
unpackaged header, ``Unpackaged/Unpackaged.h`` has already been installed to the
``Step10/install`` tree.

Complete ``TODO 9`` through ``TODO 11``.

Build and Run
-------------

There are no special build steps for this exercise, navigate to
``Help/guide/Step10/TutorialProject`` and perform the usual build.

.. code-block:: console

  cmake --build build

If the build passed we have successfully added the ``Unpackaged`` include
directory to the project.

Solution
--------

First we call :command:`find_path` to discover the ``Unpackaged`` include
directory. We use ``REQUIRED`` because building ``Tutorial`` will fail if
we cannot locate the ``Unpackaged.h`` header.

.. raw:: html

  <details><summary>TODO 9 Click to show/hide answer</summary>

.. literalinclude:: Step11/TutorialProject/Tutorial/CMakeLists.txt
  :caption: TODO 9: TutorialProject/Tutorial/CMakeLists.txt
  :name: TutorialProject/Tutorial/CMakeLists.txt-find_path
  :language: cmake
  :start-at: find_path
  :end-at: )

.. raw:: html

  </details>

Next we add the discovered path to ``Tutorial`` using
:command:`target_include_directories`.

.. raw:: html

  <details><summary>TODO 10 Click to show/hide answer</summary>

.. literalinclude:: Step11/TutorialProject/Tutorial/CMakeLists.txt
  :caption: TODO 10: TutorialProject/Tutorial/CMakeLists.txt
  :name: TutorialProject/Tutorial/CMakeLists.txt-target_include_directories
  :language: cmake
  :start-at: target_include_directories
  :end-at: )

.. raw:: html

  </details>

Finally, we edit ``Tutorial.cxx`` to include the discovered header.

.. raw:: html

  <details><summary>TODO 11 Click to show/hide answer</summary>

.. literalinclude:: Step11/TutorialProject/Tutorial/Tutorial.cxx
  :caption: TODO 11: TutorialProject/Tutorial/Tutorial.cxx
  :name: TutorialProject/Tutorial/Tutorial.cxx-include-unpackaged
  :language: c++
  :start-at: #include <MathFunctions.h>
  :end-at: #include <Unpackaged.h>

.. raw:: html

  </details>
