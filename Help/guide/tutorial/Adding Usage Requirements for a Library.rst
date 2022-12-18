步骤3：添加库的使用需求
===============================================

练习1 - 为库添加使用需求
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

目标参数的\ :ref:`Usage requirements <Target Usage Requirements>`\ 允许对库或可执行文件的link和include行进行更好的控制，\
同时也可以对CMake内部目标的传递属性进行更多的控制。利用使用需求的主要命令有：

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

在本练习中，我们将使用现代的CMake方法重构\ :guide:`tutorial/Adding a Library`\ 中的代码。\
我们将让我们的库定义自己的使用需求，以便在必要时将它们传递给其他目标。\
在本例中，\ ``MathFunctions``\ 将自己指定任何所需的include目录。\
然后，消费目标\ ``Tutorial``\ 只需要链接到\ ``MathFunctions``，而不用担心任何额外的包含目录。

在\ ``Step3``\ 目录中提供了起始源代码。在这个练习中，完成\ ``TODO 1``\ 到\ ``TODO 3``。

首先，在\ ``MathFunctions/CMakeLists``\ 中添加对\ :command:`target_include_directories`\ 的调用。\
请记住，:variable:`CMAKE_CURRENT_SOURCE_DIR`\ 是当前正在处理的源目录的路径。

然后，更新（并简化！）顶层\ ``CMakeLists.txt``\ 中对\ :command:`target_include_directories`\ 的调用。

构建并运行
-------------

创建一个名为\ ``Step3_build``\ 的新目录，\
运行\ :manual:`cmake <cmake(1)>`\ 可执行文件或\ :manual:`cmake-gui <cmake-gui(1)>`\ 来配置项目，\
然后使用你选择的构建工具或使用\ :option:`cmake --build . <cmake --build>`\ 来从构建目录构建它。\
下面是命令行的更新：

.. code-block:: console

  mkdir Step3_build
  cd Step3_build
  cmake ../Step3
  cmake --build .

接下来，使用新构建的\ ``Tutorial``\ 并验证它是否按预期工作。

解决方案
--------

让我们更新上一步中的代码，以使用现代CMake方法来满足使用需求。

我们想声明的是，任何链接到\ ``MathFunctions``\ 的人都需要包含当前源目录，\
而\ ``MathFunctions``\ 本身则不需要。这可以用\ ``INTERFACE``\ 使用需求来表示。\
记住，\ ``INTERFACE``\ 指的是消费者需要但生产者不需要的东西。

在\ ``MathFunctions/CMakeLists.txt``\ 的末尾，\
使用带\ ``INTERFACE``\ 关键字的\ :command:`target_include_directories`，如下所示：

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. literalinclude:: Step4/MathFunctions/CMakeLists.txt
  :caption: TODO 1: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-target_include_directories-INTERFACE
  :language: cmake
  :start-after: # 以便查找MathFunctions.h
  :end-before: # TODO 3: Link to

.. raw:: html

  </details>

既然我们已经指定了\ ``MathFunctions``\ 的使用要求，\
就可以安全地从顶层文件\ ``CMakeLists.txt``\ 中删除\ ``EXTRA_INCLUDES``\ 变量了，如下所示：

.. raw:: html

  <details><summary>TODO 2: 点击显示/隐藏答案</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-remove-EXTRA_INCLUDES
  :language: cmake
  :start-after: # 添加MathFunctions库
  :end-before: # 添加可执行文件

.. raw:: html

  </details>

及这里：

.. raw:: html

  <details><summary>TODO 3: 点击显示/隐藏答案</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: TODO 3: CMakeLists.txt
  :name: CMakeLists.txt-target_include_directories-remove-EXTRA_INCLUDES
  :language: cmake
  :start-after: # 以便找到TutorialConfig.h

.. raw:: html

  </details>

注意，使用这种技术，我们的可执行目标要使用库所做的唯一一件事就是调用\ :command:`target_link_libraries`，\
并指定库目标的名称。在大型项目中，手动指定库依赖关系的经典方法很快就会变得非常复杂。
