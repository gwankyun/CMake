CMAKE_FIND_LIBRARY_PREFIXES
---------------------------

查找库时要添加的前缀。

This specifies what prefixes to add to library names when the
:command:`find_library` command looks for libraries.  On UNIX systems this is
typically ``lib``, meaning that when trying to find the ``foo`` library it
will look for ``libfoo``.
