COMPILE_PDB_NAME
----------------

.. versionadded:: 3.1

编译器在构建源文件时生成的MS调试符号\ ``.pdb``\ 文件的输出名称。

This property specifies the base name for the debug symbols file.
If not set, the default is unspecified.

If the :prop_tgt:`PRECOMPILE_HEADERS_REUSE_FROM` target is set, this property
is ignored and the reusage target's value of this property is used instead.

.. versionadded:: 4.1

  Contents of ``COMPILE_PDB_NAME`` may use
  :manual:`generator expressions <cmake-generator-expressions(7)>`.

.. |PDB_XXX| replace:: :prop_tgt:`PDB_NAME`
.. include:: include/COMPILE_PDB_NOTE.rst
