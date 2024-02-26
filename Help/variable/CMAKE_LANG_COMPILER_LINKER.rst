CMAKE_<LANG>_COMPILER_LINKER
----------------------------

.. versionadded:: 3.29

``LANG``\ 链接器的完整路径。

This is the command that will be used as the ``<LANG>`` linker.

This variable is not guaranteed to be defined for all linkers or languages.

.. note::
  This variable is read-only. It must not be set by the user. To select a
  specific linker, use the :variable:`CMAKE_LINKER_TYPE` variable or the
  :prop_tgt:`LINKER_TYPE` target property.
