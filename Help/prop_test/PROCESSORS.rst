PROCESSORS
----------

设置为指定此测试需要多少个进程槽。如果未设置，则默认为\ ``1``\ 个处理器。

Denotes the number of processors that this test will require.  This is
typically used for MPI tests, and should be used in conjunction with
the :command:`ctest_test` ``PARALLEL_LEVEL`` option.

This will also be used to display a weighted test timing result in label and
subproject summaries in the command line output of :manual:`ctest(1)`. The wall
clock time for the test run will be multiplied by this property to give a
better idea of how much cpu resource CTest allocated for the test.

See also the :prop_test:`PROCESSOR_AFFINITY` test property.
