while
-----

当条件为真时执行一组命令。

.. code-block:: cmake

  while(<condition>)
    <commands>
  endwhile()

在while和匹配的\ :command:`endwhile`\ 之间的所有命令都被记录下来，而不被调用。一旦调用了\
:command:`endwhile`，只要\ ``<condition>``\ 为真，就会调用记录的命令列表。

``<condition>``\ 具有相同的语法，并使用与\ :command:`if`\ 命令相同的逻辑进行计算。

命令\ :command:`break`\ 和\ :command:`continue`\ 提供了跳出正常控制流的方法。

对于遗留版本，\ :command:`endwhile`\ 命令允许一个可选的\ ``<condition>``\ 参数。如果使用，\
它必须是开头\ ``while``\ 命令参数的逐字重复。

另请参阅
^^^^^^^^

* :command:`break`
* :command:`continue`
* :command:`foreach`
* :command:`endwhile`
