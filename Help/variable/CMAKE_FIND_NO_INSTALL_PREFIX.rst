CMAKE_FIND_NO_INSTALL_PREFIX
----------------------------

:variable:`CMAKE_SYSTEM_PREFIX_PATH`\ 中不包含\ :variable:`CMAKE_INSTALL_PREFIX`\
和\ :variable:`CMAKE_STAGING_PREFIX`\ 变量。默认情况下，CMake将这些项目目标前缀添加到\
:variable:`CMAKE_SYSTEM_PREFIX_PATH`\ 中，以便支持构建一系列依赖包并将它们安装到公共前\
缀中。将\ ``CMAKE_FIND_NO_INSTALL_PREFIX``\ 设置为\ ``TRUE``\ 可以抑制此行为。

The :variable:`CMAKE_SYSTEM_PREFIX_PATH` is initialized on the first call to a
:command:`project` or :command:`enable_language` command.  Therefore one must
set ``CMAKE_FIND_NO_INSTALL_PREFIX`` before this in order to take effect.  A
user may set the variable as a cache entry on the command line to achieve this.

Note that the prefix(es) may still be searched for other reasons, such as being
the same prefix as the CMake installation, or for being a built-in system
prefix.
