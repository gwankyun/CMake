CMAKE_EXE_LINKER_FLAGS_INIT
---------------------------

.. versionadded:: 3.7

用于在第一次配置构建树时初始化\ :variable:`CMAKE_EXE_LINKER_FLAGS`\ 缓存项的值。\
该变量将由\ :variable:`工具链文件 <CMAKE_TOOLCHAIN_FILE>`\ 设置。CMake可以根据环境和\
目标平台在值前添加或追加内容。

See also the configuration-specific variable
:variable:`CMAKE_EXE_LINKER_FLAGS_<CONFIG>_INIT`.
