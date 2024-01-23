CMAKE_OSX_SYSROOT
-----------------

指定要使用的macOS平台SDK的位置或名称。CMake使用这个值来计算\ ``-isysroot``\ 标志或同等\
标志的值，并帮助\ ``find_*``\ 命令在SDK中定位文件。

If not set explicitly the value is initialized by the ``SDKROOT``
environment variable, if set, and otherwise computed based on the
:variable:`CMAKE_OSX_DEPLOYMENT_TARGET` or the host platform.

.. include:: CMAKE_OSX_VARIABLE.txt
