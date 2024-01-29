CMAKE_<LANG>_FLAGS_<CONFIG>
---------------------------

为\ ``<CONFIG>``\ 配置构建时使用的语言\ ``<LANG>``\ 的语言范围标志。这些标志将被传递给\
相应配置中的编译器的所有调用。这包括驱动编译的调用和驱动链接的调用。

The flags in this variable will be passed after those in the
:variable:`CMAKE_<LANG>_FLAGS` variable.  On invocations driving compiling,
flags from both variables will be passed before flags added by commands
such as :command:`add_compile_options` and :command:`target_compile_options`.
On invocations driving linking, they will be passed before flags added by
commands such as :command:`add_link_options` and
:command:`target_link_options`.
