AIX_SHARED_LIBRARY_ARCHIVE
--------------------------

.. versionadded:: 3.31

在AIX上，启用创建共享库归档。这将把共享对象\ ``.so``\ 文件放在一个归档文件\ ``.a``\ 中。

By default, CMake creates shared libraries on AIX as plain
shared object ``.so`` files for consistency with other UNIX platforms.
Alternatively, set this property to a true value to create a shared
library archive instead, as is AIX convention.

When a shared library is archived the shared object in the archive
does not record any version information from :prop_tgt:`VERSION` or
:prop_tgt`SOVERSION` target properties.

This property defaults to :variable:`CMAKE_AIX_SHARED_LIBRARY_ARCHIVE`
if that variable is set when a ``SHARED`` library target is created
by :command:`add_library`.
