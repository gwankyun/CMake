ASM<DIALECT>FLAGS
-----------------

.. include:: include/ENV_VAR.rst

添加默认编译标志，以便在编译汇编语言的特定方言时使用。\ ``ASM<DIALECT>FLAGS``\ 标志可以是：

* ``ASMFLAGS``

* ``ASM_NASMFLAGS``

* ``ASM_MASMFLAGS``

* ``ASM_MARMASMFLAGS``

* ``ASM_POASMFLAGS``

* ``ASM-ATTFLAGS``

.. |CMAKE_LANG_FLAGS| replace:: :variable:`CMAKE_ASM<DIALECT>_FLAGS <CMAKE_<LANG>_FLAGS>`
.. |LANG| replace:: ``ASM<DIALECT>``
.. include:: include/LANG_FLAGS.rst

See also :variable:`CMAKE_ASM<DIALECT>_FLAGS_INIT <CMAKE_<LANG>_FLAGS_INIT>`.
