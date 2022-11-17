Step 7: Adding System Introspection
===================================

考虑向项目中添加一些依赖目标平台可能没有的特性代码。\
对于本例，我们将添加一些代码，这将取决于目标平台是否有\ ``log``\ 和\ ``exp``\ 函数。\
当然，几乎每个平台都有这些函数，但本教程假设它们并不常见。

如果平台有\ ``log``\ 和\ ``exp``，那么我们将使用它们在\ ``mysqrt``\ 函数中计算平方根。\
首先在\ ``MathFunctions/CMakeLists.txt``\ 中使用\ :module:`CheckCXXSourceCompiles`\ 模块判断这些函数是否可用。

调用\ :command:`target_include_directories`\ 之后，在\ ``MathFunctions/CMakeLists.txt``\ 添加对\ ``log``\ 和\ ``exp``\ 的检查：

.. literalinclude:: Step8/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-check_cxx_source_compiles
  :language: cmake
  :start-after: # 以便查找MathFunctions.h，尽管我们自己不用。
  :end-before: # 添加编译器定义

如果可以的话，使用\ :command:`target_compile_definitions`\ 指定\ ``HAVE_LOG``\ 和\ ``HAVE_EXP``\ 为\ ``PRIVATE``\ 编译器定义。

.. literalinclude:: Step8/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-target_compile_definitions
  :language: cmake
  :start-after: # 添加编译器定义
  :end-before: # install libs

如果\ ``log``\ 和\ ``exp``\ 在系统上可用，那么我们将在\ ``mysqrt``\ 函数中用来计算平方根。\
将以下代码添加到\ ``MathFunctions/mysqrt.cxx``\ 中的\ ``mysqrt``\ 函数中（返回結果前不要忘了\ ``#endif``！）：

.. literalinclude:: Step8/MathFunctions/mysqrt.cxx
  :caption: MathFunctions/mysqrt.cxx
  :name: MathFunctions/mysqrt.cxx-ifdef
  :language: c++
  :start-after: // 如果log和exp都有，那就用它们
  :end-before: // 迭代十次

同时还要修改\ ``mysqrt.cxx``\ 以包含\ ``cmath``：

.. literalinclude:: Step8/MathFunctions/mysqrt.cxx
  :caption: MathFunctions/mysqrt.cxx
  :name: MathFunctions/mysqrt.cxx-include-cmath
  :language: c++
  :end-before: #include <iostream>

运行\ :manual:`cmake  <cmake(1)>`\ 命令或者\ :manual:`cmake-gui <cmake-gui(1)>`\ 来配置并用构建工具构建它，然后运行Tutorial程序。

哪个函数给了更好的结果？``sqrt``\ 还是\ ``mysqrt``？
