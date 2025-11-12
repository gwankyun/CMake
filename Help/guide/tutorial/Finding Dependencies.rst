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

Build and Run
-------------

First we must install the ``SimpleTest`` framework. Navigate to the
``Help/guide/Step10/SimpleTest`` directory and run the following commands

.. code-block:: console

  cmake --preset tutorial
  cmake --install build

.. note::
  The ``SimpleTest`` preset sets up everything needed to install ``SimpleTest``
  for the tutorial. For reasons that are beyond the scope of this tutorial,
  there is no need to build or provide any other configuration for
  ``SimpleTest``.

We can observe that the ``Step10/install`` directory has now been populated by
the ``SimpleTest`` header and package files.

Now we can configure and build the Tutorial project as per usual, navigating to
the ``Help/guide/Step10/TutorialProject`` and running:

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

Verify that the ``SimpleTest`` framework has been consumed correctly by running
the tests with CTest.

Solution
--------

First we call :command:`find_package` to discover the ``SimpleTest`` package.
We do this with ``REQUIRED`` because the tests cannot build without
``SimpleTest``.

.. raw:: html

  <details><summary>TODO 1 Click to show/hide answer</summary>

.. literalinclude:: Step11/TutorialProject/Tests/CMakeLists.txt
  :caption: TODO 1: TutorialProject/Tests/CMakeLists.txt
  :name: TutorialProject/Tests/CMakeLists.txt-find_package
  :language: cmake
  :start-at: find_package
  :end-at: find_package

.. raw:: html

  </details>

Next we add the ``SimpleTest::SimpleTest`` target to ``TestMathFunctions``

.. raw:: html

  <details><summary>TODO 2 Click to show/hide answer</summary>

.. literalinclude:: Step11/TutorialProject/Tests/CMakeLists.txt
  :caption: TODO 2: TutorialProject/Tests/CMakeLists.txt
  :name: TutorialProject/Tests/CMakeLists.txt-link-simple-test
  :language: cmake
  :start-at: target_link_libraries(TestMathFunctions
  :end-at: )

.. raw:: html

  </details>

Now we can replace our test description code with a call to
``simpletest_discover_tests``.

.. raw:: html

  <details><summary>TODO 3 Click to show/hide answer</summary>

.. literalinclude:: Step11/TutorialProject/Tests/CMakeLists.txt
  :caption: TODO 3: TutorialProject/Tests/CMakeLists.txt
  :name: TutorialProject/Tests/CMakeLists.txt-simpletest_discover_tests
  :language: cmake
  :start-at: simpletest_discover_tests
  :end-at: simpletest_discover_tests

.. raw:: html

  </details>

We ensure :command:`find_package` can discover ``SimpleTest`` by
adding the install tree to :variable:`CMAKE_PREFIX_PATH`.

.. raw:: html

  <details><summary>TODO 4 Click to show/hide answer</summary>

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

Finally, we update the tests to use the macros provided by ``SimpleTest`` by
removing the placeholders and including the appropriate header.

.. raw:: html

  <details><summary>TODO 5 Click to show/hide answer</summary>

.. literalinclude:: Step11/TutorialProject/Tests/TestMathFunctions.cxx
  :caption: TODO 5: TutorialProject/Tests/TestMathFunctions.cxx
  :name: TutorialProject/Tests/TestMathFunctions.cxx-simpletest
  :language: c++
  :start-at: #include <MathFunctions.h>
  :end-at: {

.. raw:: html

  </details>

Exercise 2 - Transitive Dependencies
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Libraries often build on one another. A multimedia application may depend on a
library which provides support for various container formats, which may in turn
rely on one or more other libraries for compression algorithms.

We need to express these transitive requirements inside the package config
files we place in the install tree. We do so with the
:module:`CMakeFindDependencyMacro` module, which provides a safe mechanism for
installed packages to recursively discover one another.

.. code-block:: cmake

  include(CMakeFindDependencyMacro)
  find_dependency(zlib)

:module:`find_dependency() <CMakeFindDependencyMacro>` also forwards arguments
from the top-level :command:`find_package` call. If :command:`find_package` is
called with ``QUIET`` or ``REQUIRED``,
:module:`find_dependency() <CMakeFindDependencyMacro>` will also use ``QUIET``
and/or ``REQUIRED``.

Goal
----

Add a dependency to ``SimpleTest`` and ensure that packages which rely on
``SimpleTest`` also discover this transitive dependency.

Helpful Resources
-----------------

* :module:`CMakeFindDependencyMacro`
* :command:`find_package`
* :command:`target_link_libraries`

Files to Edit
-------------

* ``SimpleTest/CMakeLists.txt``
* ``SimpleTest/cmake/SimpleTestConfig.cmake``

Getting Started
---------------

For this step we will only be editing the ``SimpleTest`` project. The transitive
dependency, ``TransitiveDep``, is a dummy dependency which provides no behavior.
However CMake doesn't know this and the ``TutorialProject`` tests will fail to
configure and build if CMake cannot find all required dependencies.

The ``TransitiveDep`` package has already been installed to the
``Step10/install`` tree. We do not need to install it as we did with
``SimpleTest``.

Complete ``TODO 6`` through ``TODO 8``.

Build and Run
-------------

We need to reinstall the SimpleTest framework. Navigate to the
``Help/guide/Step10/SimpleTest`` directory and run the same commands as before.

.. code-block:: console

  cmake --preset tutorial
  cmake --install build

Now we can reconfigure and rebuild the ``TutorialProject``, navigate to
``Help/guide/Step10/TutorialProject`` and perform the usual steps to do so.

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

If the build passed we have likely successfully propagated the transitive
dependency. Verify this by searching the ``CMakeCache.txt`` of
``TutorialProject`` for an entry named ``TransitiveDep_DIR``. This demonstrates
the ``TutorialProject`` searched for an found ``TransitiveDep`` even though it
has no direct requirement for it.

Solution
--------

First we call :command:`find_package` to discover the ``TransitiveDep`` package.
We use ``REQUIRED`` to verify we have found ``TransitiveDep``.

.. raw:: html

  <details><summary>TODO 6 Click to show/hide answer</summary>

.. literalinclude:: Step11/SimpleTest/CMakeLists.txt
  :caption: TODO 6: SimpleTest/CMakeLists.txt
  :name: SimpleTest/CMakeLists.txt-find_package
  :language: cmake
  :start-at: find_package
  :end-at: find_package

.. raw:: html

  </details>

Next we add the ``TransitiveDep::TransitiveDep`` target to ``SimpleTest``.

.. raw:: html

  <details><summary>TODO 7 Click to show/hide answer</summary>

.. literalinclude:: Step11/SimpleTest/CMakeLists.txt
  :caption: TODO 7: SimpleTest/CMakeLists.txt
  :name: SimpleTest/CMakeLists.txt-link-transitive-dep
  :language: cmake
  :start-at: target_link_libraries(SimpleTest
  :end-at: )

.. raw:: html

  </details>

.. note::
  If we built ``TutorialProject`` at this point, we would expect the
  configuration to fail due to the ``TransitiveDep::TransitiveDep`` target
  being unavailable inside that project.

Finally, we include the :module:`CMakeFindDependencyMacro` and call
:module:`find_dependency() <CMakeFindDependencyMacro>` inside the ``SimpleTest``
package config file to propagate the transitive dependency.

.. raw:: html

  <details><summary>TODO 8 Click to show/hide answer</summary>

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
