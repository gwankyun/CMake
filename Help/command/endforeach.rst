endforeach
----------

在foreach块中结束命令列表。

.. code-block:: cmake

  endforeach([<loop_var>])

参见\ :command:`foreach`\ 命令。

支持可选的\ ``<loop_var>``\ 参数只是为了向后兼容。如果使用，它必须是开头\ ``foreach``\
子句的\ ``<loop_var>``\ 参数的完全重复。
