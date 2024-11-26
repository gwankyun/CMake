endmacro
--------

在macro块中结束命令列表。

.. code-block:: cmake

  endmacro([<name>])

参见\ :command:`macro`\ 命令。

支持可选的\ ``<condition>``\ 参数只是为了向后兼容。如果使用，它必须是开头\ ``macro``\
命令的\ ``<name>``\ 参数的逐字重复。
