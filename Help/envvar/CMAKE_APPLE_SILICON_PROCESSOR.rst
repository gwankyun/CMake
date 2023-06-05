CMAKE_APPLE_SILICON_PROCESSOR
-----------------------------

.. versionadded:: 3.19.2

.. include:: ENV_VAR.txt

在运行macOS的Apple Silicon主机上，设置这个环境变量来告诉CMake
:variable:`CMAKE_HOST_SYSTEM_PROCESSOR`\ 使用什么架构。取值为\ ``arm64``\ 或\ ``x86_64``。

The :variable:`CMAKE_APPLE_SILICON_PROCESSOR` normal variable, if set,
overrides this environment variable.
