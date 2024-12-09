remove_definitions
------------------

删除\ :command:`add_definitions`\ 添加的-D定义标志。

.. code-block:: cmake

  remove_definitions(-DFOO -DBAR ...)

从编译器命令行中删除当前目录及以下目录中的源代码的标志（由\ :command:`add_definitions`\ 添加）。
