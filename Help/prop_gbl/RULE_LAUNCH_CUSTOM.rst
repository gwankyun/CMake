RULE_LAUNCH_CUSTOM
------------------

为自定义规则指定启动器。

:ref:`Makefile Generators` and the :generator:`Ninja` generator prefix
custom commands with the given launcher command line.
This is intended to allow launchers to intercept build problems
with high granularity.  Other generators ignore this property
because their underlying build systems provide no hook to wrap
individual commands with a launcher.
