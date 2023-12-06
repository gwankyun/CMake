FAIL_REGULAR_EXPRESSION
-----------------------

如果输出与此正则表达式匹配，则无论进程退出代码如何，测试都将失败。

If set, if the output matches one of specified regular expressions,
the test will fail.  Example:

.. code-block:: cmake

  set_tests_properties(mytest PROPERTIES
    FAIL_REGULAR_EXPRESSION "[^a-z]Error;ERROR;Failed"
  )

``FAIL_REGULAR_EXPRESSION`` expects a list of regular expressions.

See also the :prop_test:`PASS_REGULAR_EXPRESSION` and
:prop_test:`SKIP_REGULAR_EXPRESSION` test properties.
