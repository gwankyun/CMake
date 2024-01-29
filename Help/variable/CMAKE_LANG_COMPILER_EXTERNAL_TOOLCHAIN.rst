CMAKE_<LANG>_COMPILER_EXTERNAL_TOOLCHAIN
----------------------------------------

交叉编译的外部工具链，如果支持的话。

Some compiler toolchains do not ship their own auxiliary utilities such as
archivers and linkers.  The compiler driver may support a command-line argument
to specify the location of such tools.
``CMAKE_<LANG>_COMPILER_EXTERNAL_TOOLCHAIN`` may be set to a path to
the external toolchain and will be passed to the compiler driver if supported.

This variable may only be set in a toolchain file specified by
the :variable:`CMAKE_TOOLCHAIN_FILE` variable.
