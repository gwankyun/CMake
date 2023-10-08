ANDROID_ARCH
------------

.. versionadded:: 3.4

当\ :ref:`Cross Compiling for Android with NVIDIA Nsight Tegra Visual Studio Edition`\
时，此属性设置Android目标架构。

This is a string property that could be set to the one of
the following values:

* ``armv7-a``: "ARMv7-A (armv7-a)"
* ``armv7-a-hard``: "ARMv7-A, hard-float ABI (armv7-a)"
* ``arm64-v8a``: "ARMv8-A, 64bit (arm64-v8a)"
* ``x86``: "x86 (x86)"
* ``x86_64``: "x86_64 (x86_64)"

This property is initialized by the value of the
:variable:`CMAKE_ANDROID_ARCH` variable if it is set
when a target is created.
