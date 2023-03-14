步骤7: 添加系统自省
===================================

考虑向项目中添加一些依赖目标平台可能没有的特性代码。\
对于本例，我们将添加一些代码，这将取决于目标平台是否有\ ``log``\ 和\ ``exp``\ 函数。\
当然，几乎每个平台都有这些函数，但本教程假设它们并不常见。

练习1 - 评估依赖项可用性
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

目标
----

根据可用的系统依赖关系更改实现。

有用的资源
-----------------

* :module:`CheckCXXSourceCompiles`
* :command:`target_compile_definitions`

待编辑的文件
-------------

* ``MathFunctions/CMakeLists.txt``
* ``MathFunctions/mysqrt.cxx``

开始
---------------

在\ ``Step7``\ 目录中提供了起始源代码。在这个练习中，完成\ ``TODO 1``\ 到\ ``TODO 5``。

首先编辑\ ``MathFunctions/CMakeLists.txt``。包含\ :module:`CheckCXXSourceCompiles`\ 模块。\
然后，使用\ ``check_cxx_source_compiles``\ 来确定\ ``log``\ 和\ ``exp``\ 是否可以从\ ``cmath``\ 获得。\
如果可用，则使用\ :command:`target_compile_definitions`\ 指定\ ``HAVE_LOG``\ 和\ ``HAVE_EXP``\ 作为编译定义。

在\ ``MathFunctions/mysqrt.cxx``\ 中，包含\ ``cmath``。然后，如果系统有\ ``log``\ 和\ ``exp``，\
使用它们来计算平方根。

构建并运行
-------------

创建一个名为\ ``Step7_build``\ 的新目录。\
运行\ :manual:`cmake  <cmake(1)>`\ 可执行文件或\ :manual:`cmake-gui <cmake-gui(1)>`\ 来配置项目，\
然后使用你选择的构建工具构建它，并运行\ ``Tutorial``\ 可执行文件。

它看起来像下面这样：

.. code-block:: console

  mkdir Step7_build
  cd Step7_build
  cmake ../Step7
  cmake --build .

现在哪个函数给出了更好的结果，\ ``sqrt``\ 还是\ ``mysqrt``？

解决方案
--------

在本练习中，我们将使用\ :module:`CheckCXXSourceCompiles`\ 模块中的函数，\
因此首先我们必须将其包含在\ ``MathFunctions/CMakeLists.txt``\ 中。

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. literalinclude:: Step8/MathFunctions/CMakeLists.txt
  :caption: TODO 1: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-include-check_cxx_source_compiles
  :language: cmake
  :start-after: # does this system provide the log and exp functions?
  :end-before: check_cxx_source_compiles

.. raw:: html

  </details>

然后使用\ ``check_cxx_compiles_source``\ 测试\ ``log``\ 和\ ``exp``\ 的可用性。\
这个函数允许我们在真正的源代码编译之前，尝试使用所需的依赖项编译简单的代码。\
结果变量\ ``HAVE_LOG``\ 和\ ``HAVE_EXP``\ 表示这些依赖项是否可用。

.. raw:: html

  <details><summary>TODO 2: 点击显示/隐藏答案</summary>

.. literalinclude:: Step8/MathFunctions/CMakeLists.txt
  :caption: TODO 2: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-check_cxx_source_compiles
  :language: cmake
  :start-after: include(CheckCXXSourceCompiles)
  :end-before: # 添加编译器定义

.. raw:: html

  </details>

接下来，我们需要将这些CMake变量传递给源代码。这样，我们的源代码就可以知道哪些资源是可用的。\
如果 ``log`` 和\ ``exp``\ 都可用，\
则使用\ :command:`target_compile_definitions`\ 指定\ ``HAVE_LOG``\ 和\ ``HAVE_EXP``\ 作为\ ``PRIVATE``\ 编译定义。

.. raw:: html

  <details><summary>TODO 3: 点击显示/隐藏答案</summary>

.. literalinclude:: Step8/MathFunctions/CMakeLists.txt
  :caption: TODO 3: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-target_compile_definitions
  :language: cmake
  :start-after: # 添加编译器定义
  :end-before: # install libs

.. raw:: html

  </details>

因为我们可能会使用\ ``log``\ 和\ ``exp``，所以我们需要修改\ ``mysqrt.cxx``\ 包含\ ``cmath``。

.. raw:: html

  <details><summary>TODO 4: 点击显示/隐藏答案</summary>

.. literalinclude:: Step8/MathFunctions/mysqrt.cxx
  :caption: TODO 4: MathFunctions/mysqrt.cxx
  :name: MathFunctions/mysqrt.cxx-include-cmath
  :language: c++
  :end-before: #include <iostream>

.. raw:: html

  </details>

如果系统上有\ ``log``\ 和\ ``exp``，那么使用它们来计算\ ``mysqrt``\ 函数中的平方根。\
``MathFunctions/mysqrt.cxx``\ 中的 ``mysqrt`` 函数如下所示：

.. raw:: html

  <details><summary>TODO 5: 点击显示/隐藏答案</summary>

.. literalinclude:: Step8/MathFunctions/mysqrt.cxx
  :caption: TODO 5: MathFunctions/mysqrt.cxx
  :name: MathFunctions/mysqrt.cxx-ifdef
  :language: c++
  :start-after: // 如果log和exp都有，那就用它们
  :end-before: // 迭代十次

.. raw:: html

  </details>
