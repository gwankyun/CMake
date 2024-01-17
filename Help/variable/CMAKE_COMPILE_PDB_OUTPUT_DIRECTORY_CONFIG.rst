CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY_<CONFIG>
-------------------------------------------

.. versionadded:: 3.1

编译器在构建源文件时生成的MS调试符号\ ``.pdb``\ 文件的配置输出目录。

This is a per-configuration version of
:variable:`CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY`.
This variable is used to initialize the
:prop_tgt:`COMPILE_PDB_OUTPUT_DIRECTORY_<CONFIG>`
property on all the targets.
