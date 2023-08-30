CTEST_NO_TESTS_ACTION
---------------------

.. versionadded:: 3.26

.. include:: ENV_VAR.txt

环境变量，控制\ :manual:`ctest <ctest(1)>`\ 在没有要运行的测试时如何处理用例。可能的值是：\
``error``\、\ ``ignore``、empty或unset。

The :option:`--no-tests=\<action\> <ctest --no-tests>` option to
:manual:`ctest <ctest(1)>` overrides this environment variable if both
are given.
