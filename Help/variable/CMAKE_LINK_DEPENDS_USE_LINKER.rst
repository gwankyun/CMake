CMAKE_LINK_DEPENDS_USE_LINKER
-----------------------------

.. versionadded:: 3.27

对于\ :ref:`Makefile <Makefile Generators>`\ 和\ :ref:`Ninja <Ninja Generators>`\
生成器，链接依赖项现在是由链接器本身生成的。通过将此变量定义为值\ ``FALSE``，则可以停用此功能。

This feature is also deactivated if the :prop_tgt:`LINK_DEPENDS_NO_SHARED`
target property is true.

.. note::

  CMake version |release| defaults this variable to ``FALSE`` because
  GNU binutils linkers (``ld``, ``ld.bfd``, ``ld.gold``) generate spurious
  dependencies on temporary files when LTO is enabled.  See `GNU bug 30568`_.

.. _`GNU bug 30568`: https://sourceware.org/bugzilla/show_bug.cgi?id=30568
