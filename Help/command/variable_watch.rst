variable_watch
--------------

监控CMake变量变动。

.. code-block:: cmake

  variable_watch(<variable> [<command>])

如果指定的\ ``<variable>``\ 发生变化，且未提供\ ``<command>``，则会打印一条消息来告知该变化。

如果指定了\ ``<command>`` ，则会执行该命令。该命令将接收以下参数：\
``COMMAND(<variable> <access> <value> <current_list_file> <stack>)``

``<variable>``
 正在被访问的变量的名称。

``<access>``
 ``READ_ACCESS``、\ ``UNKNOWN_READ_ACCESS``、\ ``MODIFIED_ACCESS``、\
 ``UNKNOWN_MODIFIED_ACCESS``\ 或\ ``REMOVED_ACCESS``\ 之一。\ ``UNKNOWN_``\ 前缀的\
 值仅在变量从未被设置过时使用。一旦变量被设置，在同一次CMake运行过程中，即使该变量随后被取消\
 设置，也不会再使用这些值。

``<value>``
 变量的值。当变量被修改时，此为变量的新（已修改）值。当变量被移除时，该值为空。

``<current_list_file>``
 正在访问操作文件的完整路径。

``<stack>``
 当前文件包含栈上所有文件的绝对路径列表，列表中最底部的文件排在最前，当前正在处理的文件（即\
 ``current_list_file``\ ）排在最后。

请注意，对于某些访问操作，例如\ :command:`list(APPEND)`，监控器会执行两次，第一次是读访问，\
然后是写访问。另请注意，对变量使用\ :command:`if(DEFINED)`\ 进行查询不会被视为一次访问，\
监控器也不会被执行。

此命令仅可用于监控非缓存变量。对缓存变量的访问不会被监控。然而，若存在一个名为\ ``var``\
的缓存变量，那么对非缓存变量\ ``var``\ 的访问将不会使用\ ``UNKNOWN_``\ 前缀，即便非缓存\
变量\ ``var``\ 从未存在过。
