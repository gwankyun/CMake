VS_DEBUGGER_WORKING_DIRECTORY
-----------------------------

.. versionadded:: 3.8

Sets the local debugger working directory for Visual Studio targets,
specifically the process launched by the debugger.

属性值可以使用\
:manual:`生成器表达式 <cmake-generator-expressions(7)>`。这是在Visual Studio项目文\
件中的\ ``<LocalDebuggerWorkingDirectory>``\ 中定义的。如果在创建目标时设置该属性，则\
该属性由变量\ :variable:`CMAKE_VS_DEBUGGER_WORKING_DIRECTORY`\ 的值初始化。

This property only works for :ref:`Visual Studio Generators`;
it is ignored on other generators.

See also :prop_tgt:`DEBUGGER_WORKING_DIRECTORY`.
