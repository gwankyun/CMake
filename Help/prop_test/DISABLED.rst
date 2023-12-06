DISABLED
--------

.. versionadded:: 3.9

如果设置为\ ``True``，测试将被跳过，其状态将为“Not Run”。已\ ``DISABLED``\ 的测试将不\
计入测试总数，其完成状态将报告给CDash为\ ``DISABLED``。

A ``DISABLED`` test does not participate in test fixture dependency resolution.
If a ``DISABLED`` test has fixture requirements defined in its
:prop_test:`FIXTURES_REQUIRED` property, it will not cause setup or cleanup
tests for those fixtures to be added to the test set.

If a test with the :prop_test:`FIXTURES_SETUP` property set is ``DISABLED``,
the fixture behavior will be as though that setup test was passing and any test
case requiring that fixture will still run.
