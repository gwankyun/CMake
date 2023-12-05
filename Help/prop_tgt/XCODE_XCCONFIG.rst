XCODE_XCCONFIG
--------------

.. versionadded:: 3.24

如果设置了，\ :generator:`Xcode`\ 生成器将把指定的文件注册为目标级XCConfig文件。对于全\
局XCConfig文件，请参阅\ :variable:`CMAKE_XCODE_XCCONFIG`\ 变量。

This feature is intended to ease migration from native Xcode projects
to CMake projects.

Contents of ``XCODE_XCCONFIG`` may use
:manual:`generator expressions <cmake-generator-expressions(7)>`.
