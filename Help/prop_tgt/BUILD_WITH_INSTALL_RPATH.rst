BUILD_WITH_INSTALL_RPATH
------------------------

``BUILD_WITH_INSTALL_RPATH``\ 是一个布尔值，指定是否将构建树中的目标与\
:prop_tgt:`INSTALL_RPATH`\ 链接起来。这优先于\ :prop_tgt:`SKIP_BUILD_RPATH`，并且避\
免了在安装之前重新链接的需要。

This property is initialized by the value of the
:variable:`CMAKE_BUILD_WITH_INSTALL_RPATH` variable if it is set when a target
is created.

If policy :policy:`CMP0068` is not ``NEW``, this property also controls use of
:prop_tgt:`INSTALL_NAME_DIR` in the build tree on macOS.  Either way, the
:prop_tgt:`BUILD_WITH_INSTALL_NAME_DIR` target property takes precedence.
