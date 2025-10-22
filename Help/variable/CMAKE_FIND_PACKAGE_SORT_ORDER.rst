CMAKE_FIND_PACKAGE_SORT_ORDER
-----------------------------

.. versionadded:: 3.7

.. versionchanged:: 4.2

  The default sort order has changed from ``NONE`` to ``NATURAL``.


目录排序的默认顺序，与使用\ :command:`find_package`\ 找到的包含通配表达式的搜索路径匹配。\
它可以假定为下列值之一：

``NONE``
  No attempt is done to sort directories.
  The first valid package found will be selected.

``NAME``
  Sort directories lexicographically before searching.

``NATURAL``
  Default. Sort directories using natural order (see ``strverscmp(3)`` manual),
  i.e. such that contiguous digits are compared as whole numbers.

Natural sorting is employed by default to return the highest version when
multiple versions of the same library are available to be found by
:command:`find_package`.  For example suppose that the following libraries have
package configuration files on disk, in a directory of the same name, with all
such directories residing in the same parent directory:

* ``libX-1.1.0``
* ``libX-1.2.9``
* ``libX-1.2.10``

The default order of ``NATURAL`` will select the one with the highest version
number, i.e. ``libX-1.2.10``.

The sort direction can be controlled using the
:variable:`CMAKE_FIND_PACKAGE_SORT_DIRECTION` variable (by default descending,
i.e. ``libX-1.2`` will be tested before ``libX-1.0`` and  ``lib-B`` will be
tested before ``lib-A``).
