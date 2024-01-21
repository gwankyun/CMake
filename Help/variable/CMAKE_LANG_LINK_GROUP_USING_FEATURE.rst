CMAKE_<LANG>_LINK_GROUP_USING_<FEATURE>
---------------------------------------

.. versionadded:: 3.24

当使用\ :genex:`LINK_GROUP`\ 生成器表达式并且目标的链接语言为\ ``<LANG>``\ 时，该变量\
定义了如何为指定\ ``<FEATURE>``\ 链接一组库。要使该变量生效，关联的\
:variable:`CMAKE_<LANG>_LINK_GROUP_USING_<FEATURE>_SUPPORTED`\ 变量必须设置为true。

The :variable:`CMAKE_LINK_GROUP_USING_<FEATURE>` variable should be defined
instead for features that are independent of the link language.

.. include:: CMAKE_LINK_GROUP_USING_FEATURE.txt
