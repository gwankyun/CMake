CMAKE_LINK_GROUP_USING_<FEATURE>_SUPPORTED
------------------------------------------

.. versionadded:: 3.24

该变量指定无论链接语言如何，是否支持\ ``<FEATURE>``。如果该变量为真，则\ ``<FEATURE>``\
必须由\ :variable:`CMAKE_LINK_GROUP_USING_<FEATURE>`\ 定义。

Note that this variable has no effect if
:variable:`CMAKE_<LANG>_LINK_GROUP_USING_<FEATURE>_SUPPORTED` is true for
the link language of the target.
