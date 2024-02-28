CTEST_NIGHTLY_START_TIME
------------------------

.. versionadded:: 3.1

在\ :manual:`ctest(1)`\ 仪表板客户端脚本中指定CTest ``NightlyStartTime``\ 设置。

Note that this variable must always be set for a nightly build in a
dashboard script. It is needed so that nightly builds can be properly grouped
together in CDash.
