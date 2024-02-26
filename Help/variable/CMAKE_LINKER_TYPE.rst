CMAKE_LINKER_TYPE
-----------------

.. versionadded:: 3.29

指定链接步骤将使用哪个链接器。

.. note::
  It is assumed that the linker specified is fully compatible with the standard
  one. CMake will not do any options translation.

This variable is used to initialize the :prop_tgt:`LINKER_TYPE` target
property when they are created by calls to :command:`add_library` or
:command:`add_executable` commands. It is meaningful only for targets having a
link step. If set, its value is also used by the :command:`try_compile`
command.

.. include:: LINKER_PREDEFINED_TYPES.txt
