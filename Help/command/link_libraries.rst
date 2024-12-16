link_libraries
--------------

将库链接到之后添加的所有目标。

.. code-block:: cmake

  link_libraries([item1 [item2 [...]]]
                 [[debug|optimized|general] <item>] ...)

指定当使用\ :command:`add_executable`\ 或\ :command:`add_library`\ 等命令链接在当前\
目录或目录下稍后创建的任何目标时要使用的库或标志。有关参数的含义，请参见\
:command:`target_link_libraries`\ 命令。

.. note::
  只要可能，应该优先使用\ :command:`target_link_libraries`\ 命令。库依赖关系是自动链接的，\
  因此很少需要在目录范围内指定链接库。
