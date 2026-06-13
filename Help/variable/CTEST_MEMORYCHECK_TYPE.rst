CTEST_MEMORYCHECK_TYPE
----------------------

.. versionadded:: 3.1

在\ :manual:`ctest(1)`\ :ref:`Dashboard Client`\ 脚本中指定CTest ``MemoryCheckType``\ 设置，\
or on the :program:`ctest` command line via the :ctest-dashboard-option:`-D` option。有效值为\
``Valgrind``、\ ``Purify``、\ ``BoundsChecker``、\ ``DrMemory``、\ ``CudaSanitizer``、\
``ThreadSanitizer``、\ ``AddressSanitizer``、\ ``LeakSanitizer``、\
``MemorySanitizer``\ 和\ ``UndefinedBehaviorSanitizer``。
