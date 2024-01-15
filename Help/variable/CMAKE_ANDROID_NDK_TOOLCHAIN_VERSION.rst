CMAKE_ANDROID_NDK_TOOLCHAIN_VERSION
-----------------------------------

.. versionadded:: 3.7

当\ :ref:`Cross Compiling for Android with the NDK`\ 时，该变量可以设置为指定要用作\
编译器的工具链的版本。

On NDK r19 or above, this variable must be unset or set to ``clang``.

On NDK r18 or below, this variable must be set to one of these forms:

* ``<major>.<minor>``: GCC of specified version
* ``clang<major>.<minor>``: Clang of specified version
* ``clang``: Clang of most recent available version

A toolchain of the requested version will be selected automatically to
match the ABI named in the :variable:`CMAKE_ANDROID_ARCH_ABI` variable.

If not specified, the default will be a value that selects the latest
available GCC toolchain.
