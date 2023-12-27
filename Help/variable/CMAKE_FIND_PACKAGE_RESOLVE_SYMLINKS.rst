CMAKE_FIND_PACKAGE_RESOLVE_SYMLINKS
-----------------------------------

.. versionadded:: 3.14

设置为\ ``TRUE``\ 告诉\ :command:`find_package`\ 调用解析\ ``<PackageName>_DIR``\
值中的符号链接。

This is helpful in use cases where the package search path points at a
proxy directory in which symlinks to the real package locations appear.
This is not enabled by default because there are also common use cases
in which the symlinks should be preserved.
