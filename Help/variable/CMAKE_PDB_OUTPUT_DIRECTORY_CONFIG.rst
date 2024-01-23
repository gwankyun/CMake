CMAKE_PDB_OUTPUT_DIRECTORY_<CONFIG>
-----------------------------------

由链接器为可执行库和共享库目标生成的MS调试符号\ ``.pdb``\ 文件的特定配置输出目录。

This is a per-configuration version of :variable:`CMAKE_PDB_OUTPUT_DIRECTORY`.
This variable is used to initialize the
:prop_tgt:`PDB_OUTPUT_DIRECTORY_<CONFIG>`
property on all the targets.  See that target property for additional
information.
