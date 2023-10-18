步骤3：添加库的使用需求
===============================================

练习1 - 为库添加使用需求
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

目标参数的\ :ref:`使用需求 <Target Usage Requirements>`\ 允许对库或可执行文件的link和\
include行进行更好的控制，同时也可以对CMake内部目标的传递属性进行更多的控制。利用使用需求的\
主要命令有：

* :command:`target_compile_definitions`
* :command:`target_compile_options`
* :command:`target_include_directories`
* :command:`target_link_directories`
* :command:`target_link_options`
* :command:`target_precompile_headers`
* :command:`target_sources`


目标
----

为库添加使用需求。

有用的材料
-----------------

* :variable:`CMAKE_CURRENT_SOURCE_DIR`

待编辑的文件
-------------

* ``MathFunctions/CMakeLists.txt``
* ``CMakeLists.txt``

开始
---------------

在本练习中，我们将使用现代的CMake方法重构\ :guide:`添加库 <tutorial/Adding a Library>`\
中的代码。我们将让我们的库定义自己的使用需求，以便在必要时将它们传递给其他目标。在本例中，\
``MathFunctions``\ 将自己指定任何所需的include目录。然后，消费目标\ ``Tutorial``\ 只\
需要链接到\ ``MathFunctions``，而不用担心任何额外的包含目录。

在\ ``Step3``\ 目录中提供了起始源代码。在这个练习中，完成\ ``TODO 1``\ 到\ ``TODO 3``。

首先，在\ ``MathFunctions/CMakeLists``\ 中添加对\ :command:`target_include_directories`\
的调用。请记住，:variable:`CMAKE_CURRENT_SOURCE_DIR`\ 是当前正在处理的源目录的路径。

然后，更新（并简化！）顶层\ ``CMakeLists.txt``\ 中对\
:command:`target_include_directories`\ 的调用。

构建并运行
-------------

创建一个名为\ ``Step3_build``\ 的新目录，\
运行\ :manual:`cmake <cmake(1)>`\ 可执行文件或\ :manual:`cmake-gui <cmake-gui(1)>`\
来配置项目，然后使用你选择的构建工具或使用\ :option:`cmake --build . <cmake --build>`\
来从构建目录构建它。下面是命令行的更新：

.. code-block:: console

  mkdir Step3_build
  cd Step3_build
  cmake ../Step3
  cmake --build .

接下来，使用新构建的\ ``Tutorial``\ 并验证它是否按预期工作。

解决方案
--------

让我们更新上一步中的代码，以使用现代CMake方法来满足使用需求。

我们想声明的是，任何链接到\ ``MathFunctions``\ 的人都需要包含当前源目录，而\
``MathFunctions``\ 本身则不需要。这可以用\ ``INTERFACE``\ 使用需求来表示。记住，\
``INTERFACE``\ 指的是消费者需要但生产者不需要的东西。

在\ ``MathFunctions/CMakeLists.txt``\ 的末尾，使用带\ ``INTERFACE``\ 关键字的\
:command:`target_include_directories`，如下所示：

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. literalinclude:: Step4/MathFunctions/CMakeLists.txt
  :caption: TODO 1: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-target_include_directories-INTERFACE
  :language: cmake
  :start-after: # 以便查找MathFunctions.h
  :end-before: # should we use our own

.. raw:: html

  </details>

既然我们已经指定了\ ``MathFunctions``\ 的使用要求，就可以安全地从顶层文件\
``CMakeLists.txt``\ 中删除\ ``EXTRA_INCLUDES``\ 变量了。

删除这一行：

.. raw:: html

  <details><summary>TODO 2: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/CMakeLists.txt
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-remove-EXTRA_INCLUDES
  :language: cmake
  :start-after: add_subdirectory(MathFunctions)
  :end-before: # 添加可执行文件

.. raw:: html

  </details>

并从\ ``target_include_directories``\ 中删除\ ``EXTRA_INCLUDES``\ ：

.. raw:: html

  <details><summary>TODO 3: 点击显示/隐藏答案</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: TODO 3: CMakeLists.txt
  :name: CMakeLists.txt-target_include_directories-remove-EXTRA_INCLUDES
  :language: cmake
  :start-after: # 以便找到TutorialConfig.h

.. raw:: html

  </details>

注意，使用这种技术，我们的可执行目标使用我们的库所做的唯一事情就是用库目标的名称调用\
:command:`target_link_libraries`。在较大的项目中，手动指定库依赖项的经典方法很快就会变\
得非常复杂。

