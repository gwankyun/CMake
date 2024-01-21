CMAKE_<LANG>_LINK_GROUP_USING_<FEATURE>_SUPPORTED
-------------------------------------------------

.. versionadded:: 3.24

这个变量指定链接语言\ ``<LANG>``\ 是否支持\ ``<FEATURE>``。如果该变量为true，则\
``<FEATURE>``\ 必须由\ :variable:`CMAKE_<LANG>_LINK_GROUP_USING_<FEATURE>`\ 定义，\
而不使用更通用的\ :variable:`CMAKE_LINK_GROUP_USING_<FEATURE>_SUPPORTED`\ 和\
:variable:`CMAKE_LINK_GROUP_USING_<FEATURE>`\ 变量。

If ``CMAKE_<LANG>_LINK_GROUP_USING_<FEATURE>_SUPPORTED`` is false or is not
set, then the :variable:`CMAKE_LINK_GROUP_USING_<FEATURE>_SUPPORTED` variable
will determine whether ``<FEATURE>`` is deemed to be supported.
