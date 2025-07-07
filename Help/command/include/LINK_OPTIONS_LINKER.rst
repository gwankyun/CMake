处理编译驱动程序差异
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

要将选项传递给链接器工具，每个编译器驱动程序都有自己的语法。\ ``LINKER:``\ 前缀和\ ``,``\
分隔符可用于以可移植的方式指定要传递给链接器工具的选项。\ ``LINKER:``\ 由适当的驱动程序选项\
取代，而\ ``,``\ 由适当的驱动程序分隔符取代。驱动程序前缀和驱动程序分隔符的值由\
:variable:`CMAKE_<LANG>_LINKER_WRAPPER_FLAG`\ 和\
:variable:`CMAKE_<LANG>_LINKER_WRAPPER_FLAG_SEP`\ 变量给出。

例如，对于\ ``Clang``，\ ``"LINKER:-z,defs"``\ 变成\ ``-Xlinker -z -Xlinker defs``\ 
，而对于\ ``GNU GCC``，则为\ ``-Wl,-z,defs``。

``LINKER:``\ 前缀可以作为\ ``SHELL:``\ 前缀表达式的一部分指定。

作为一种替代语法，\ ``LINKER:``\ 前缀支持使用\ ``SHELL:``\ 前缀和空格作为分隔符指定参数。\
前面的例子就变成了\ ``"LINKER:SHELL:-z defs"``。

.. note::

  不支持在\ ``LINKER:``\ 前缀开头以外的任何地方指定\ ``SHELL:``\ 前缀。
