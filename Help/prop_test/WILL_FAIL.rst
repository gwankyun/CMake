WILL_FAIL
---------

如果设置为true，这将反转测试的通过/失败标志。

This property can be used for tests that are expected to fail and return a
non-zero return code. Note that system-level test failures such as segmentation
faults or heap errors will still fail the test even if ``WILL_FALL`` is true.
