CPACK_INSTALL_DEFAULT_DIRECTORY_PERMISSIONS
-------------------------------------------

.. versionadded:: 3.11

在打包过程中隐式创建的目录默认权限。

This variable serves the same purpose during packaging as the
:variable:`CMAKE_INSTALL_DEFAULT_DIRECTORY_PERMISSIONS` variable
serves during installation (e.g. ``make install``).

If `include(CPack)` is used then by default this variable is set to the content
of :variable:`CMAKE_INSTALL_DEFAULT_DIRECTORY_PERMISSIONS`.
