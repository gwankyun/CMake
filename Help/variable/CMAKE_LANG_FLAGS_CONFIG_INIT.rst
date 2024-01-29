CMAKE_<LANG>_FLAGS_<CONFIG>_INIT
--------------------------------

.. versionadded:: 3.11

用于在第一次为语言\ ``<LANG>``\ 配置构建树时初始化\
:variable:`CMAKE_<LANG>_FLAGS_<CONFIG>`\ 缓存项的值。该变量将由\
:variable:`工具链文件 <CMAKE_TOOLCHAIN_FILE>`\ 设置。CMake可以根据环境和目标平台在值前\
添加或追加内容。

See also :variable:`CMAKE_<LANG>_FLAGS_INIT`.
