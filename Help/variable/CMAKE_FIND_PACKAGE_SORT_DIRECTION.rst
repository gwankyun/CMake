CMAKE_FIND_PACKAGE_SORT_DIRECTION
---------------------------------

.. versionadded:: 3.7

:variable:`CMAKE_FIND_PACKAGE_SORT_ORDER`\ 使用的排序方向。它可以假设下列值之一：

``DEC``
  Default.  Ordering is done in descending mode.
  The highest folder found will be tested first.

``ASC``
  Ordering is done in ascending mode.
  The lowest folder found will be tested first.

If :variable:`CMAKE_FIND_PACKAGE_SORT_ORDER` is not set or is set to ``NONE``
this variable has no effect.
