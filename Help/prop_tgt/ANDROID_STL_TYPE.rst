ANDROID_STL_TYPE
----------------

.. versionadded:: 3.4

当\ :ref:`Cross Compiling for Android with NVIDIA Nsight Tegra Visual Studio Edition`\
时，此属性指定项目的STL支持类型。这是一个字符串属性，可以设置为以下值之一：

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
``stlport_static``
  STLport Static
``stlport_shared``
  STLport Shared

This property is initialized by the value of the
:variable:`CMAKE_ANDROID_STL_TYPE` variable if it is set when a target is
created.
