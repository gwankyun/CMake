ASM<DIALECT>FLAGS
-----------------

.. include:: ENV_VAR.txt

添加默认编译标志，以便在编译汇编语言的特定方言时使用。\ ``ASM<DIALECT>FLAGS``\ 标志可以是：

* ``ASMFLAGS``
* ``ASM_NASMFLAGS``
* ``ASM_MASMFLAGS``
* ``ASM_MARMASMFLAGS``
* ``ASM-ATTFLAGS``

.. |CMAKE_LANG_FLAGS| replace:: :variable:`CMAKE_ASM<DIALECT>_FLAGS <CMAKE_<LANG>_FLAGS>`
.. |LANG| replace:: ``ASM<DIALECT>``
.. include:: LANG_FLAGS.txt

See also :variable:`CMAKE_ASM<DIALECT>_FLAGS_INIT <CMAKE_<LANG>_FLAGS_INIT>`.
