STATIC_LIBRARY_OPTIONS
----------------------

.. versionadded:: 3.13

静态库目标的归档器（或MSVC库管理）标志。共享库、模块或可执行文件的目标需要使用\
:prop_tgt:`LINK_OPTIONS`\ 目标属性。

This property holds a :ref:`semicolon-separated list <CMake Language Lists>` of options
specified so far for its target.  Use :command:`set_target_properties` or
:command:`set_property` commands to set its content.

.. |genex_subject| replace:: ``STATIC_LIBRARY_OPTIONS``
.. include:: ../include/GENEX_NOTE.rst

.. note::

  This property must be used in preference to :prop_tgt:`STATIC_LIBRARY_FLAGS`
  property.

.. include:: ../command/include/OPTIONS_SHELL.rst

.. include:: ../prop_tgt/include/STATIC_LIBRARY_OPTIONS_ARCHIVER.rst
