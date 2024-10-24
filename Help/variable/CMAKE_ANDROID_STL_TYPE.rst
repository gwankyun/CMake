CMAKE_ANDROID_STL_TYPE
----------------------

.. versionadded:: 3.4

当\ :ref:`Cross Compiling for Android with NVIDIA Nsight Tegra Visual Studio Edition`\
时，这个变量可以被设置为指定\ :prop_tgt:`ANDROID_STL_TYPE`\ 目标属性的默认值。有关其他信息，\
请参阅目标属性。

When :ref:`Cross Compiling for Android with the NDK`, this variable may be
set to specify the STL variant to be used.  The value may be one of:

``none``
  No C++ Support
``system``
  Minimal C++ without STL
``gabi++_static``
  GAbi++ Static
``gabi++_shared``
  GAbi++ Shared
``gnustl_static``
  GNU libstdc++ Static
``gnustl_shared``
  GNU libstdc++ Shared
``c++_static``
  LLVM libc++ Static
``c++_shared``
  LLVM libc++ Shared
``stlport_static``
  STLport Static
``stlport_shared``
  STLport Shared

The default value is ``gnustl_static`` on NDK versions that provide it
and otherwise ``c++_static``.  Note that this default differs from
the native NDK build system because CMake may be used to build projects for
Android that are not natively implemented for it and use the C++ standard
library.
