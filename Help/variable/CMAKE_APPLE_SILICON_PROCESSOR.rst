CMAKE_APPLE_SILICON_PROCESSOR
-----------------------------

.. versionadded:: 3.19.2

在运行macOS的Apple Silicon主机上，设置这个变量来告诉CMake :variable:`CMAKE_HOST_SYSTEM_PROCESSOR`\
使用什么架构。取值为\ ``arm64``\ 或\ ``x86_64``。

The value of this variable should never be modified by project code.
It is meant to be set as a cache entry provided by the user,
e.g. via ``-DCMAKE_APPLE_SILICON_PROCESSOR=...``.

See also the :envvar:`CMAKE_APPLE_SILICON_PROCESSOR` environment variable.
