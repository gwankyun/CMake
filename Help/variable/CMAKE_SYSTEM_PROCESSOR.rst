CMAKE_SYSTEM_PROCESSOR
----------------------

在不进行交叉编译时，该变量与\ :variable:`CMAKE_HOST_SYSTEM_PROCESSOR`\ 变量具有相同的值。\
在许多情况下，这将与构建的目标体系结构相对应，但这并不能保证。（例如，在Windows上，即使使用\
带有32位目标的MSVC ``cl``\ 编译器，主机也可能是\ ``AMD64``。）

When cross-compiling, a :variable:`CMAKE_TOOLCHAIN_FILE` should set
the ``CMAKE_SYSTEM_PROCESSOR`` variable to match target architecture
that it specifies (via :variable:`CMAKE_<LANG>_COMPILER` and perhaps
:variable:`CMAKE_<LANG>_COMPILER_TARGET`).
