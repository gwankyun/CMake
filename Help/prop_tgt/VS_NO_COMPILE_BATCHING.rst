VS_NO_COMPILE_BATCHING
----------------------

.. versionadded:: 3.24

关闭目标的编译批处理。通常MSBuild用多个c/cpp文件调用编译器，编译器为每个文件启动子进程以使\
构建并行。如果你希望一次调用一个文件来调用编译器，请将\ ``VS_NO_COMPILE_BATCHING``\ 设\
置为ON。如果设置了此标志，MSBuild将一次使用一个c/cpp文件调用编译器。当你想要使用替代编译器\
的工具时非常有用，例如某些构建缓存工具。

This property is initialized by the :variable:`CMAKE_VS_NO_COMPILE_BATCHING`
variable if it is set when a target is created.

Example
^^^^^^^

This shows setting the property for the target ``foo``.

.. code-block:: cmake

  add_library(foo SHARED foo.cpp)
  set_property(TARGET foo PROPERTY VS_NO_COMPILE_BATCHING ON)
