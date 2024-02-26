CMAKE_<LANG>_USING_LINKER_MODE
------------------------------

.. versionadded:: 3.29

该变量指定存储在\ :variable:`CMAKE_<LANG>_USING_LINKER_<TYPE>`\ 变量中的数据类型。\
有两种可能的值：

``FLAG``
  :variable:`CMAKE_<LANG>_USING_LINKER_<TYPE>` holds compiler flags. This is
  the default.

``TOOL``
  :variable:`CMAKE_<LANG>_USING_LINKER_<TYPE>` holds the path to the linker
  tool.
