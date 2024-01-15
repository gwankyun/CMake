CMAKE_ANDROID_NDK_DEPRECATED_HEADERS
------------------------------------

.. versionadded:: 3.9

当\ :ref:`Cross Compiling for Android with the NDK`\ 时，该变量可以设置为指定是否使\
用已弃用的每个api级别的头文件而不是统一的头文件。

If not specified, the default will be *false* if using a NDK version
that provides the unified headers and *true* otherwise.
