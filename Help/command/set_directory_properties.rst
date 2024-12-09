set_directory_properties
------------------------

设置当前目录和子目录的属性。

.. code-block:: cmake

  set_directory_properties(PROPERTIES <prop1> <value1> [<prop2> <value2>] ...)

以键值对的形式设置当前目录及其子目录的属性。

另请参见\ :command:`set_property(DIRECTORY)`\ 命令。

有关CMake已知的属性列表以及每个属性的行为的单独文档，请参阅\ :ref:`Directory Properties`。

另请参阅
^^^^^^^^

* :command:`define_property`
* :command:`get_directory_property`
* 更通用的\ :command:`set_property`\ 命令
