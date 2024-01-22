CMAKE_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED
--------------------------------------------

.. versionadded:: 3.24

如果\ ``<FEATURE>``\ 由变量\ :variable:`CMAKE_LINK_LIBRARY_USING_<FEATURE>`\ 定义，\
无论链接器语言如何都支持，则设置为\ ``TRUE``。

.. note::

  This variable is evaluated if, and only if, the variable
  :variable:`CMAKE_<LANG>_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED` is not
  defined.
