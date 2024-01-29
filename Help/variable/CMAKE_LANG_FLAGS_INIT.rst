CMAKE_<LANG>_FLAGS_INIT
-----------------------

.. versionadded:: 3.7

用于在第一次为语言\ ``<LANG>``\ 配置构建树时初始化\ :variable:`CMAKE_<LANG>_FLAGS`\
缓存项的值。该变量将由\ :variable:`工具链文件 <CMAKE_TOOLCHAIN_FILE>`\ 设置。CMake可以\
根据环境和目标平台在值前添加或追加内容。例如，将添加一个\ ``xxxFLAGS``\ 环境变量的内容，\
其中\ ``xxx``\ 是特定于语言的，但不一定与\ ``<LANG>``\ 相同（例如\ ``CXX``\ 的\
:envvar:`CXXFLAGS`，\ ``Fortran``\ 的\ :envvar:`FFLAGS`，等等）。该值是一个命令行\
字符串片段。因此，多个选项应该用空格分隔，带空格的选项应该加引号。

See also the configuration-specific
:variable:`CMAKE_<LANG>_FLAGS_<CONFIG>_INIT` variable.
