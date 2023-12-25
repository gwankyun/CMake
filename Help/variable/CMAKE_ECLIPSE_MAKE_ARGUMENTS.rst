CMAKE_ECLIPSE_MAKE_ARGUMENTS
----------------------------

.. versionadded:: 3.6

这个缓存变量由Eclipse项目生成器使用。参阅\ :manual:`cmake-generators(7)`。

This variable holds arguments which are used when Eclipse invokes the make
tool. By default it is initialized to hold flags to enable parallel builds
(using -j typically).
