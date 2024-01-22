CMAKE_LINK_LIBRARY_USING_<FEATURE>
----------------------------------

.. versionadded:: 3.24

当使用\ :genex:`LINK_LIBRARY`\ 生成器表达式时，该变量定义了如何为指定的\ ``<FEATURE>``\
链接库或框架。要使该变量生效，必须同时满足以下两个条件：

* The associated :variable:`CMAKE_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED`
  variable must be set to true.

* There is no language-specific definition for the same ``<FEATURE>``.
  This means :variable:`CMAKE_<LANG>_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED`
  cannot be true for the link language used by the target for which the
  :genex:`LINK_LIBRARY` generator expression is evaluated.

.. include:: CMAKE_LINK_LIBRARY_USING_FEATURE.txt
