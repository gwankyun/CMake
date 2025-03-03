VS_CUSTOM_COMMAND_DISABLE_PARALLEL_BUILD
----------------------------------------

.. versionadded:: 4.0

一个布尔类型的属性。若源文件通过\ :command:`add_custom_command`\ 命令进行构建，并且该文件\
是自定义命令的\ ``MAIN_DEPENDENCY``\ 输入时，此属性可用于禁用Visual Studio中该源文件的\
并行构建。\
请参考策略\ :policy:`CMP0147`。
