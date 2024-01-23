CMAKE_SHARED_LINKER_FLAGS_<CONFIG>_INIT
---------------------------------------

.. versionadded:: 3.7

用于在第一次配置构建树时初始化\ :variable:`CMAKE_SHARED_LINKER_FLAGS_<CONFIG>`\ 缓存\
项的值。该变量将由\ :variable:`工具链文件 <CMAKE_TOOLCHAIN_FILE>`\ 设置。CMake可以根据\
环境和目标平台在值前添加或追加内容。

See also :variable:`CMAKE_SHARED_LINKER_FLAGS_INIT`.
