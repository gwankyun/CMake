步骤4：添加生成器表达式
=====================================

:manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 在生成生成系统期间计算，以生\
成特定于每个生成配置的信息。

:manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 可以在许多目标属性的上下文中\
使用，比如\ :prop_tgt:`LINK_LIBRARIES`、\ :prop_tgt:`INCLUDE_DIRECTORIES`、\
:prop_tgt:`COMPILE_DEFINITIONS`\ 等等。它们也可以在使用命令填充那些属性时使用，比如\
:command:`target_link_libraries`、\ :command:`target_include_directories`、\
:command:`target_compile_definitions`\ 等等。

:manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 可用于启用条件链接、编译时使\
用的条件定义、条件包含目录等等。这些条件可能基于构建配置、目标属性、平台信息或任何其他可查询\
的信息。

:manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 有不同的类型，包括逻辑表达式、\
信息表达式和输出表达式。

逻辑表达式用于创建条件输出。基本表达式是\ ``0``\ 和\ ``1``\ 表达式。``$<0:...>``\ 结果为\
空字符串，而\ ``$<1:...>``\ 则会生成\ ``...``。\
可以嵌套使用。

练习1 - 在生成器表达式中添加编译器警告标志
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 的一种常见用法是有条件地添加\
编译器标记，例如用于语言级别或警告的标记。一个很好的模式是将该信息关联到一个\ ``INTERFACE``\
目标，让该信息传播。

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

打开文件\ ``Step4/CMakeLists.txt``，完成\ ``TODO 1``\ 到\ ``TODO 4``。

首先，在顶层的\ ``CMakeLists.txt``\ 文件中，我们需要将\ :command:`cmake_minimum_required`\
设置为\ ``3.15``。在这个练习中，我们将使用在CMake 3.15中引入的生成器表达式。

接下来，我们为项目添加所需的编译器警告标志。由于警告标志因编译器而不同，我们使用\
``COMPILE_LANG_AND_ID``\ 生成器表达式来控制给定语言和一组编译器id应用哪些标志。

构建并运行
-------------

创建一个名为\ ``Step4_build``\ 的新目录，运行\ :manual:`cmake <cmake(1)>`\ 可执行文\
件或:manual:`cmake-gui <cmake-gui(1)>`\ 来配置项目，然后使用你选择的构建工具或使用\
``cmake --build .``\ 从构建目录来构建它。

.. code-block:: console

  mkdir Step4_build
  cd Step4_build
  cmake ../Step4
  cmake --build .

解决方案
--------

更新\ :command:`cmake_minimum_required`，至少需要CMake版本\ ``3.15``：

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 1: CMakeLists.txt
  :name: MathFunctions-CMakeLists.txt-minimum-required-step4
  :language: cmake
  :end-before: # 设置工程名及版本号

.. raw:: html

  </details>

接下来，我们确定系统当前使用的编译器，因为警告标志会根据所使用的编译器而变化。这是通过\
``COMPILE_LANG_AND_ID``\ 生成器表达式完成的。我们在变量\ ``gcc_like_cxx``\ 和\
``msvc_cxx``\ 中设置结果如下所示：

.. raw:: html

  <details><summary>TODO 2: 点击显示/隐藏答案</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-compile_lang_and_id
  :language: cmake
  :start-after: # the BUILD_INTERFACE genex
  :end-before: target_compile_options(tutorial_compiler_flags INTERFACE

.. raw:: html

  </details>

接下来，我们为项目添加所需的编译器警告标志。使用我们的变量\ ``gcc_like_cxx``\ 和\
``msvc_cxx``，我们可以使用另一个生成器表达式，仅当变量为真时应用各自的标志。我们使用\
:command:`target_compile_options`\ 将这些标志应用到我们的接口库。

.. raw:: html

  <details><summary>TODO 3: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 3: CMakeLists.txt
  :name: CMakeLists.txt-compile_flags

  target_compile_options(tutorial_compiler_flags INTERFACE
    "$<${gcc_like_cxx}:-Wall;-Wextra;-Wshadow;-Wformat=2;-Wunused>"
    "$<${msvc_cxx}:-W3>"
  )

.. raw:: html

  </details>

最后，我们只希望在构建期间使用这些警告标志。已安装项目的使用者不应该继承我们的警告标志。为了\
指定这一点，我们使用\ ``BUILD_INTERFACE``\ 条件将来自TODO 3的标志包装在生成器表达式中。\
生成的完整代码如下所示：

.. raw:: html

  <details><summary>TODO 4: 点击显示/隐藏答案</summary>

.. literalinclude:: Step5/CMakeLists.txt
  :caption: TODO 4: CMakeLists.txt
  :name: CMakeLists.txt-target_compile_options-genex
  :language: cmake
  :start-after: set(msvc_cxx "$<COMPILE_LANG_AND_ID:CXX,MSVC>")
  :end-before: # configure a header file to pass some of the CMake settings

.. raw:: html

  </details>
