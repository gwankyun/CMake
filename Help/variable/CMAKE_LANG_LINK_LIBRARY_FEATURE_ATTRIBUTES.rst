CMAKE_<LANG>_LINK_LIBRARY_<FEATURE>_ATTRIBUTES
----------------------------------------------

.. versionadded:: 3.30

当使用链接语言\ ``<LANG>``\ 进行链接时，该变量定义指定的链接库\ ``<FEATURE>``\ 的语义。\
如果该变量也为相同的\ ``<FEATURE>``\ 定义，则它优先于\
:variable:`CMAKE_LINK_LIBRARY_<FEATURE>_ATTRIBUTES`，但在其他方面具有类似的效果。查看\
:variable:`CMAKE_LINK_LIBRARY_<FEATURE>_ATTRIBUTES`\ 了解更多细节。
