option
------

提供一个用户可以选择的布尔选项。

.. code-block:: cmake

  option(<variable> "<help_text>" [value])

如果没有提供初始\ ``<value>``，则默认值为boolean ``OFF``。如果\ ``<variable>``\ 已经\
设置为普通变量或缓存变量，那么该命令什么也不做（参见策略\ :policy:`CMP0077`\ ）。

对于依赖于其他选项值的选项，请参阅\ :module:`CMakeDependentOption`\ 模块的帮助。

在CMake项目模式下，使用option值创建一个布尔缓存变量。在CMake脚本模式下，使用option值设置\
一个布尔变量。
