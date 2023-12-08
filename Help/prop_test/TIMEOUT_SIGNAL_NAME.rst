TIMEOUT_SIGNAL_NAME
-------------------

.. versionadded:: 3.27

指定一个自定义信号，在达到测试进程超时时发送给测试进程。这仅在支持POSIX信号的平台上可用。\
在Windows上不可用。

The name must be one of the following:

  ``SIGINT``
    Interrupt.

  ``SIGQUIT``
    Quit.

  ``SIGTERM``
    Terminate.

  ``SIGUSR1``
    User defined signal 1.

  ``SIGUSR2``
    User defined signal 2.

The custom signal is sent to the test process to give it a chance
to exit gracefully during a grace period:

* If the test process created any children, it is responsible for
  terminating them too.

* The grace period length is determined by the
  :prop_test:`TIMEOUT_SIGNAL_GRACE_PERIOD` test property.

* If the test process does not terminate before the grace period ends,
  :manual:`ctest(1)` will force termination of its entire process tree
  via ``SIGSTOP`` and ``SIGKILL``.

See also :variable:`CTEST_TEST_TIMEOUT`,
:prop_test:`TIMEOUT`, and :prop_test:`TIMEOUT_AFTER_MATCH`.
