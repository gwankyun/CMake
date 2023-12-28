CMAKE_LINK_DIRECTORIES_BEFORE
-----------------------------

.. versionadded:: 3.13

在\ :command:`link_directories`\ 中是否默认添加或预添加目录。

This variable affects the default behavior of the :command:`link_directories`
command.  Setting this variable to ``ON`` is equivalent to using the ``BEFORE``
option in all uses of that command.
