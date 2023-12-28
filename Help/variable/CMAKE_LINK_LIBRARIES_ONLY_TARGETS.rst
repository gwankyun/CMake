CMAKE_LINK_LIBRARIES_ONLY_TARGETS
---------------------------------

.. versionadded:: 3.23

设置这个变量是为了在创建非导入目标时初始化它们的\ :prop_tgt:`LINK_LIBRARIES_ONLY_TARGETS`\
属性。将其设置为true将启用额外的检查，即\ :command:`target_link_libraries`\ 命名的所有\
可以作为目标名的项实际上都是现有目标的名称。有关详细信息，请参阅目标属性文档。
