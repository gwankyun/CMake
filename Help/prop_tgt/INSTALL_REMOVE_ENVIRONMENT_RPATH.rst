INSTALL_REMOVE_ENVIRONMENT_RPATH
--------------------------------

.. versionadded:: 3.16

控制是否应该在安装期间删除工具链定义的rpath。

When a target is being installed, CMake may need to rewrite its rpath
information.  This occurs when the install rpath (as specified by the
:prop_tgt:`INSTALL_RPATH` target property) has different contents to the rpath
that the target was built with.  Some toolchains insert their own rpath
contents into the binary as part of the build.  By default, CMake will
preserve those extra inserted contents in the install rpath.  For those
scenarios where such toolchain-inserted entries need to be discarded during
install, set the ``INSTALL_REMOVE_ENVIRONMENT_RPATH`` target property to true.

This property is initialized by the value of
:variable:`CMAKE_INSTALL_REMOVE_ENVIRONMENT_RPATH` when the target is created.
