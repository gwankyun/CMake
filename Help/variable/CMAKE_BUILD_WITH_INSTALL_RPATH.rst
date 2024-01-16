CMAKE_BUILD_WITH_INSTALL_RPATH
------------------------------

使用\ ``RPATH``\ 的安装路径。

Normally CMake uses the build tree for the ``RPATH`` when building
executables etc on systems that use ``RPATH``.  When the software is
installed the executables etc are relinked by CMake to have the
install ``RPATH``.  If this variable is set to true then the software is
always built with the install path for the ``RPATH`` and does not need to
be relinked when installed.

This is used to initialize the :prop_tgt:`BUILD_WITH_INSTALL_RPATH` target property
for all targets.
