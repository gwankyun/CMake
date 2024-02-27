CTEST_MEMORYCHECK_SANITIZER_OPTIONS
-----------------------------------

.. versionadded:: 3.1

在\ :manual:`ctest(1)`\ 仪表板客户端脚本中指定CTest ``MemoryCheckSanitizerOptions``\ 设置。

CTest prepends correct sanitizer options ``*_OPTIONS``
environment variable to executed command. CTests adds
its own ``log_path`` to sanitizer options, don't provide your
own ``log_path``.
