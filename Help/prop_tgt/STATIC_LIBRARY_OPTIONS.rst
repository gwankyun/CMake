STATIC_LIBRARY_OPTIONS
----------------------

.. versionadded:: 3.13

静态库目标的归档器（或MSVC库管理）标志。共享库、模块或可执行文件的目标需要使用\
:prop_tgt:`LINK_OPTIONS`\ 目标属性。

This property holds a :ref:`semicolon-separated list <CMake Language Lists>` of options
specified so far for its target.  Use :command:`set_target_properties` or
:command:`set_property` commands to set its content.

Contents of ``STATIC_LIBRARY_OPTIONS`` may use "generator expressions" with the
syntax ``$<...>``.  See the :manual:`cmake-generator-expressions(7)` manual
for available expressions.  See the :manual:`cmake-buildsystem(7)` manual
for more on defining buildsystem properties.

.. note::

  This property must be used in preference to :prop_tgt:`STATIC_LIBRARY_FLAGS`
  property.

.. include:: ../command/OPTIONS_SHELL.txt
