CMAKE_<LANG>_ARCHIVE_CREATE
---------------------------

规则变量来创建一个新的静态归档。

This is a rule variable that tells CMake how to create a static
archive.  It is used in place of :variable:`CMAKE_<LANG>_CREATE_STATIC_LIBRARY`
on some platforms in order to support large object counts.  See also
:variable:`CMAKE_<LANG>_ARCHIVE_APPEND` and
:variable:`CMAKE_<LANG>_ARCHIVE_FINISH`.
