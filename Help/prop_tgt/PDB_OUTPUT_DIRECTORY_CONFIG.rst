PDB_OUTPUT_DIRECTORY_<CONFIG>
-----------------------------

由链接器为可执行库或共享库目标生成的MS调试符号\ ``.pdb``\ 文件的特定配置输出目录。

This is a per-configuration version of :prop_tgt:`PDB_OUTPUT_DIRECTORY`,
but multi-configuration generators (:ref:`Visual Studio Generators`,
:generator:`Xcode`) do NOT append a
per-configuration subdirectory to the specified directory.  This
property is initialized by the value of the
:variable:`CMAKE_PDB_OUTPUT_DIRECTORY_<CONFIG>` variable if it is
set when a target is created.

Contents of ``PDB_OUTPUT_DIRECTORY_<CONFIG>`` may use
:manual:`generator expressions <cmake-generator-expressions(7)>`.

.. |COMPILE_PDB_XXX| replace:: :prop_tgt:`COMPILE_PDB_OUTPUT_DIRECTORY_<CONFIG>`
.. include:: PDB_NOTE.txt
