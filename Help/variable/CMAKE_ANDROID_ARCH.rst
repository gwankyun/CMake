CMAKE_ANDROID_ARCH
------------------

.. versionadded:: 3.4

当\ :ref:`Cross Compiling for Android with NVIDIA Nsight Tegra Visual Studio Edition`\
时，这个变量可以被设置为指定\ :prop_tgt:`ANDROID_ARCH`\ 目标属性的默认值。有关其他信息，\
请参阅目标属性。

Otherwise, when :ref:`Cross Compiling for Android`, this variable provides
the name of the Android architecture corresponding to the value of the
:variable:`CMAKE_ANDROID_ARCH_ABI` variable.  The architecture name
may be one of:

* ``arm``
* ``arm64``
* ``mips``
* ``mips64``
* ``x86``
* ``x86_64``
