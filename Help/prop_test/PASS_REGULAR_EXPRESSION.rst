PASS_REGULAR_EXPRESSION
-----------------------

输出必须匹配此正则表达式才能通过测试。进程退出码被忽略。

If set, the test output will be checked against the specified regular
expressions and at least one of the regular expressions has to match,
otherwise the test will fail.  Example:

.. code-block:: cmake

  set_tests_properties(mytest PROPERTIES
    PASS_REGULAR_EXPRESSION "TestPassed;All ok"
  )

``PASS_REGULAR_EXPRESSION`` expects a list of regular expressions.

See also the :prop_test:`FAIL_REGULAR_EXPRESSION` and
:prop_test:`SKIP_REGULAR_EXPRESSION` test properties.
