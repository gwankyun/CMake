remove_definitions
------------------

移除由 :command:`add_compile_definitions` 或 :command:`add_definitions`
添加的编译定义：

.. code-block:: cmake

  remove_definitions([<definitions>...])

参数如下：

``<definitions>...``
  零个或多个编译定义。

此命令也可用于移除由 :command:`add_definitions` 添加的任何标志，但其主要目的是\
移除通过 ``-D`` 或 ``/D`` 传递的预处理器定义。

示例
^^^^^^^^

在以下示例中，当前目录作用域的目标将只有 ``BAZ`` 和 ``QUUX`` 编译定义：

.. code-block:: cmake

  add_compile_definitions(FOO BAR BAZ -DQUUX)

  # ...

  remove_definitions(-DFOO -DBAR)
