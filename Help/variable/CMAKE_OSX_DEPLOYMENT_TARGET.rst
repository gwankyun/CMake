CMAKE_OSX_DEPLOYMENT_TARGET
---------------------------

指定要部署目标二进制文件的目标平台（例如macOS或iOS）的最低版本。CMake将此变量值用于\
``-mmacosx-version-min``\ 标志或它们各自的目标平台等效值。对于带有多个macOS SDK的旧\
Xcode版本，这个变量也有助于在\ :variable:`CMAKE_OSX_SYSROOT`\ 未设置的情况下选择SDK。

If not set explicitly the value is initialized by the
``MACOSX_DEPLOYMENT_TARGET`` environment variable, if set,
and otherwise computed based on the host platform.

.. include:: CMAKE_OSX_VARIABLE.txt
