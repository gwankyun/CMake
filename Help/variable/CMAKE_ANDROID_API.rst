CMAKE_ANDROID_API
-----------------

.. versionadded:: 3.1

当\ :ref:`Cross Compiling for Android with NVIDIA Nsight Tegra Visual Studio Edition`，\
这个变量可以被设置为指定\ :prop_tgt:`ANDROID_API`\ 目标属性的默认值。有关其他信息，请参\
阅目标属性。

When :ref:`Cross Compiling for Android`, the :variable:`CMAKE_SYSTEM_VERSION`
variable represents the Android API version number targeted.  For historical
reasons, if a toolchain file sets ``CMAKE_ANDROID_API``, but not
``CMAKE_SYSTEM_VERSION``, the latter will be initialized using the former.
