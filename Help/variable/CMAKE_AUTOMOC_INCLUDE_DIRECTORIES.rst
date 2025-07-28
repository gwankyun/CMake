CMAKE_AUTOMOC_INCLUDE_DIRECTORIES
---------------------------------

.. versionadded:: 4.1

指定零个或多个包含目录，供AUTOMOC显式传递给Qt元对象编译器（\ ``moc``\ ），\
而非自动发现每个目标的包含目录。

The directories listed here will replace any include paths discovered from
target properties such as :prop_tgt:`INCLUDE_DIRECTORIES`.

This variable is used to initialize the :prop_tgt:`AUTOMOC_INCLUDE_DIRECTORIES`
property on all the targets.  See that target property for additional
information.
