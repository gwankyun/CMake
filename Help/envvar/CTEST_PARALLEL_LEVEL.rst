CTEST_PARALLEL_LEVEL
--------------------

.. include:: ENV_VAR.txt

指定CTest并行运行的测试数。
For example, if ``CTEST_PARALLEL_LEVEL`` is set to 8, CTest will run
up to 8 tests concurrently as if ``ctest`` were invoked with the
:option:`--parallel 8 <ctest --parallel>` option.

有关并行测试执行的更多信息，请参阅\ :manual:`ctest(1)`。
