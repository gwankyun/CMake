DEBUGGER_WORKING_DIRECTORY
--------------------------

.. versionadded:: 4.0

为C++目标设置本地调试器的工作目录。\
该属性值可以使用\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`。\
如果在创建目标时设置了变量\ :variable:`CMAKE_DEBUGGER_WORKING_DIRECTORY`，则此属性将由\
该变量的值初始化。

If the :prop_tgt:`VS_DEBUGGER_WORKING_DIRECTORY` property is also set, it will
take precedence over ``DEBUGGER_WORKING_DIRECTORY`` when using one of the
Visual Studio generators.

Similarly, if :prop_tgt:`XCODE_SCHEME_WORKING_DIRECTORY` is set, it will
override ``DEBUGGER_WORKING_DIRECTORY`` when using the Xcode generator.
