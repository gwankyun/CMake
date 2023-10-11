BUILD_WITH_INSTALL_NAME_DIR
---------------------------

.. versionadded:: 3.9

``BUILD_WITH_INSTALL_NAME_DIR``\ 是一个布尔值，指定构建树中目标的macOS ``install_name``\
是否使用\ :prop_tgt:`INSTALL_NAME_DIR`\ 给出的目录。此设置仅适用于macOS上的目标。

This property is initialized by the value of the variable
:variable:`CMAKE_BUILD_WITH_INSTALL_NAME_DIR` if it is set when a target is
created.

If this property is not set and policy :policy:`CMP0068` is not ``NEW``, the
value of :prop_tgt:`BUILD_WITH_INSTALL_RPATH` is used in its place.
