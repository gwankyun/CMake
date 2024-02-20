FAIL_REGULAR_EXPRESSION
-----------------------

如果测试输出（stdout或stderr）匹配此正则表达式，则无论进程退出代码如何，测试都将失败。无论\
``FAIL_REGULAR_EXPRESSION``\ 如何，超过\ :prop_test:`TIMEOUT`\ 指定的超时的测试都会\
失败。任何非零返回码或系统级测试失败，包括分段错误、信号中止或堆错误，即使正则表达式不匹配，\
也会使测试失败。

If set, if the output matches one of specified regular expressions, the test
will fail.  Example:

.. code-block:: cmake

  # test would pass, except for FAIL_REGULAR_EXPRESSION
  add_test(NAME mytest COMMAND ${CMAKE_COMMAND} -E echo "Failed")

  set_property(TEST mytest PROPERTY
    FAIL_REGULAR_EXPRESSION "[^a-z]Error;ERROR;Failed"
  )

``FAIL_REGULAR_EXPRESSION`` expects a list of regular expressions.

See also the :prop_test:`PASS_REGULAR_EXPRESSION` and
:prop_test:`SKIP_REGULAR_EXPRESSION` test properties.
