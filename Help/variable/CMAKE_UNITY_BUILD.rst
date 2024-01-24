CMAKE_UNITY_BUILD
-----------------

.. versionadded:: 3.16

该变量用于在创建目标时初始化目标的\ :prop_tgt:`UNITY_BUILD`\ 属性。将其设置为true将启用\
批处理编译多个源内的每个目标。这个特性被称为\ *Unity*\ 或\ *Jumbo*\ 构建。

Projects should not set this variable, it is intended as a developer
control to be set on the :manual:`cmake(1)` command line or other
equivalent methods.  The developer must have the ability to enable or
disable unity builds according to the capabilities of their own machine
and compiler.

By default, this variable is not set, which will result in unity builds
being disabled.

.. note::
  This option currently does not work well in combination with
  the :variable:`CMAKE_EXPORT_COMPILE_COMMANDS` variable.
