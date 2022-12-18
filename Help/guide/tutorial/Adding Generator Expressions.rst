步骤4：添加生成器表达式
=====================================

:manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 在生成生成系统期间计算，以生成特定于每个生成配置的信息。

:manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 可以在许多目标属性的上下文中使用，\
比如\ :prop_tgt:`LINK_LIBRARIES`、:prop_tgt:`INCLUDE_DIRECTORIES`、:prop_tgt:`COMPILE_DEFINITIONS`\ 等等。\
它们也可以在使用命令填充那些属性时使用，\
比如\ :command:`target_link_libraries`、:command:`target_include_directories`、:command:`target_compile_definitions`\ 等等。

:manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 可用于启用条件链接、编译时使用的条件定义、条件包含目录等等。\
这些条件可能基于构建配置、目标属性、平台信息或任何其他可查询的信息。

:manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 有不同的类型，包括逻辑表达式、信息表达式和输出表达式。

逻辑表达式用于创建条件输出。基本表达式是\ ``0``\ 和\ ``1``\ 表达式。``$<0:...>``\ 结果为空字符串，而\ ``<1:...>``\ 则会生成\ ``...``。\
可以嵌套使用。

练习1 - 使用接口库设置C++标准
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

在使用\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 之前，\
让我们重构现有代码以使用\ ``INTERFACE``\ 库。\
我们将在下一步中使用该库来演示\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 的通用用法。

目标
----

添加\ ``INTERFACE``\ 库目标以指定所需的C++标准。

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

在本练习中，我们将重构代码以使用\ ``INTERFACE``\ 库来指定C++标准。

在\ ``Step4``\ 目录中提供了起始源代码。在这个练习中，完成\ ``TODO 1``\ 到\ ``TODO 3``。

首先编辑顶层\ ``CMakeLists.txt``\ 文件。\
构造一个名为\ ``tutorial_compiler_flags``\ 的\ ``INTERFACE``\ 库目标，\
并指定\ ``cxx_std_11``\ 作为目标编译器特性。

修改\ ``CMakeLists.txt``\ 和\ ``MathFunctions/CMakeLists.txt``，\
使所有目标都有一个\ :command:`target_link_libraries`\ 调用\ ``tutorial_compiler_flags``。

构建并运行
-------------

创建一个名为\ ``Step4_build``\ 的新目录，\
运行\ :manual:`cmake <cmake(1)>`\ 可执行文件或\ :manual:`cmake-gui <cmake-gui(1)>`\ 来配置项目，\
然后使用你选择的构建工具或使用\ ``cmake --build .``\ 来从构建目录构建它。

下面是命令行的更新：

.. code-block:: console

  mkdir Step4_build
  cd Step4_build
  cmake ../Step4
  cmake --build .

接下来，使用新构建的\ ``Tutorial``\ 并验证它是否按预期工作。

解决方案
--------

让我们更新上一步的代码，使用接口库来设置我们的C++需求。

首先，我们需要删除对变量\ :variable:`CMAKE_CXX_STANDARD`\ 和\ :variable:`CMAKE_CXX_STANDARD_REQUIRED`\ 的两次\ :command:`set`\ 调用。具体需要去除的行如下：

.. literalinclude:: Step4/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-CXX_STANDARD-variable-remove
  :language: cmake
  :start-after: # specify the C++ standard
  :end-before: # TODO 5: Create helper variables

接下来，我们需要创建一个接口库\ ``tutorial_compiler_flags``。\
然后使用\ :command:`target_compile_features`\ 添加编译器特性\ ``cxx_std_11``。


.. raw:: html

  <details><summary>TODO 1: Click to show/hide answer</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 1: CMakeLists.txt
  :name: CMakeLists.txt-cxx_std-feature
  :language: cmake
  :start-after: # specify the C++ standard
  :end-before: # add compiler warning flags just

.. raw:: html

  </details>

Finally, with our interface library set up, we need to link our
executable ``Target`` and our ``MathFunctions`` library to our new
``tutorial_compiler_flags`` library. Respectively, the code will look like
this:

.. raw:: html

  <details><summary>TODO 2: Click to show/hide answer</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-target_link_libraries-step4
  :language: cmake
  :start-after: add_executable(Tutorial tutorial.cxx)
  :end-before: # 添加二进制树到引用目录的搜索路径

.. raw:: html

  </details>

and this:

