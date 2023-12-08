TIMEOUT_SIGNAL_GRACE_PERIOD
---------------------------

.. versionadded:: 3.27

如果设置了\ :prop_test:`TIMEOUT_SIGNAL_NAME`\ 测试属性，则该属性指定在发送自定义信号后\
等待测试进程终止的秒数。否则，此属性没有意义。

The grace period may be any real value greater than ``0.0``, but not greater
than ``60.0``.  If this property is not set, the default is ``1.0`` second.

This is available only on platforms supporting POSIX signals.
It is not available on Windows.
