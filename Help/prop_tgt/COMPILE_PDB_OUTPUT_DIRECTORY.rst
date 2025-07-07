COMPILE_PDB_OUTPUT_DIRECTORY
----------------------------

.. versionadded:: 3.1

编译器在构建源文件时生成的MS调试符号\ ``.pdb``\ 文文件的输出目录。

This property specifies the directory into which the MS debug symbols
will be placed by the compiler.

.. versionadded:: 3.12

  The property value may use
  :manual:`generator expressions <cmake-generator-expressions(7)>`.
  Multi-configuration generators append a per-configuration
  subdirectory to the specified directory unless a generator expression
  is used.

This property is initialized by the value of the
:variable:`CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY` variable if it is
set when a target is created.

.. |PDB_XXX| replace:: :prop_tgt:`PDB_OUTPUT_DIRECTORY`
.. include:: include/COMPILE_PDB_NOTE.rst
