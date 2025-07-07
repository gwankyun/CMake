处理编译器驱动差异
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. versionadded:: 4.0

为了将选项传递给链接器工具，每个编译器驱动都有自己的语法。可以使用\ ``LINKER:``\ 前缀和\
``,``\ 分隔符以一种可移植的方式指定要传递给链接器工具的选项。\ ``LINKER:``\ 会被相应的驱动\
选项替换，而\ ``,``\ 会被相应的驱动分隔符替换。驱动前缀和驱动分隔符由变量\
:variable:`CMAKE_<LANG>_LINKER_WRAPPER_FLAG`\ 和\
:variable:`CMAKE_<LANG>_LINKER_WRAPPER_FLAG_SEP`\ 的值指定。

例如，对于\ ``Clang``\ 编译器，\ ``"LINKER:-z,defs"``\ 会转换为\
``-Xlinker -z -Xlinker defs``；而对于\ ``GNU GCC``\ 编译器，它会转换为\ ``-Wl,-z,defs`` 。

作为一种替代语法，\ ``LINKER:``\ 前缀支持使用\ ``SHELL:``\ 前缀并以空格作为分隔符来指定参数。\
那么前面的示例就变成了\ ``"LINKER:SHELL:-z defs"``。

.. note::

  不支持在\ ``LINKER:``\ 前缀的开头之外的任何位置指定\ ``SHELL:``\ 前缀。
