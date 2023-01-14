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

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 1: CMakeLists.txt
  :name: CMakeLists.txt-cxx_std-feature
  :language: cmake
  :start-after: # specify the C++ standard
  :end-before: # add compiler warning flags just

.. raw:: html

  </details>

最后，设置好接口库后，我们需要将可执行\ ``Target``\ 和\ ``MathFunctions``\ 库链接到新的\ ``tutorial_compiler_flags``\ 库。\
代码分别如下所示：

.. raw:: html

  <details><summary>TODO 2: 点击显示/隐藏答案</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-target_link_libraries-step4
  :language: cmake
  :start-after: add_executable(Tutorial tutorial.cxx)
  :end-before: # 添加二进制树到引用目录的搜索路径

.. raw:: html

  </details>

还有：

.. raw:: html

  <details><summary>TODO 3: 点击显示/隐藏答案</summary>

.. literalinclude:: Step5/MathFunctions/CMakeLists.txt
  :caption: TODO 3: MathFunctions/CMakeLists.txt
  :name: MathFunctions-CMakeLists.txt-target_link_libraries-step4
  :language: cmake
  :start-after: # link our compiler flags interface library
  :end-before: # TODO 1

.. raw:: html

  </details>

这样，我们所有的代码仍然需要C++ 11来构建。注意，使用这种方法，我们能够明确哪些目标得到特定的需求。\
此外，我们在接口库中创建了一个单一的真实源。

练习2 - 使用生成器表达式添加编译器警告标志
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 的一种常见用法是有条件地添加编译器标记，\
例如用于语言级别或警告的标记。一个很好的模式是将该信息关联到一个\ ``INTERFACE``\ 目标，让该信息传播。

目标
----

在构建时添加编译器警告标志，但不为已安装的版本添加。

有用的资源
-----------------

* :manual:`cmake-generator-expressions(7)`
* :command:`cmake_minimum_required`
* :command:`set`
* :command:`target_compile_options`

待编辑的文件
-------------

* ``CMakeLists.txt``

开始
---------------

从练习1中的结果文件开始。完成\ ``TODO 4``\ 到\ ``TODO 7``。

首先，在顶层的\ ``CMakeLists.txt``\ 文件中，我们需要将\ :command:`cmake_minimum_required`\ 设置为\ ``3.15``。\
在这个练习中，我们将使用在CMake 3.15中引入的生成器表达式。

接下来，我们为项目添加所需的编译器警告标志。由于警告标志因编译器而不同，\
我们使用\ ``COMPILE_LANG_AND_ID``\ 生成器表达式来控制给定语言和一组编译器id应用哪些标志。

构建并运行
-------------

因为我们已经在练习1中配置了构建目录，只需通过调用以下命令来重建代码：

.. code-block:: console

  cd Step4_build
  cmake --build .

解决方案
--------

更新\ :command:`cmake_minimum_required`，至少需要CMake版本\ ``3.15``：

.. raw:: html

  <details><summary>TODO 4: 点击显示/隐藏答案</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 4: CMakeLists.txt
  :name: MathFunctions-CMakeLists.txt-minimum-required-step4
  :language: cmake
  :end-before: # 设置工程名及版本号

.. raw:: html

  </details>

接下来，我们确定系统当前使用的编译器，因为警告标志会根据所使用的编译器而变化。\
这是通过\ ``COMPILE_LANG_AND_ID``\ 生成器表达式完成的。\
我们在变量\ ``gcc_like_cxx``\ 和\ ``msvc_cxx``\ 中设置结果如下所示：

.. raw:: html

  <details><summary>TODO 5: 点击显示/隐藏答案</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 5: CMakeLists.txt
  :name: CMakeLists.txt-compile_lang_and_id
  :language: cmake
  :start-after: # the BUILD_INTERFACE genex
  :end-before: target_compile_options(tutorial_compiler_flags INTERFACE

.. raw:: html

  </details>

接下来，我们为项目添加所需的编译器警告标志。使用我们的变量\ ``gcc_like_cxx``\ 和\ ``msvc_cxx``，\
我们可以使用另一个生成器表达式，仅当变量为真时应用各自的标志。\
我们使用\ :command:`target_compile_options`\ 将这些标志应用到我们的接口库。

.. raw:: html

  <details><summary>TODO 6: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 6: CMakeLists.txt
  :name: CMakeLists.txt-compile_flags

  target_compile_options(tutorial_compiler_flags INTERFACE
    "$<${gcc_like_cxx}:-Wall;-Wextra;-Wshadow;-Wformat=2;-Wunused>"
    "$<${msvc_cxx}:-W3>"
  )

.. raw:: html

  </details>

最后，我们只希望在构建期间使用这些警告标志。已安装项目的使用者不应该继承我们的警告标志。\
为了指定这一点，我们使用\ ``BUILD_INTERFACE``\ 条件将标记包装在生成器表达式中。生成的完整代码如下所示：

.. raw:: html

  <details><summary>TODO 7: 点击显示/隐藏答案</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 7: CMakeLists.txt
  :name: CMakeLists.txt-target_compile_options-genex
  :language: cmake
  :start-after: set(msvc_cxx "$<COMPILE_LANG_AND_ID:CXX,MSVC>")
  :end-before: # 是否使用我们自己的数学函数

.. raw:: html

  </details>
