CMAKE_<LANG>_ARCHIVER_WRAPPER_FLAG
----------------------------------

.. versionadded:: 4.0

定义了编译器驱动选项的语法，用于将选项传递给归档工具。它将用于转换静态库选项中的\ ``ARCHIVER:``\
前缀（请参阅\ :prop_tgt:`STATIC_LIBRARY_OPTIONS`）。

This variable holds a :ref:`semicolon-separated list <CMake Language Lists>` of
tokens. If a space (i.e. " ") is specified as last token, flag and
``ARCHIVER:`` arguments will be specified as separate arguments to the compiler
driver. The :variable:`CMAKE_<LANG>_ARCHIVER_WRAPPER_FLAG_SEP` variable can be
specified to manage concatenation of arguments.

See :variable:`CMAKE_<LANG>_LINKER_WRAPPER_FLAG` variable for examples of
definitions because ``CMAKE_<LANG>_ARCHIVER_WRAPPER_FLAG`` use the same syntax.
