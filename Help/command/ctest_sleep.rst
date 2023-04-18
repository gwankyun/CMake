ctest_sleep
-----------

睡一段时间

.. code-block:: cmake

  ctest_sleep(<seconds>)

Sleep for given number of seconds.

.. code-block:: cmake

  ctest_sleep(<time1> <duration> <time2>)

Sleep for t=(time1 + duration - time2) seconds if t > 0.
