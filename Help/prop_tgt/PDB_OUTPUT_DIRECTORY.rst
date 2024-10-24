PDB_OUTPUT_DIRECTORY
--------------------

由链接器为可执行库或共享库目标生成的MS调试符号\ ``.pdb``\ 文件的输出目录。

This property specifies the directory into which the MS debug symbols
will be placed by the linker. The property value may use
:manual:`generator expressions <cmake-generator-expressions(7)>`.
Multi-configuration generators append a per-configuration
subdirectory to the specified directory unless a generator expression
is used.

This property is initialized by the value of the
:variable:`CMAKE_PDB_OUTPUT_DIRECTORY` variable if it is
set when a target is created.

.. |COMPILE_PDB_XXX| replace:: :prop_tgt:`COMPILE_PDB_OUTPUT_DIRECTORY`
.. include:: PDB_NOTE.txt
