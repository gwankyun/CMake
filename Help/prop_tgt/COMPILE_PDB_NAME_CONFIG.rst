COMPILE_PDB_NAME_<CONFIG>
-------------------------

.. versionadded:: 3.1

编译器在构建源文件时生成的MS调试符号\ ``.pdb``\ 文件的每个配置输出名称。

This is the configuration-specific version of :prop_tgt:`COMPILE_PDB_NAME`.

.. versionadded:: 4.1

  Contents of ``COMPILE_PDB_NAME_<CONFIG>`` may use
  :manual:`generator expressions <cmake-generator-expressions(7)>`.

.. |PDB_XXX| replace:: :prop_tgt:`PDB_NAME_<CONFIG>`
.. include:: include/COMPILE_PDB_NOTE.rst
