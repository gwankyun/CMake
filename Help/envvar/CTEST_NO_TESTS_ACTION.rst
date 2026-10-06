CTEST_NO_TESTS_ACTION
---------------------

.. versionadded:: 3.26

.. include:: include/ENV_VAR.rst

环境变量，控制\ :manual:`ctest <ctest(1)>`\ 在没有要运行的测试时如何处理用例。可能的值是：\
``error``\、\ ``ignore``、empty或unset。

The :option:`--no-tests=\<action\> <ctest --no-tests>` option to
:manual:`ctest <ctest(1)>` overrides this environment variable if both
are given.

When :option:`ctest --preset` is used, this environment variable, if set,
takes precedence over the :preset:`testPresets.execution.noTestsAction`
field of the selected test preset. This includes the case where the
variable is instead set via the preset's own
:preset:`testPresets.environment` field, which is equivalent to setting it
in the calling process's environment. An explicit
:option:`--no-tests=\<action\> <ctest --no-tests>` on the command line
takes precedence over all of the above.

This environment variable, including when set via a test preset's
``environment`` field, is also respected when that same preset is used by
a :command:`ctest_test` command in a :ref:`CTest Script`. However, in that
case, the preset's ``noTestsAction`` field itself has no effect, because
:command:`ctest_test` has no equivalent argument to apply it through.
