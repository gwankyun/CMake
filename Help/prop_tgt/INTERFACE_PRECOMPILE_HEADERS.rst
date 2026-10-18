INTERFACE_PRECOMPILE_HEADERS
----------------------------

.. versionadded:: 3.16

要预编译为消费目标的接口头文件列表。

Targets may populate this property to publish the header files
for consuming targets to precompile.  The :command:`target_precompile_headers`
command populates this property with values given to the ``PUBLIC`` and
``INTERFACE`` keywords.  Projects may also get and set the property directly.
See the discussion in :command:`target_precompile_headers` for guidance on
appropriate use of this property for installed or exported targets.

.. |genex_subject| replace:: ``INTERFACE_PRECOMPILE_HEADERS``
.. include:: ../include/GENEX_NOTE.rst
