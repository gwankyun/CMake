步骤3：添加库的使用需求
===============================================

练习1 - 为库添加使用需求
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

目标参数的\ :ref:`使用需求 <Target Usage Requirements>`\ 允许对库或可执行文件的link和include行进行更好的控制，\
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

在本练习中，我们将使用现代的CMake方法重构\ :guide:`添加库 <tutorial/Adding a Library>`\ 中的代码。\
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
  :end-before: # should we use our own

.. raw:: html

  </details>

既然我们已经指定了\ ``MathFunctions``\ 的使用要求，\
就可以安全地从顶层文件\ ``CMakeLists.txt``\ 中删除\ ``EXTRA_INCLUDES``\ 变量了。

Remove this line:

.. raw:: html

  <details><summary>TODO 2: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/CMakeLists.txt
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-remove-EXTRA_INCLUDES
  :language: cmake
  :start-after: add_subdirectory(MathFunctions)
  :end-before: # add the executable

.. raw:: html

  </details>

And the lines:

.. raw:: html

  <details><summary>TODO 3: 点击显示/隐藏答案</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: TODO 3: CMakeLists.txt
  :name: CMakeLists.txt-target_include_directories-remove-EXTRA_INCLUDES
  :language: cmake
  :start-after: # 以便找到TutorialConfig.h

.. raw:: html

  </details>

The remaining code looks like:

.. raw:: html

  <details><summary>Click to show/hide the resulting code</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: Remaining code after removing EXTRA_INCLUDES
  :name: CMakeLists.txt-after-removing-EXTRA_INCLUDES
  :language: cmake
  :start-after: add_subdirectory(MathFunctions)

.. raw:: html

  </details>


注意，使用这种技术，我们的可执行目标要使用库所做的唯一一件事就是调用\ :command:`target_link_libraries`，\
并指定库目标的名称。在大型项目中，手动指定库依赖关系的经典方法很快就会变得非常复杂。

Exercise 2 - Setting the C++ Standard with Interface Libraries
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Now that we have switched our code to a more modern approach, let's demonstrate
a modern technique to set properties to multiple targets.

Let's refactor our existing code to use an ``INTERFACE`` library. We will
use that library in the next step to demonstrate a common use for
:manual:`generator expressions <cmake-generator-expressions(7)>`.

Goal
----

Add an ``INTERFACE`` library target to specify the required C++ standard.

Helpful Resources
-----------------

* :command:`add_library`
* :command:`target_compile_features`
* :command:`target_link_libraries`

Files to Edit
-------------

* ``CMakeLists.txt``
* ``MathFunctions/CMakeLists.txt``

Getting Started
---------------

In this exercise, we will refactor our code to use an ``INTERFACE`` library to
specify the C++ standard.

Start this exercise from what we left at the end of Step3 exercise 1. You will
have to complete ``TODO 4`` through ``TODO 7``.

Start by editing the top level ``CMakeLists.txt`` file. Construct an
``INTERFACE`` library target called ``tutorial_compiler_flags`` and
specify ``cxx_std_11`` as a target compiler feature.

Modify ``CMakeLists.txt`` and ``MathFunctions/CMakeLists.txt`` so that all
targets have a :command:`target_link_libraries` call to
``tutorial_compiler_flags``.

Build and Run
-------------

Since we have our build directory already configured from Exercise 1, simply
rebuild our code by calling the following:

.. code-block:: console

  cd Step3_build
  cmake --build .

Next, use the newly built ``Tutorial`` and verify that it is working as
expected.

Solution
--------

Let's update our code from the previous step to use interface libraries
to set our C++ requirements.

To start, we need to remove the two :command:`set` calls on the variables
:variable:`CMAKE_CXX_STANDARD` and :variable:`CMAKE_CXX_STANDARD_REQUIRED`.
The specific lines to remove are as follows:

.. literalinclude:: Step3/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-CXX_STANDARD-variable-remove
  :language: cmake
  :start-after: # specify the C++ standard
  :end-before: # configure a header file

Next, we need to create an interface library, ``tutorial_compiler_flags``. And
then use :command:`target_compile_features` to add the compiler feature
``cxx_std_11``.


.. raw:: html

  <details><summary>TODO 4: Click to show/hide answer</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: TODO 4: CMakeLists.txt
  :name: CMakeLists.txt-cxx_std-feature
  :language: cmake
  :start-after: # specify the C++ standard
  :end-before: # TODO 2: Create helper

.. raw:: html

  </details>

Finally, with our interface library set up, we need to link our
executable ``Target``, our ``MathFunctions`` library, and our ``SqrtLibrary``
library to our new
``tutorial_compiler_flags`` library. Respectively, the code will look like
this:

.. raw:: html

  <details><summary>TODO 5: Click to show/hide answer</summary>

.. literalinclude:: Step4/CMakeLists.txt
  :caption: TODO 5: CMakeLists.txt
  :name: CMakeLists.txt-target_link_libraries-step4
  :language: cmake
  :start-after: add_executable(Tutorial tutorial.cxx)
  :end-before: # add the binary tree to the search path for include file

.. raw:: html

  </details>

this:

.. raw:: html

  <details><summary>TODO 6: Click to show/hide answer</summary>

.. literalinclude:: Step4/MathFunctions/CMakeLists.txt
  :caption: TODO 6: MathFunctions/CMakeLists.txt
  :name: MathFunctions-CMakeLists.txt-target_link_libraries-step4
  :language: cmake
  :start-after: # link our compiler flags interface library
  :end-before: target_link_libraries(MathFunctions

.. raw:: html

  </details>

and this:

.. raw:: html

  <details><summary>TODO 7: Click to show/hide answer</summary>

.. literalinclude:: Step4/MathFunctions/CMakeLists.txt
  :caption: TODO 7: MathFunctions/CMakeLists.txt
  :name: MathFunctions-SqrtLibrary-target_link_libraries-step4
  :language: cmake
  :start-after: target_link_libraries(SqrtLibrary
  :end-before: endif()

.. raw:: html

  </details>


With this, all of our code still requires C++ 11 to build. Notice
though that with this method, it gives us the ability to be specific about
which targets get specific requirements. In addition, we create a single
source of truth in our interface library.
