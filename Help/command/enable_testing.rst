enable_testing
--------------

启用当前及以下目录的测试。

.. code-block:: cmake

  enable_testing()

此命令应在顶级源代码目录中调用，因为 :manual:`ctest(1)` 期望在顶级构建目录中找到测试文件。

当包含\ :module:`CTest`\ 模块时，将同样自动调用此命令，除非关闭\ :variable:`BUILD_TESTING`\ 选项。

``enable_testing()`` 的调用位置有以下限制：

* 它必须在文件作用域中调用，不能在 :command:`function` 调用内部，也不能在 :command:`block` 内部。

示例
^^^^^^^^

在以下示例中，该命令根据项目的使用方式有条件地被调用。例如，当 Example 项目通过 :module:`FetchContent`
模块作为子目录添加到定义了自身测试的父项目时，Example 项目的测试功能将被禁用。

.. code-block:: cmake
  :caption: ``CMakeLists.txt``

  project(Example)

  option(Example_ENABLE_TESTING "Enable testing" ${PROJECT_IS_TOP_LEVEL})

  if(Example_ENABLE_TESTING)
    enable_testing()
  endif()

  # ...

  if(Example_ENABLE_TESTING)
    add_test(...)
  endif()

另请参阅
^^^^^^^^

* :command:`add_test` 命令。
