CTEST_PROGRESS_OUTPUT
---------------------

.. versionadded:: 3.13

.. include:: ENV_VAR.txt

布尔环境变量，影响\ :manual:`ctest <ctest(1)>`\ 命令输出报告总体进度的方式。当设置为\
``1``、\ ``TRUE``、\ ``ON``\ 或其他计算为布尔值true的值时，通过重复更新同一行来报告进度。\
这大大减少了总体的冗长性，但只有当输出直接发送到终端时才支持。如果没有设置环境变量或环境变量\
的值为false，则正常报告输出，每个测试都有自己的开始行和结束行记录到输出中。

The :option:`--progress <ctest --progress>` option to :manual:`ctest <ctest(1)>`
overrides this environment variable if both are given.
