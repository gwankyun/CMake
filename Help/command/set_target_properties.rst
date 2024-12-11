set_target_properties
---------------------

目标可以具有影响其构建方式的属性。

.. code-block:: cmake

  set_target_properties(<targets> ...
                        PROPERTIES <prop1> <value1>
                        [<prop2> <value2>] ...)

设置目标的属性。该命令的语法是列出所有要修改的目标，然后提供下一步要设置的值。你可以使用任何\
你想要的属性值对，然后使用\ :command:`get_property`\ 或\ :command:`get_target_property`\
命令提取它。

:ref:`Alias Targets`\ 不支持设置目标属性。

另请参阅
^^^^^^^^

* :command:`define_property`
* :command:`get_target_property`
* 更通用的\ :command:`set_property`\ 命令
* CMake已知属性列表的\ :ref:`Target Properties` 
