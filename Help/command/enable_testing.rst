enable_testing
--------------

启用当前及以下目录的测试。

.. code-block:: cmake

  enable_testing()

启用此目录及以下目录的测试。

这个命令应该放在源目录的顶层目录中，因为\ :manual:`ctest(1)`\ 希望在构建目录的顶层目录中找到一个测试文件。

当包含\ :module:`CTest`\ 模块时，将自动调用此命令，除非关闭\ :variable:`BUILD_TESTING`\ 选项。

另见\ :command:`add_test`\ 命令。
