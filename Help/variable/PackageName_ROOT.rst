<PackageName>_ROOT
------------------

.. versionadded:: 3.12

对\ :command:`find_package(<PackageName>)`\ 的调用将搜索由\ ``<PackageName>_ROOT``
CMake变量指定的前缀，其中\ ``<PackageName>``\ 是给定给\ :command:`find_package`\ 调\
用的名称（保留大小写），而\ ``_ROOT``\ 是字面值。例如，\ ``find_package(Foo)``\ 将搜索\
在\ ``Foo_ROOT`` CMake变量中指定的前缀（如果设置了）。参见策略\ :policy:`CMP0074`。

This variable may hold a single prefix or a
:ref:`semicolon-separated list <CMake Language Lists>` of multiple prefixes.

See also the :envvar:`<PackageName>_ROOT` environment variable.

.. variable:: <PACKAGENAME>_ROOT

  .. versionadded:: 3.27

  Calls to :command:`find_package(<PackageName>)` will also search in
  prefixes specified by the upper-case ``<PACKAGENAME>_ROOT`` CMake
  variable.  See policy :policy:`CMP0144`.
