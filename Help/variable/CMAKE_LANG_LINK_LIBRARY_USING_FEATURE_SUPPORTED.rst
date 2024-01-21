CMAKE_<LANG>_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED
---------------------------------------------------

.. versionadded:: 3.24

如果链接器语言\ ``<LANG>``\ 支持由变量\
:variable:`CMAKE_<LANG>_LINK_LIBRARY_USING_<FEATURE>`\ 定义的\ ``<FEATURE>``，\
则设置为\ ``TRUE``。

.. note::

  This variable is evaluated before the more generic variable
  :variable:`CMAKE_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED`.