练习2 - 用接口库设置C++标准
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

既然我们已经将代码转换为更现代的方法，那么让我们演示一种为多个目标设置属性的现代技术。

让我们重构现有代码以使用\ ``INTERFACE``\ 库。我们将在下一步中使用该库来演示\
:manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 的常见用法。

目标
----

添加一个\ ``INTERFACE``\ 库目标来指定所需的C++标准。

有用的资源
-----------------

* :command:`add_library`
* :command:`target_compile_features`
* :command:`target_link_libraries`

待编辑的文件
-------------

* ``CMakeLists.txt``
* ``MathFunctions/CMakeLists.txt``

开始
---------------

在本练习中，我们将重构代码，使用\ ``INTERFACE``\ 库指定C++标准。

从我们在步骤3练习1结束时留下的内容开始这个练习。你必须完成\ ``TODO 4``\ 到\ ``TODO 7``。

首先编辑顶层的\ ``CMakeLists.txt``\ 文件。构造一个名为\ ``tutorial_compiler_flags``\
的\ ``INTERFACE``\ 库目标，并指定\ ``cxx_std_11``\ 作为目标编译器特性。

修改\ ``CMakeLists.txt``\ 和\ ``MathFunctions/CMakeLists.txt``，以便所有目标都有一个\
:command:`target_link_libraries`\ 调用\ ``tutorial_compiler_flags``。

构建并运行
-------------

由于我们已经在练习1中配置了构建目录，只需通过调用以下命令重新构建代码：

.. code-block:: console

  cd Step3_build
  cmake --build .

接下来，使用新构建的\ ``Tutorial``\ 并验证它是否按预期工作。

解决方案
--------

让我们更新上一步的代码，使用接口库来设置C++需求。

首先，我们需要删除变量\ :variable:`CMAKE_CXX_STANDARD`\ 和\
:variable:`CMAKE_CXX_STANDARD_REQUIRED`\ 上的两个\ :command:`set`\ 调用。具体要删除\
的行如下：

.. literalinclude:: Step3/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-CXX_STANDARD-variable-remove
  :language: cmake
  :start-after: # 指定C++标准
  :end-before: # configure a header file

接下来，我们需要创建一个接口库\ ``tutorial_compiler_flags``。然后使用\
:command:`target_compile_features`\ 来添加编译器特性\ ``cxx_std_11``。


.. raw:: html

  <details><summary>TODO 4: 点击显示/隐藏答案</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: TODO 4: CMakeLists.txt
  :name: CMakeLists.txt-cxx_std-feature
  :language: cmake
  :start-after: # specify the C++ standard
  :end-before: # TODO 2: Create helper

.. raw:: html

  </details>

最后，设置好接口库后，我们需要将可执行\ ``Tutorial``、\ ``SqrtLibrary``\ 库和\
``MathFunctions``\ 库链接到新的\ ``tutorial_compiler_flags``\ 库。分别，代码分别如下\
这样：

.. raw:: html

  <details><summary>TODO 5: 点击显示/隐藏答案</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: TODO 5: CMakeLists.txt
  :name: CMakeLists.txt-target_link_libraries-step4
  :language: cmake
  :start-after: add_executable(Tutorial tutorial.cxx)
  :end-before: # 添加二进制树到引用目录的搜索路径

.. raw:: html

  </details>

这样：

.. raw:: html

  <details><summary>TODO 6: 点击显示/隐藏答案</summary>

.. literalinclude:: Step4/MathFunctions/CMakeLists.txt
  :caption: TODO 6: MathFunctions/CMakeLists.txt
  :name: MathFunctions-CMakeLists.txt-target_link_libraries-step4
  :language: cmake
  :start-after: # link SqrtLibrary to tutorial_compiler_flags
  :end-before: target_link_libraries(MathFunctions

.. raw:: html

  </details>

和这样：

.. raw:: html

  <details><summary>TODO 7: 点击显示/隐藏答案</summary>

.. literalinclude:: Step4/MathFunctions/CMakeLists.txt
  :caption: TODO 7: MathFunctions/CMakeLists.txt
  :name: MathFunctions-SqrtLibrary-target_link_libraries-step4
  :language: cmake
  :start-after: # link MathFunctions to tutorial_compiler_flags

.. raw:: html

  </details>


尽管如此，我们所有的代码仍然需要C++11来构建。注意，使用这种方法，我们可以明确哪些目标需要特\
定的需求。此外，我们在接口库中创建了一个单一的事实来源。
