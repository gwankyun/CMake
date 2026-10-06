CTEST_PARALLEL_LEVEL
--------------------

.. include:: include/ENV_VAR.rst

指定CTest并行运行的测试数。例如，如果\ ``CTEST_PARALLEL_LEVEL``\ 设置为8，CTest将并发\
运行多达8个测试，就好像\ :manual:`ctest(1)`\ 是用\ :option:`--parallel 8 <ctest --parallel>`\
选项调用的一样。

.. versionchanged:: 3.29

  The value may be empty, or ``0``, to let CTest use a default level of
  parallelism, or unbounded parallelism, respectively, as documented by
  the :option:`ctest --parallel` option.

  CTest will interpret a whitespace-only string as empty.

  In CMake 3.28 and earlier, an empty or ``0`` value was equivalent to ``1``.

This environment variable is ignored if :option:`ctest --parallel` is given on
the command line, and is overridden by the :preset:`testPresets.execution.jobs`
field of a test preset, if that field is set.

A test preset may also set this variable itself, using its own
:preset:`testPresets.environment` field. Doing so is equivalent to setting
the variable in the calling process's environment, except that it takes
effect only for the preset's Test step, and only if ``execution.jobs`` is
not also set (which would take precedence, as noted above).

When a test preset is used by a :command:`ctest_test` command in a
:ref:`CTest Script`, that command's own ``PARALLEL_LEVEL`` argument, if given,
takes precedence over the preset's ``execution.jobs`` field. Together,
``PARALLEL_LEVEL`` and ``execution.jobs`` take precedence not only over this
environment variable, but over an explicit :option:`ctest --parallel` on the
command line as well. This differs from a preset used directly via
:option:`ctest --preset`, where an explicit ``--parallel`` always wins over the
preset's ``execution.jobs`` field.

有关并行测试执行的更多信息，请参阅\ :manual:`ctest(1)`。
