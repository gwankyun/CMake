CMAKE_OBJDUMP
-------------

主机系统上\ ``objdump``\ 可执行文件的路径。这个工具通常是类Unix系统上Binutils工具集的一部分，\
用于提供已编译目标文件的相关信息。

This cache variable may be populated by CMake when project languages are
enabled using the :command:`project` or :command:`enable_language` commands.

See Also
^^^^^^^^

* The :command:`file(GET_RUNTIME_DEPENDENCIES)` command provides a more general
  way to get information from runtime binaries.
* The :variable:`CPACK_OBJDUMP_EXECUTABLE` variable.
