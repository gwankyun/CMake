步骤5: 安装和测试
==============================

.. _`Tutorial Testing Support`:

练习1 - 安装规则
^^^^^^^^^^^^^^^^^^^^^^^^^^

通常，仅仅构建可执行文件是不够的，它还应该是可安装的。使用CMake，我们可以使用\ :command:`install`\ 命令指定安装规则。\
在CMake中支持构建的本地安装通常非常简单，只需指定安装位置和要安装的目标和文件。

目标
----

安装\ ``Tutorial``\ 可执行文件和\ ``MathFunctions``\ 库。

有用的材料
-----------------

* :command:`install`

待编辑的文件
-------------

* ``MathFunctions/CMakeLists.txt``
* ``CMakeLists.txt``

开始
---------------

在\ ``Step5``\ 目录中提供了开始代码。在这个练习中，完成\ ``TODO 1``\ 到\ ``TODO 4``。

首先，更新\ ``MathFunctions/CMakeLists.txt``，\
将\ ``MathFunctions``\ 和\ ``tutorial_compiler_flags``\ 库安装到\ ``lib``\ 目录。\
在同一文件中，指定将\ ``MathFunctions.h``\ 安装到\ ``include``\ 目录所需的安装规则。

然后，更新顶层\ ``CMakeLists.txt``，将\ ``Tutorial``\ 可执行文件安装到\ ``bin``\ 目录。\
最后，任何头文件都应该安装到\ ``include``\ 目录中。\
记住\ ``TutorialConfig.h``\ 在\ :variable:`PROJECT_BINARY_DIR`\ 中。

构建并运行
-------------

创建一个名为\ ``Step5_build``\ 的新目录。\
运行\ :manual:`cmake <cmake(1)>`\ 可执行文件或\ :manual:`cmake-gui <cmake-gui(1)>`\ 来配置项目，\
然后使用你选择的构建工具构建它。

然后，在命令行中使用\ :manual:`cmake  <cmake(1)>`\ 命令（在3.15中引入，旧版本的CMake必须使用\ ``make install``）\
的\ :option:`--install <cmake --install>`\ 选项运行install步骤。这一步将安装适当的头文件、库和可执行文件。例如：

.. code-block:: console

  cmake --install .

对于多配置工具，不要忘记使用\ :option:`--config <cmake--build --config>`\ 参数来指定配置。

.. code-block:: console

  cmake --install . --config Release

如果使用IDE，只需构建\ ``INSTALL``\ 目标。你可以从命令行构建相同的安装目标，如下所示：

.. code-block:: console

  cmake --build . --target install --config Debug

CMake变量\ :variable:`CMAKE_INSTALL_PREFIX`\ 用于确定将安装文件的根目录。\
如果使用\ :option:`cmake --install`\ 命令，可以通过\ :option:`--prefix <cmake--install --prefix>`\ 参数覆盖安装前缀。例如：

.. code-block:: console

  cmake --install . --prefix "/home/myuser/installdir"

导航到安装目录，并验证已安装的\ ``Tutorial``\ 是否运行。

解决方案
--------

我们项目的安装规则相当简单：

* 对于\ ``MathFunctions``，我们希望将库和头文件分别安装到\ ``lib``\ 及\ ``include``\ 目录中。

* 对于\ ``Tutorial``\ 可执行文件，我们希望将可执行文件和配置的头文件分别安装到\ ``bin``\ 和\ ``include``\ 目录中。

因此，在\ ``MathFunctions/CMakeLists.txt``\ 的末尾，我们添加：

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. literalinclude:: Step6/MathFunctions/CMakeLists.txt
  :caption: TODO 1: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-install-TARGETS
  :language: cmake
  :start-after: # install libs
  :end-before: # install include headers

.. raw:: html

  </details>

和

.. raw:: html

  <details><summary>TODO 2: 点击显示/隐藏答案</summary>

.. literalinclude:: Step6/MathFunctions/CMakeLists.txt
  :caption: TODO 2: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-install-headers
  :language: cmake
  :start-after: # install include headers

.. raw:: html

  </details>

``Tutorial``\ 可执行文件和配置头文件的安装规则类似。在顶层\ ``CMakeLists.txt``\ 的末尾，我们添加：

.. raw:: html

  <details><summary>TODO 3,4: 点击显示/隐藏答案</summary>

.. literalinclude:: Step6/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: TODO 3,4: CMakeLists.txt-install-TARGETS
  :language: cmake
  :start-after: # 添加安装目标
  :end-before: # 启用测试

.. raw:: html

  </details>

这就是创建教程的基本本地安装所需要的全部内容。

