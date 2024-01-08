CMAKE_XCODE_GENERATE_TOP_LEVEL_PROJECT_ONLY
-------------------------------------------

.. versionadded:: 3.11

如果启用，:generator:`Xcode`\ 生成器将只为最上面的\ :command:`project()`\ 命令生成一\
个Xcode项目文件，而不是为每个\ ``project()``\ 命令生成一个。

This could be useful to speed up the CMake generation step for
large projects and to work-around a bug in the ``ZERO_CHECK`` logic.
