CMAKE_XCODE_XCCONFIG
--------------------

.. versionadded:: 3.24

如果设置了，:generator:`Xcode`\ 生成器将把指定的文件注册为全局XCConfig文件。对于目标级\
XCConfig文件，请参阅 :prop_tgt:`XCODE_XCCONFIG`\ 目标属性。

This feature is intended to ease migration from native Xcode projects
to CMake projects.

Contents of ``CMAKE_XCODE_XCCONFIG`` may use
:manual:`generator expressions <cmake-generator-expressions(7)>`.
