CMAKE_<LANG>_ARCHIVE_FINISH
---------------------------

规则变量来完成现有的静态存档。

This is a rule variable that tells CMake how to finish a static
archive.  It is used in place of :variable:`CMAKE_<LANG>_CREATE_STATIC_LIBRARY`
on some platforms in order to support large object counts.  See also
:variable:`CMAKE_<LANG>_ARCHIVE_CREATE` and
:variable:`CMAKE_<LANG>_ARCHIVE_APPEND`.
