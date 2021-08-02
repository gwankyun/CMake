remove_definitions
------------------

删除 :command:`add_definitions` 添加的-D定义标志。

.. code-block:: cmake

  remove_definitions(-DFOO -DBAR ...)

Removes flags (added by :command:`add_definitions`) from the compiler
command line for sources in the current directory and below.
