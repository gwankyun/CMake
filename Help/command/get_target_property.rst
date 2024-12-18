get_target_property
-------------------

从目标获取属性。

.. code-block:: cmake

  get_target_property(<variable> <target> <property>)

从目标获取一个属性。属性的值存储在指定的\ ``<variable>``\ 中。如果没有找到目标属性，\
``<variable>``\ 将被设置为\ ``<variable>-NOTFOUND``。如果目标属性被定义为一个\
``INHERITED``\ 属性（参见\ :command:`define_property`\ ），那么搜索将包括相关的父作用域，\
正如\ :command:`define_property`\ 命令所描述的那样。

使用\ :command:`set_target_properties`\ 设置目标属性值。属性通常用于控制如何构建目标，\
但也有一些用于查询目标。这个命令可以获取到目前为止创建的任何目标的属性。目标不需要在当前的\
``CMakeLists.txt``\ 文件中。

另请参阅
^^^^^^^^

* :command:`define_property`
* 更通用的\ :command:`get_property`\ 命令
* :command:`set_target_properties`
* CMake已知属性列表的\ :ref:`Target Properties`
