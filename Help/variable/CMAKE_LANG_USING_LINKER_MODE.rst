CMAKE_<LANG>_USING_LINKER_MODE
------------------------------

.. versionadded:: 3.29

这控制了如何解释\ :variable:`CMAKE_<LANG>_USING_LINKER_<TYPE>`\ 变量的值。支持的链接器\
模式值为：

``FLAG``
  :variable:`CMAKE_<LANG>_USING_LINKER_<TYPE>` holds a
  :ref:`semicolon-separated list <CMake Language Lists>` of flags to be passed
  to the compiler frontend.  This is also the default behavior if
  ``CMAKE_<LANG>_USING_LINKER_MODE`` is not set.

``TOOL``
  :variable:`CMAKE_<LANG>_USING_LINKER_<TYPE>` holds the path to the linker
  tool.
