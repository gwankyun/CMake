ctest_sleep
-----------

睡一段时间

.. signature::
  ctest_sleep(<seconds>)

  Sleep for ``<seconds>`` seconds.

.. signature::
  ctest_sleep(<time1> <duration> <time2>)

  Sleep for ``<time1> + <duration> - <time2>`` seconds, if this sum is greater
  than zero.
