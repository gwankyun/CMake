LINK_DEPENDS
------------

目标二进制文件所依赖进行链接的附加文件。

Specifies a semicolon-separated list of full-paths to files on which
the link rule for this target depends.  The target binary will be
linked if any of the named files is newer than it.

This property is supported only by :generator:`Ninja` and
:ref:`Makefile Generators`.  It is
intended to specify dependencies on "linker scripts" for custom Makefile link
rules.

.. |genex_subject| replace:: ``LINK_DEPENDS``
.. include:: ../include/GENEX_NOTE.rst
