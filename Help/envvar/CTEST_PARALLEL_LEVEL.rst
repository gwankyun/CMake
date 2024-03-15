CTEST_PARALLEL_LEVEL
--------------------

.. include:: ENV_VAR.txt

指定CTest并行运行的测试数。例如，如果\ ``CTEST_PARALLEL_LEVEL``\ 设置为8，CTest将并发\
运行多达8个测试，就好像\ ``ctest``\ 是用\ :option:`--parallel 8 <ctest --parallel>`\
选项调用的一样。

.. versionchanged:: 3.29

  The value may be empty, or ``0``, to let ctest use a default level of
  parallelism, or unbounded parallelism, respectively, as documented by
  the :option:`ctest --parallel` option.

  On Windows, environment variables cannot be set to an empty string.
  CTest will interpret a whitespace-only string as empty.

  In CMake 3.28 and earlier, an empty or ``0`` value was equivalent to ``1``.

有关并行测试执行的更多信息，请参阅\ :manual:`ctest(1)`。
