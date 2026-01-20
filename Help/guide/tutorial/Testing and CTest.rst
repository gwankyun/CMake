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

练习1 - 添加测试
^^^^^^^^^^^^^^^^^^^^^^^^^

CTest约定规定，测试的构建和运行应基于一个默认值为\ ``ON``\ 的变量，名为\
:variable:`BUILD_TESTING`。当通过\ :module:`CTest`\ 模块使用完整的CTest功能套件时，\
会自动为我们设置此\ :command:`option`。当使用更简化的测试方法时，预期项目会自行\
设置该选项（或至少一个类似名称的选项）。

当\ :variable:`BUILD_TESTING`\ 为true时，应在根CMakeLists.txt中调用\
:command:`enable_testing`\ 命令。

.. code-block:: cmake

  enable_testing()

这将在构建树中生成CTest查找和运行测试所需的所有必要元数据。

完成上述操作后，可以在项目的任何位置使用\ :command:`add_test`\ 命令创建测试。\
此命令的语义与\ :command:`add_custom_command`\ 类似；我们可以将可执行目标命名为\
“command”。

.. code-block:: cmake

  add_test(
    NAME MyAppWithTestFlag
    COMMAND MyApp --test
  )

目标
----

为MathFunctions库添加测试，并使用CTest运行这些测试。

参考资源
-----------------

* :variable:`BUILD_TESTING`
* :command:`enable_testing`
* :command:`function`
* :command:`add_test`

待编辑文件
-------------

* ``Tests/CMakeLists.txt``
* ``CMakeLists.txt``

开始操作
---------------

测试程序已编写在\ ``Tests/TestMathFunctions.cxx``\ 文件中。该程序接受一个命令行\
参数，即要测试的数学函数，有效值为\ ``add``、\ ``mul``、\ ``sqrt``\ 和\ ``sub``。\
如果操作被识别且计算值有效，则返回码为零，否则为非零。

完成\ ``TODO 1``\ 至\ ``TODO 7``。

构建和运行
-------------

不需要特殊配置，像往常一样配置和构建即可。

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

使用CTest验证所有测试通过。

.. note::

  如果使用多配置生成器（例如Visual Studio），则需要使用\
  ``ctest -C <config> <remaining flags>``\ 指定配置，其中\ ``<config>``\ 是类似\
  ``Debug``\ 或\ ``Release``\ 的值。无论何时使用多配置生成器，都需要这样做，\
  后续命令中不会特别指出这一点。

.. code-block:: console

  ctest --test-dir build

你可以使用\ :option:`-R <ctest -R>`\ 标志运行单个测试。

.. code-block:: console

  ctest --test-dir build -R sqrt

解决方案
--------

首先，我们为测试添加一个新的可执行文件。

.. raw:: html

  <details><summary>TODO 1-2: 点击显示/隐藏答案</summary>

.. literalinclude:: Step9/Tests/CMakeLists.txt
  :caption: TODO 1-2: Tests/CMakeLists.txt
  :name: Tests/CMakeLists.txt-add_executable
  :language: cmake
  :start-at: add_executable
  :end-at: TestMathFunctions.cxx
  :append: )

.. raw:: html

  </details>

然后，我们链接要测试的库。

.. raw:: html

  <details><summary>TODO 3: 点击显示/隐藏答案</summary>

.. literalinclude:: Step9/Tests/CMakeLists.txt
  :caption: TODO 3: Tests/CMakeLists.txt
  :name: Tests/CMakeLists.txt-target_link_libraries
  :language: cmake
  :start-at: target_link_libraries(TestMathFunctions
  :end-at: )

.. raw:: html

  </details>

我们需要为每个有效的操作调用\ :command:`add_test`\ 命令，但这会变得重复，因此\
我们编写一个\ :command:`function`\ 函数来为我们完成这项工作。

.. raw:: html

  <details><summary>TODO 4: 点击显示/隐藏答案</summary>

.. literalinclude:: Step9/Tests/CMakeLists.txt
  :caption: TODO 4: Tests/CMakeLists.txt
  :name: Tests/CMakeLists.txt-function
  :language: cmake
  :start-at: function
  :end-at: endfunction

.. raw:: html

  </details>

现在我们可以使用我们的\ :command:`function`\ 函数来添加所有测试。

.. raw:: html

  <details><summary>TODO 5: 点击显示/隐藏答案</summary>

.. literalinclude:: Step9/Tests/CMakeLists.txt
  :caption: TODO 5: Tests/CMakeLists.txt
  :name: Tests/CMakeLists.txt-add_test
  :language: cmake
  :start-at: MathFunctionTest(add
  :end-at: MathFunctionTest(sub

.. raw:: html

  </details>

最后，我们可以在顶层CMakeLists.txt中添加\ :variable:`BUILD_TESTING`\ 选项，并有\
条件地启用测试的构建和运行。

.. raw:: html

  <details><summary>TODO 6-7: 点击显示/隐藏答案</summary>

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
