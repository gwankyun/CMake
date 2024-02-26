CTEST_CUSTOM_TEST_OUTPUT_TRUNCATION
-----------------------------------

.. versionadded:: 3.24

如果通过\ :variable:`CTEST_CUSTOM_MAXIMUM_PASSED_TEST_OUTPUT_SIZE`\ 或\
:variable:`CTEST_CUSTOM_MAXIMUM_FAILED_TEST_OUTPUT_SIZE`\ 变量配置了最大大小，则\
设置测试输出截断模式。默认情况下，输出的\ ``tail``\ 将被截断。其他可能的值是\ ``middle``\
和\ ``head``。

.. include:: CTEST_CUSTOM_XXX.txt
