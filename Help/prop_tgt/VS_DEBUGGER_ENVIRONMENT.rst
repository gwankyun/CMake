VS_DEBUGGER_ENVIRONMENT
-----------------------

.. versionadded:: 3.13

为Visual Studio C++目标设置本地调试器环境。属性值可以使用\
:manual:`生成器表达式 <cmake-generator-expressions(7)>`。这在Visual Studio项目文件\
中的\ ``<LocalDebuggerEnvironment>``\ 中定义。如果在创建目标时设置该属性，则该属性由变量\
:variable:`CMAKE_VS_DEBUGGER_ENVIRONMENT`\ 的值初始化。

This property only works for :ref:`Visual Studio Generators`;
it is ignored on other generators.
