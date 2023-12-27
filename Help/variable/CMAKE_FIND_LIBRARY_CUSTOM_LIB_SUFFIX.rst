CMAKE_FIND_LIBRARY_CUSTOM_LIB_SUFFIX
------------------------------------

.. versionadded:: 3.9

指定一个\ ``<suffix>``\ 来告诉\ :command:`find_library`\ 命令在通常要搜索的每个\
``lib``\ 目录之前在\ ``lib<suffix>``\ 目录中搜索。

This overrides the behavior of related global properties:

* :prop_gbl:`FIND_LIBRARY_USE_LIB32_PATHS`
* :prop_gbl:`FIND_LIBRARY_USE_LIB64_PATHS`
* :prop_gbl:`FIND_LIBRARY_USE_LIBX32_PATHS`
