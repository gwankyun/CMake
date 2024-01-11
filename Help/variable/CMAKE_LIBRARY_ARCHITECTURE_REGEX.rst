CMAKE_LIBRARY_ARCHITECTURE_REGEX
--------------------------------

匹配可能的目标架构库目录名的正则表达式。

This is used to detect :variable:`CMAKE_<LANG>_LIBRARY_ARCHITECTURE` from the
implicit linker search path by matching the ``<arch>`` name.
