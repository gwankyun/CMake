CMAKE_SUPPRESS_REGENERATION
---------------------------

.. versionadded:: 3.12

如果\ ``CMAKE_SUPPRESS_REGENERATION``\ 是\ ``OFF``，这是默认的，那么CMake会添加一个\
特殊的目标，所有其他目标都依赖于这个目标来检查构建系统，当目标规格源发生变化时，可以选择重新\
运行CMake来重新生成构建系统。

If this variable evaluates to ``ON`` at the end of the top-level
``CMakeLists.txt`` file, CMake will not add the regeneration target to the
build system or perform any build system checks.
