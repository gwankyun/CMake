XCODE_SCHEME_LLDB_INIT_FILE
---------------------------

.. versionadded:: 4.0

在生成的Xcode方案的信息部分中，此属性用于指定\ ``LLDB Init File``\ 的值。若该值包含生成器\
表达式，则会对这些表达式进行求值。

This property is initialized by the value of the variable
:variable:`CMAKE_XCODE_SCHEME_LLDB_INIT_FILE` if it is set
when a target is created.

.. include:: ../include/XCODE_SCHEME_NOTE.rst
