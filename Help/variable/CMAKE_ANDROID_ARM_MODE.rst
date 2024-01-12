CMAKE_ANDROID_ARM_MODE
----------------------

.. versionadded:: 3.7

当\ :ref:`Cross Compiling for Android`\ 和\ :variable:`CMAKE_ANDROID_ARCH_ABI`\
设置为其中一种\ ``armeabi``\ 架构时，将\ ``CMAKE_ANDROID_ARM_MODE``\ 设置为\ ``ON``\
以针对32位ARM处理器（\ ``-marm``\ ）。否则，默认是针对16位Thumb处理器（\ ``-mthumb``\ ）。
