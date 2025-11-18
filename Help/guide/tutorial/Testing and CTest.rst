步骤8：测试和CTest
=========================

从历史上看，测试并非构建系统的职责。它最多可能有一个特定目标，用于构建和运行项目的测试。

而在CMake生态系统中，情况恰恰相反。CMake的测试生态系统称为CTest。这个生态系统看\
似简单，实则功能强大。事实上，它如此强大，以至于值得拥有自己的完整教程来描述我们\
可以用它实现的所有功能。

但本教程并非如此。在这一步中，我们将简单介绍CTest提供的一些功能。

背景
^^^^^^^^^^

从根本上讲，CTest是一个任务启动器，它运行命令并报告它们返回的是零值还是非零值。\
这就是我们将要处理CTest的层面。

CMake通过\ :command:`enable_testing`\ 和\ :command:`add_test`\ 命令提供与CTest的\
直接集成。这些命令允许CMake在构建文件夹中设置必要的基础设施，以便CTest发现、\
运行和报告我们可能感兴趣的各类测试。

在设置并构建测试之后，调用CTest最简单的方法是直接在构建目录上运行它：

.. code-block:: console

  ctest --test-dir build

这将运行所有可用的测试。可以通过正则表达式运行特定测试。

.. code-block:: console

  ctest --test-dir build -R SpecificTest

CTest还具有用于脚本、夹具、清理器、作业服务器、度量报告等的高级机制。更多信息请\
参见\ :manual:`ctest(1)`\ 手册。

Exercise 1 - Adding Tests
^^^^^^^^^^^^^^^^^^^^^^^^^

CTest convention dictates the building and running of tests be based on a
default-``ON`` variable named :variable:`BUILD_TESTING`. When using the full
suite of CTest capabilities via the :module:`CTest` module, this
:command:`option` is setup for us. When using a more stripped-down approach to
testing, it's expected the project will setup the option (or at least one of a
similar name) on its own.

When :variable:`BUILD_TESTING` is true, the :command:`enable_testing` command
should be called in the root CML.

.. code-block:: cmake

  enable_testing()

This will generate all the necessary metadata into the build tree for CTest to
find and run tests.

Once that has been done, the :command:`add_test` command can be used to create
a test anywhere in the project. The semantics of this command are similar to
:command:`add_custom_command`; we can name an executable target as the "command".

.. code-block:: cmake

  add_test(
    NAME MyAppWithTestFlag
    COMMAND MyApp --test
  )

Goal
----

Add tests for the MathFunctions library to the project and run them with CTest.

Helpful Resources
-----------------

* :variable:`BUILD_TESTING`
* :command:`enable_testing`
* :command:`function`
* :command:`add_test`

Files to Edit
-------------

* ``Tests/CMakeLists.txt``
* ``CMakeLists.txt``

Getting Started
---------------

A testing program has been written in the file ``Tests/TestMathFunctions.cxx``.
This program takes a single command line argument, the math function to be
tested, with valid values of ``add``, ``mul``, ``sqrt``, and ``sub``. The return
code is zero if the operation is recognized and the calculated value is valid,
otherwise it is non-zero.

Complete ``TODO 1`` through ``TODO 7``.

Build and Run
-------------

No special configuration is needed, configure and build as usual.

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

Verify all the tests pass with CTest.

.. note::

  If using a multi-config generator, eg Visual Studio, it will be necessary to
  specify a configuration with ``ctest -C <config> <remaining flags>``, where
  ``<config>`` is a value like ``Debug`` or ``Release``. This is true whenever
  using a multi-config generator, and won't be called out specifically in
  future commands.

.. code-block:: console

  ctest --test-dir build

You can run individual tests with the :option:`-R <ctest -R>` flag.

.. code-block:: console

  ctest --test-dir build -R sqrt

Solution
--------

First we add a new executable for the tests.

.. raw:: html

  <details><summary>TODO 1-2: Click to show/hide answer</summary>

.. literalinclude:: Step9/Tests/CMakeLists.txt
  :caption: TODO 1-2: Tests/CMakeLists.txt
  :name: Tests/CMakeLists.txt-add_executable
  :language: cmake
  :start-at: add_executable
  :end-at: TestMathFunctions.cxx
  :append: )

.. raw:: html

  </details>

Then we link in the library we are testing.

.. raw:: html

  <details><summary>TODO 3: Click to show/hide answer</summary>

.. literalinclude:: Step9/Tests/CMakeLists.txt
  :caption: TODO 3: Tests/CMakeLists.txt
  :name: Tests/CMakeLists.txt-target_link_libraries
  :language: cmake
  :start-at: target_link_libraries(TestMathFunctions
  :end-at: )

.. raw:: html

  </details>

We need to call :command:`add_test` for each of the valid operations, but this
would get repetitive, so we write a :command:`function` to do it for us.

.. raw:: html

  <details><summary>TODO 4: Click to show/hide answer</summary>

.. literalinclude:: Step9/Tests/CMakeLists.txt
  :caption: TODO 4: Tests/CMakeLists.txt
  :name: Tests/CMakeLists.txt-function
  :language: cmake
  :start-at: function
  :end-at: endfunction

.. raw:: html

  </details>

Now we can use our :command:`function` to add all the tests.

.. raw:: html

  <details><summary>TODO 5: Click to show/hide answer</summary>

.. literalinclude:: Step9/Tests/CMakeLists.txt
  :caption: TODO 5: Tests/CMakeLists.txt
  :name: Tests/CMakeLists.txt-add_test
  :language: cmake
  :start-at: MathFunctionTest(add
  :end-at: MathFunctionTest(sub

.. raw:: html

  </details>

Finally, we can add the :variable:`BUILD_TESTING` option and conditionally
enable building and running tests in the top-level CML.

.. raw:: html

  <details><summary>TODO 6-7: Click to show/hide answer</summary>

.. literalinclude:: Step9/CMakeLists.txt
  :caption: TODO 6: CMakeLists.txt
  :name: CMakeLists.txt-BUILD_TESTING
  :language: cmake
  :start-at: option(BUILD_TESTING
  :end-at: option(BUILD_TESTING

.. literalinclude:: Step9/CMakeLists.txt
  :caption: TODO 7: CMakeLists.txt
  :name: CMakeLists.txt-enable_testing
  :language: cmake
  :start-at: if(BUILD_TESTING)
  :end-at: endif()

.. raw:: html

  </details>