练习2 - 测试支持
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

CTest提供了一种轻松管理项目测试的方法。可以通过\ :command:`add_test`\ 命令添加测试。\
虽然在本教程中没有明确介绍，但CTest和其他测试框架（:module:`GoogleTest`）之间有很多兼容性。

目标
----

使用CTest为我们的可执行文件创建单元测试。

有用的材料
-----------------

* :command:`enable_testing`
* :command:`add_test`
* :command:`function`
* :command:`set_tests_properties`
* :manual:`ctest <ctest(1)>`

待编辑的文件
-------------

* ``CMakeLists.txt``

开始
---------------

在\ ``Step5``\ 目录中提供了起始源代码。在这个练习中，完成\ ``TODO 5``\ 到\ ``TODO 9``。

首先，我们需要启用测试。接下来，开始使用\ :command:`add_test`\ 向我们的项目添加测试。\
我们将添加3个简单的测试，然后你可以根据需要添加额外的测试。

构建并运行
-------------

导航到构建目录并重新构建应用程序。然后，运行\ ``ctest``\ 可执行文件：:option:`ctest -N`\ 和\ :option:`ctest -VV`。\
对于多配置生成器（例如Visual Studio），配置类型必须用\ :option:`-C \<mode\> <ctest -C>`\ 标志指定。\
例如，要在调试模式下运行测试，请从构建目录（而不是Debug子目录！）使用\ ``ctest -C Debug -VV``。\
Release模式将从相同的位置执行，但使用\ ``-C Release``。或者，从IDE构建\ ``RUN_TESTS``\ 目标。

解决方案
--------

Let's test our application. At the end of the top-level ``CMakeLists.txt``
file we first need to enable testing with the
:command:`enable_testing` command.

.. raw:: html

  <details><summary>TODO 5: 点击显示/隐藏答案</summary>

.. literalinclude:: Step6/CMakeLists.txt
  :caption: TODO 5: CMakeLists.txt
  :name: CMakeLists.txt-enable_testing
  :language: cmake
  :start-after: # 启用测试
  :end-before: # 程序是否运行

.. raw:: html

  </details>

With testing enabled, we will add a number of basic tests to verify
that the application is working correctly. First, we create a test using
:command:`add_test` which runs the ``Tutorial`` executable with the
parameter 25 passed in. For this test, we are not going to check the
executable's computed answer. This test will verify that
application runs, does not segfault or otherwise crash, and has a zero
return value. This is the basic form of a CTest test.

.. raw:: html

  <details><summary>TODO 6: 点击显示/隐藏答案</summary>

.. literalinclude:: Step6/CMakeLists.txt
  :caption: TODO 6: CMakeLists.txt
  :name: CMakeLists.txt-test-runs
  :language: cmake
  :start-after: # 程序是否运行
  :end-before: # 用例输出有效吗？

.. raw:: html

  </details>

Next, let's use the :prop_test:`PASS_REGULAR_EXPRESSION` test property to
verify that the output of the test contains certain strings. In this case,
verifying that the usage message is printed when an incorrect number of
arguments are provided.

.. raw:: html

  <details><summary>TODO 7: 点击显示/隐藏答案</summary>

.. literalinclude:: Step6/CMakeLists.txt
  :caption: TODO 7: CMakeLists.txt
  :name: CMakeLists.txt-test-usage
  :language: cmake
  :start-after: # 用例输出有效吗？
  :end-before: # 定义一个函数来简化添加测试

.. raw:: html

  </details>

The next test we will add verifies the computed value is truly the
square root.

.. raw:: html

  <details><summary>TODO 8: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 8: CMakeLists.txt
  :name: CMakeLists.txt-test-standard

  add_test(NAME StandardUse COMMAND Tutorial 4)
  set_tests_properties(StandardUse
    PROPERTIES PASS_REGULAR_EXPRESSION "4 is 2"
    )

.. raw:: html

  </details>

This one test is not enough to give us confidence that it will
work for all values passed in. We should add more tests to verify this.
To easily add more tests, we make a function called ``do_test`` that runs the
application and verifies that the computed square root is correct for
given input. For each invocation of ``do_test``, another test is added to
the project with a name, input, and expected results based on the passed
arguments.

.. raw:: html

  <details><summary>TODO 9: 点击显示/隐藏答案</summary>

.. literalinclude:: Step6/CMakeLists.txt
  :caption: TODO 9: CMakeLists.txt
  :name: CMakeLists.txt-generalized-tests
  :language: cmake
  :start-after: # 定义一个函数来简化添加测试

.. raw:: html

  </details>
