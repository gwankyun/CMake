continue
--------

.. versionadded:: 3.2

跳到foreach或者while循环的开头。

.. code-block:: cmake

  continue()

``continue()``\ 命令允许cmake脚本中止\ :command:`foreach`\ 或\ :command:`while`\
循环当前迭代的其余部分，并从下一次迭代的开头开始。

另请参见\ :command:`break`\ 命令。
