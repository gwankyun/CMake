IMPORTED_TARGETS
----------------

.. versionadded:: 3.21

此只读目录属性包含通过调用\ :command:`add_library`\ 和\ :command:`add_executable`\
命令添加到目录中的\ :ref:`Imported Targets`\ 的\
:ref:`分号分隔列表 <CMake Language Lists>` 。列表中的每个条目都是目标的逻辑名称，适合在\
同一目录中调用时传递给\ :command:`get_property`\ 命令\ ``TARGET``\ 选项。

See also the :prop_dir:`BUILDSYSTEM_TARGETS` directory property.
