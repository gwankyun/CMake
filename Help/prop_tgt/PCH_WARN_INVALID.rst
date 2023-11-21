PCH_WARN_INVALID
----------------

.. versionadded:: 3.18

当此属性设置为true时，预编译头编译器选项将包含一个编译器标志，该标志应该警告无效的预编译头，\
例如GNU编译器的\ ``-Winvalid-pch`` 。

This property is initialized by the value of the
:variable:`CMAKE_PCH_WARN_INVALID` variable if it is set when a target is
created.  If that variable is not set, the property defaults to ``ON``.
