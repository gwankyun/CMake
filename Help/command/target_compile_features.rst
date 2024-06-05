target_compile_features
-----------------------

.. versionadded:: 3.1

向目标添加期望的编译器特性。

.. code-block:: cmake

  target_compile_features(<target> <PRIVATE|PUBLIC|INTERFACE> <feature> [...])

指定编译给定目标时所需的编译器特性。如果\ :variable:`CMAKE_C_COMPILE_FEATURES`、\
:variable:`CMAKE_CUDA_COMPILE_FEATURES`\ 或\ :variable:`CMAKE_CXX_COMPILE_FEATURES`\
变量中未列出该特性，则CMake将报告一个错误。如果使用该特性需要一个额外的编译器标志，例如\
``-std=gnu++11``，该标志将自动添加。

``INTERFACE``、\ ``PUBLIC``\ 和\ ``PRIVATE``\ 关键字是指定特性范围所必需的。\ ``PRIVATE``\
和\ ``PUBLIC``\ 项将填充\ ``<target>``\ 的\ :prop_tgt:`COMPILE_FEATURES`\ 属性。\
``PUBLIC``\ 和\ ``INTERFACE``\ 项将填充\ ``<target>``\ 的\
:prop_tgt:`INTERFACE_COMPILE_FEATURES`\ 属性。重复调用相同的\ ``<target>``\ 追加元素。

.. versionadded:: 3.11
  允许在\ :ref:`导入目标 <Imported Targets>`\ 上设置\ ``INTERFACE``\ 项。

命名\ ``<target>``\ 必须是由\ :command:`add_executable`\ 或\ :command:`add_library`\
等命令创建的，并且不能是\ :ref:`别名目标 <Alias Targets>`。

.. |command_name| replace:: ``target_compile_features``
.. |more_see_also| replace:: 请参阅\ :manual:`cmake-compile-features(7)`\ 手册，了解有关编译特性的信息和支持的编译器列表。
.. include:: GENEX_NOTE.txt
   :start-line: 1

另请参阅
^^^^^^^^

* :command:`target_compile_definitions`
* :command:`target_compile_options`
* :command:`target_include_directories`
* :command:`target_link_libraries`
* :command:`target_link_directories`
* :command:`target_link_options`
* :command:`target_precompile_headers`
* :command:`target_sources`
