site_name
---------

将给定的变量设置为计算机的名称。

.. code-block:: cmake

  site_name(variable)

在类UNIX平台上，如果设置了\ ``HOSTNAME``\ 变量，它的值将作为一个命令执行，期望打印出主机名，\
这与\ ``hostname``\ 命令行工具非常相似。
