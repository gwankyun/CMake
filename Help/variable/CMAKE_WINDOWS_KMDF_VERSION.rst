CMAKE_WINDOWS_KMDF_VERSION
--------------------------

.. versionadded:: 3.31

指定\ `内核模式驱动框架`_\ 的目标版本。

A :variable:`toolchain file <CMAKE_TOOLCHAIN_FILE>` that sets
:variable:`CMAKE_SYSTEM_NAME` to ``WindowsKernelModeDriver``
must also set ``CMAKE_WINDOWS_KMDF_VERSION`` to specify the
KMDF target version.

.. _`内核模式驱动框架`: https://learn.microsoft.com/en-us/windows-hardware/drivers/wdf/kmdf-version-history