.. raw:: html

  <details><summary>TODO 3: Click to show/hide answer</summary>

.. literalinclude:: Step5/MathFunctions/CMakeLists.txt
  :caption: TODO 3: MathFunctions/CMakeLists.txt
  :name: MathFunctions-CMakeLists.txt-target_link_libraries-step4
  :language: cmake
  :start-after: # link our compiler flags interface library
  :end-before: # TODO 1

.. raw:: html

  </details>

With this, all of our code still requires C++ 11 to build. Notice
though that with this method, it gives us the ability to be specific about
which targets get specific requirements. In addition, we create a single
source of truth in our interface library.

Exercise 2 - Adding Compiler Warning Flags with Generator Expressions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A common usage of
:manual:`generator expressions <cmake-generator-expressions(7)>` is to
conditionally add compiler flags, such as those for language levels or
warnings. A nice pattern is to associate this information to an ``INTERFACE``
target allowing this information to propagate.

Goal
----

Add compiler warning flags when building but not for installed versions.

Helpful Resources
-----------------

* :manual:`cmake-generator-expressions(7)`
* :command:`cmake_minimum_required`
* :command:`set`
* :command:`target_compile_options`

Files to Edit
-------------

* ``CMakeLists.txt``

Getting Started
---------------

Start with the resulting files from Exercise 1. Complete ``TODO 4`` through
``TODO 7``.

First, in the top level ``CMakeLists.txt`` file, we need to set the
:command:`cmake_minimum_required` to ``3.15``. In this exercise we are going
to use a generator expression which was introduced in CMake 3.15.

Next we add the desired compiler warning flags that we want for our project.
As warning flags vary based on the compiler, we use the
``COMPILE_LANG_AND_ID`` generator expression to control which flags to apply
given a language and a set of compiler ids.

Build and Run
-------------

Since we have our build directory already configured from Exercise 1, simply
rebuild our code by calling the following:

.. code-block:: console

  cd Step4_build
  cmake --build .

Solution
--------

Update the :command:`cmake_minimum_required` to require at least CMake
version ``3.15``:

.. raw:: html

  <details><summary>TODO 4: Click to show/hide answer</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 4: CMakeLists.txt
  :name: MathFunctions-CMakeLists.txt-minimum-required-step4
  :language: cmake
  :end-before: # 设置工程名及版本号

.. raw:: html

  </details>

Next we determine which compiler our system is currently using to build
since warning flags vary based on the compiler we use. This is done with
the ``COMPILE_LANG_AND_ID`` generator expression. We set the result in the
variables ``gcc_like_cxx`` and ``msvc_cxx`` as follows:

.. raw:: html

  <details><summary>TODO 5: Click to show/hide answer</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 5: CMakeLists.txt
  :name: CMakeLists.txt-compile_lang_and_id
  :language: cmake
  :start-after: # the BUILD_INTERFACE genex
  :end-before: target_compile_options(tutorial_compiler_flags INTERFACE

.. raw:: html

  </details>

Next we add the desired compiler warning flags that we want for our project.
Using our variables ``gcc_like_cxx`` and ``msvc_cxx``, we can use another
generator expression to apply the respective flags only when the variables are
true. We use :command:`target_compile_options` to apply these flags to our
interface library.

.. raw:: html

  <details><summary>TODO 6: Click to show/hide answer</summary>

.. code-block:: cmake
  :caption: TODO 6: CMakeLists.txt
  :name: CMakeLists.txt-compile_flags

  target_compile_options(tutorial_compiler_flags INTERFACE
    "$<${gcc_like_cxx}:-Wall;-Wextra;-Wshadow;-Wformat=2;-Wunused>"
    "$<${msvc_cxx}:-W3>"
  )

.. raw:: html

  </details>

Lastly, we only want these warning flags to be used during builds. Consumers
of our installed project should not inherit our warning flags. To specify
this, we wrap our flags in a generator expression using the ``BUILD_INTERFACE``
condition. The resulting full code looks like the following:

.. raw:: html

  <details><summary>TODO 7: Click to show/hide answer</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 7: CMakeLists.txt
  :name: CMakeLists.txt-target_compile_options-genex
  :language: cmake
  :start-after: set(msvc_cxx "$<COMPILE_LANG_AND_ID:CXX,MSVC>")
  :end-before: # 是否使用我们自己的数学函数

.. raw:: html

  </details>
