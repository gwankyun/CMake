add_definitions
---------------

在编译源文件时添加\ ``-D``\ 定义标志。

.. code-block:: cmake

  add_definitions(-DFOO -DBAR ...)

为当前目录中的目标添加定义到编译器命令行，无论是在调用此命令之前还是之后添加的，以及在此之后\
添加的子目录中的定义。该命令可用于添加任何标志，但其目的是添加预处理器定义。

.. note::

  该命令已被替代：

  * 使用\ :command:`add_compile_definitions`\ 来添加预处理器定义。
  * 使用\ :command:`include_directories`\ 添加包含目录。
  * 使用\ :command:`add_compile_options`\ 添加其他选项。

以\ ``-D``\ 或\ ``/D``\ 开始的标志看起来像是预处理器定义，会自动添加到当前目录的\
:prop_dir:`COMPILE_DEFINITIONS`\ 目录属性中。具有非平凡值的定义可以留在标志集中，而不是\
出于向后兼容的原因进行转换。请参阅\ :prop_dir:`目录 <COMPILE_DEFINITIONS>`、\
:prop_tgt:`目标 <COMPILE_DEFINITIONS>`、:prop_sf:`源文件 <COMPILE_DEFINITIONS>`\
``COMPILE_DEFINITIONS``\ 属性的文档，了解向特定范围和配置添加预处理器定义的详细信息。

另请参阅
^^^^^^^^

* :manual:`cmake-buildsystem(7)`\ 手册关于定义构建系统属性的更多信息。
