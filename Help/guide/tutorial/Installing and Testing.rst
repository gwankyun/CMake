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
发布模式将从相同的位置执行，但使用\ ``-C Release``。或者，从IDE构建\ ``RUN_TESTS``\ 目标。

解决方案
--------

让我们测试我们的应用程序。在顶层\ ``CMakeLists.txt``\ 文件的末尾，我们首先需要使用\ :command:`enable_testing`\ 命令启用测试。

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

启用测试后，我们将添加一些基本测试，以验证应用程序是否正常工作。\
首先，我们使用\ :command:`add_test`\ 创建一个测试，该测试运行带有传入参数25的\ ``Tutorial``\ 可执行文件。\
对于这个测试，我们不打算检查可执行文件的计算结果。该测试将验证应用程序运行，没有分段故障或崩溃，并且返回值为零。\
这是CTest测试的基本形式。

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

接下来，让我们使用\ :prop_test:`PASS_REGULAR_EXPRESSION`\ 测试属性来验证测试的输出是否包含某些字符串。\
在本例中，当提供的参数数量不正确时，验证是否打印了usage消息。

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

我们将添加的下一个测试验证计算值确实是平方根。

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

这个测试不足以让我们相信它对所有传入的值都有效。我们应该增加更多的测试来验证这一点。\
为了方便地添加更多测试，我们创建了一个名为\ ``do_test``\ 的函数，\
该函数运行应用程序并验证计算的平方根对于给定输入是否正确。对于\ ``do_test``\ 的每次调用，\
都会向项目中添加另一个测试，其中包含名称、输入和基于传递的参数的预期结果。

.. raw:: html

  <details><summary>TODO 9: 点击显示/隐藏答案</summary>

.. literalinclude:: Step6/CMakeLists.txt
  :caption: TODO 9: CMakeLists.txt
  :name: CMakeLists.txt-generalized-tests
  :language: cmake
  :start-after: # 定义一个函数来简化添加测试

.. raw:: html

  </details>
