CMAKE_HOST_SYSTEM
-----------------

当前运行CMake的操作系统复合名称。

This variable is the composite of :variable:`CMAKE_HOST_SYSTEM_NAME` and
:variable:`CMAKE_HOST_SYSTEM_VERSION`, e.g.
``${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_VERSION}``.  If
:variable:`CMAKE_HOST_SYSTEM_VERSION` is not set, then this variable is
the same as :variable:`CMAKE_HOST_SYSTEM_NAME`.
