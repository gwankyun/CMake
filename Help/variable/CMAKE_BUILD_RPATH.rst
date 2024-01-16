CMAKE_BUILD_RPATH
-----------------

.. versionadded:: 3.8

:ref:`分号分隔的列表 <CMake Language Lists>`，指定要添加到构建树中链接的二进制文件中的\
运行时路径（\ ``RPATH``\ ）条目（对于支持它的平台）。这些条目\ *不会*\ 用于安装树中的二进\
制文件。另请参阅\ :variable:`CMAKE_INSTALL_RPATH`\ 变量。

This is used to initialize the :prop_tgt:`BUILD_RPATH` target property
for all targets.
