PCH_INSTANTIATE_TEMPLATES
-------------------------

.. versionadded:: 3.19

当此属性设置为true时，预编译头编译器选项将包含一个标志，在支持的前提下，用于在生成PCH期间实\
例化模板。这可以显著改善编译时间。Clang从11开始支持。

This property is initialized by the value of the
:variable:`CMAKE_PCH_INSTANTIATE_TEMPLATES` variable if it is set when a target
is created.  If that variable is not set, the property defaults to ``ON``.
