endif
-----

在if块中结束命令列表。

.. code-block:: cmake

  endif([<condition>])

参见\ :command:`if`\ 命令。

支持可选的\ ``<condition>``\ 参数只是为了向后兼容。如果使用，它必须是开头\ ``if``\ 子句\
的实参的逐字重复。
