PDB_NAME_<CONFIG>
-----------------

由链接器为可执行库或共享库目标生成的MS调试符号\ ``.pdb``\ 文件的特定配置输出名称。

This is the configuration-specific version of :prop_tgt:`PDB_NAME`.

.. versionadded:: 4.1

  Contents of ``PDB_NAME_<CONFIG>`` may use
  :manual:`generator expressions <cmake-generator-expressions(7)>`.

.. |COMPILE_PDB_XXX| replace:: :prop_tgt:`COMPILE_PDB_NAME_<CONFIG>`
.. include:: include/PDB_NOTE.rst
