endfunction
-----------

在function块中结束命令列表。

.. code-block:: cmake

  endfunction([<name>])

参见\ :command:`function`\ 命令。

支持可选的\ ``<name>``\ 参数只是为了向后兼容。如果使用，它必须是开头\ ``function``\ 命令的\
``<name>``\ 参数的逐字重复。
