BUILDSYSTEM_TARGETS
-------------------

.. versionadded:: 3.7

这个只读目录属性包含一个构建系统目标的\ :ref:`分号分隔列表 <CMake Language Lists>`，\
这些目标是通过调用\ :command:`add_library`、\ :command:`add_executable`\ 和\
:command:`add_custom_target`\ 命令添加到目录中的。该列表不包括任何\
:ref:`Imported Targets`\ 或\ :ref:`Alias Targets`，但包括\
:ref:`Interface Libraries`。列表中的每个条目都是目标的逻辑名称，适合传递给\
:command:`get_property`\ 命令\ ``TARGET``\ 选项。

See also the :prop_dir:`IMPORTED_TARGETS` directory property.
