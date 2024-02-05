CTEST_CUSTOM_MAXIMUM_PASSED_TEST_OUTPUT_SIZE
--------------------------------------------

在保存通过的测试的输出时，这是\ :command:`ctest_test`\ 命令将收集的最大大小，以字节为单位。\
默认为1024（1kib）。有关可能的截断模式，请参阅\
:variable:`CTEST_CUSTOM_TEST_OUTPUT_TRUNCATION` 。

If a test's output contains the literal string "CTEST_FULL_OUTPUT",
the output will not be truncated and may exceed the maximum size.

.. include:: CTEST_CUSTOM_XXX.txt

For controlling the output collection of failing tests, see
:variable:`CTEST_CUSTOM_MAXIMUM_FAILED_TEST_OUTPUT_SIZE`.
