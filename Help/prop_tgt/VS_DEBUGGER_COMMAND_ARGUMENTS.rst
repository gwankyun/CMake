VS_DEBUGGER_COMMAND_ARGUMENTS
-----------------------------

.. versionadded:: 3.13

为Visual Studio C++目标设置本地调试器命令行参数。属性值可以使用\
:manual:`生成器表达式 <cmake-generator-expressions(7)>`。这是在Visual Studio项目文\
件中的\ ``<LocalDebuggerCommandArguments>``\ 中定义的。如果在创建目标时设置该属性，则\
该属性由变量\ :variable:`CMAKE_VS_DEBUGGER_COMMAND_ARGUMENTS`\ 的值初始化。

This property only works for :ref:`Visual Studio Generators`;
it is ignored on other generators.
