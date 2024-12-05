get_cmake_property
------------------

获取CMake实例的全局属性。

.. code-block:: cmake

  get_cmake_property(<variable> <property>)

从CMake实例获取一个全局属性。\ ``<property>``\ 的值存储在指定的\ ``<variable>``\ 中。\
如果没有找到属性，\ ``<variable>``\ 将被设置为\ ``NOTFOUND``。有关可用属性，请参阅\
:manual:`cmake-properties(7)`\ 手册。

除了全局属性，这个命令（由于历史原因）还支持\ :prop_dir:`VARIABLES`\ 和\ :prop_dir:`MACROS`\
目录属性。它还支持一个特殊的全局属性\ ``COMPONENTS``，它列出了提供给\ :command:`install`\
命令的所有组件。

另请参阅
^^^^^^^^

* :command:`get_property`\ 命令\ ``GLOBAL``\ 选项
