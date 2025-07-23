AUTOMOC_INCLUDE_DIRECTORIES
---------------------------

.. versionadded:: 4.1

指定零个或多个包含目录，供AUTOMOC显式传递给Qt元对象编译器（\ ``moc``\ ），\
而非自动发现目标的包含目录。

When this property is set on a target, only the directories listed here will be
used by :prop_tgt:`AUTOMOC`, and any other include paths will be ignored.

This property may contain :manual:`generator expressions <cmake-generator-expressions(7)>`.

All directory paths in the final evaluated result **must be absolute**. If any
non-absolute paths are present after generator expression evaluation,
configuration will fail with an error.

See also the :variable:`CMAKE_AUTOMOC_INCLUDE_DIRECTORIES` variable, which can
be used to initialize this property on all targets.

Example
^^^^^^^

.. code-block:: cmake

  add_library(myQtLib ...)
  set_property(TARGET myQtLib PROPERTY AUTOMOC_INCLUDE_DIRECTORIES
    "${CMAKE_CURRENT_SOURCE_DIR}/include/myQtLib"
  )
