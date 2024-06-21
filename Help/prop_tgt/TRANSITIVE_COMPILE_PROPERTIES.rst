TRANSITIVE_COMPILE_PROPERTIES
-----------------------------

.. versionadded:: 3.30

目标及其依赖项上的\ :genex:`TARGET_PROPERTY`\ 生成器表达式计算为从链接依赖项的传递闭包中\
收集的值的联合，不包括由\ :genex:`LINK_ONLY`\ 保护的条目。

The value is a :ref:`semicolon-separated list <CMake Language Lists>`
of :ref:`custom transitive property <Custom Transitive Properties>` names.
Any leading ``INTERFACE_`` prefix is ignored, e.g., ``INTERFACE_PROP`` is
treated as just ``PROP``.

See documentation of the :genex:`TARGET_PROPERTY` generator expression
for details of custom transitive property evaluation.  See also the
:prop_tgt:`TRANSITIVE_LINK_PROPERTIES` target property, which includes
entries guarded by :genex:`LINK_ONLY`.
