PDB_NAME
--------

由链接器为可执行库或共享库目标生成的MS调试符号\ ``.pdb``\ 文件的输出名称。

This property specifies the base name for the debug symbols file.
If not set, the :prop_tgt:`OUTPUT_NAME` target property value or
logical target name is used by default.

.. versionadded:: 4.1

  Contents of ``PDB_NAME`` may use
  :manual:`generator expressions <cmake-generator-expressions(7)>`.

.. |COMPILE_PDB_XXX| replace:: :prop_tgt:`COMPILE_PDB_NAME`
.. include:: include/PDB_NOTE.rst
