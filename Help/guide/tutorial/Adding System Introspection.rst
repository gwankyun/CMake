步骤5：添加系统自省
===================================

考虑向项目中添加一些依赖目标平台可能没有的特性代码。对于本例，我们将添加一些代码，这将取决于目标平台是否有 ``log`` 和 ``exp`` 函数。当然，几乎每个平台都有这些函数，但本教程假设它们并不常见。

如果平台有 ``log`` 和 ``exp`` ，那么我们将使用它们在 ``mysqrt`` 中计算平方根。首先在 ``MathFunctions/CMakeLists.txt`` 中使用  :module:`CheckSymbolExists` 模块判断这些函数是否可用。在一些平台上，需要链接到 ``m`` 库。如果 ``log`` 和 ``exp`` 不可用，则使用 ``m`` 库并重试。

.. literalinclude:: Step6/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-check_symbol_exists
  :language: cmake
  :start-after: # does this system provide the log and exp functions?
  :end-before: # add compile definitions

如果可以的话，使用 :command:`target_compile_definitions` 指定 ``HAVE_LOG`` 和 ``HAVE_EXP`` 为 ``PRIVATE`` 编译器定义。

.. literalinclude:: Step6/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-target_compile_definitions
  :language: cmake
  :start-after: # add compile definitions
  :end-before: # install rules

如果 ``log`` 和 ``exp`` 在系统上可用，那么我们将在 ``mysqrt`` 函数中用来计算平方根。将以下代码添加到 ``MathFunctions/mysqrt.cxx`` 中的 ``mysqrt`` 函数中（返回結果前不要忘了 ``#endif``！）：

.. literalinclude:: Step6/MathFunctions/mysqrt.cxx
  :caption: MathFunctions/mysqrt.cxx
  :name: MathFunctions/mysqrt.cxx-ifdef
  :language: c++
  :start-after: // if we have both log and exp then use them
  :end-before: // do ten iterations

同时还要修改 ``mysqrt.cxx`` 以包含 ``cmath``：

.. literalinclude:: Step6/MathFunctions/mysqrt.cxx
  :caption: MathFunctions/mysqrt.cxx
  :name: MathFunctions/mysqrt.cxx-include-cmath
  :language: c++
  :end-before: #include <iostream>

运行 :manual:`cmake  <cmake(1)>` 命令或者 :manual:`cmake-gui <cmake-gui(1)>` 来配置并用构建工具构建它，然后运行Tutorial程序。

哪个函数给了更好的结果？``sqrt`` 还是 ``mysqrt``？
