CMAKE_<LANG>_LIBRARY_ARCHITECTURE
---------------------------------

为\ ``<LANG>``\ 检测到的目标体系结构库目录名。

If the ``<LANG>`` compiler passes to the linker an architecture-specific
system library search directory such as ``<prefix>/lib/<arch>`` this
variable contains the ``<arch>`` name if/as detected by CMake.
