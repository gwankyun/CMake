CMAKE_<LANG>_DEVICE_LINK_MODE
-----------------------------

.. versionadded:: 4.0

定义了设备链接步骤的执行方式。可能的值如下：

``DRIVER``
  The compiler is used as driver for the device link step.

``LINKER``
  The linker is used directly for the device link step.

This variable is read-only. Setting it is undefined behavior.
