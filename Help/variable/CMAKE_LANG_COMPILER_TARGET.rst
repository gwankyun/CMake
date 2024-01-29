CMAKE_<LANG>_COMPILER_TARGET
----------------------------

交叉编译的目标，如果支持的话。

Some compiler drivers are inherently cross-compilers, such as clang and
QNX qcc. These compiler drivers support a command-line argument to specify
the target to cross-compile for.

This variable may only be set in a toolchain file specified by
the :variable:`CMAKE_TOOLCHAIN_FILE` variable.
