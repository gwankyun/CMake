COMPILE_FLAGS
-------------

编译此源文件时要添加的其他标志。

The ``COMPILE_FLAGS`` property, managed as a string, sets additional compiler
flags used that will be added to the list of compile flags when this source
file builds.  The flags will be added after target-wide flags.

Use :prop_sf:`COMPILE_DEFINITIONS` to pass additional preprocessor definitions.

.. |genex_subject| replace:: ``COMPILE_FLAGS``
.. include:: ../include/GENEX_NOTE_PER_SOURCE.rst

.. note::

  This property has been superseded by the :prop_sf:`COMPILE_OPTIONS` property.
