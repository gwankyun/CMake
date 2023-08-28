<PackageName>_ROOT
------------------

.. versionadded:: 3.12

.. include:: ENV_VAR.txt

对\ :command:`find_package(<PackageName>)`\ 的调用将在\ ``<PackageName>_ROOT``\
环境变量指定的前缀中进行搜索，其中\ ``<PackageName>``\ 是给定给\ :command:`find_package`\
调用的名称（保留大小写），而\ ``_ROOT``\ 是字面值。例如，\ ``find_package(Foo)``\ 将搜\
索在\ ``Foo_ROOT``\ 环境变量中指定的前缀（如果设置了）。参见政策\ :policy:`CMP0074`。

This variable may hold a single prefix or a list of prefixes separated
by ``:`` on UNIX or ``;`` on Windows (the same as the ``PATH`` environment
variable convention on those platforms).

See also the :variable:`<PackageName>_ROOT` CMake variable.

.. envvar:: <PACKAGENAME>_ROOT

  .. versionadded:: 3.27

  Calls to :command:`find_package(<PackageName>)` will also search in
  prefixes specified by the upper-case ``<PACKAGENAME>_ROOT`` environment
  variable.  See policy :policy:`CMP0144`.

.. note::

  Note that the ``<PackageName>_ROOT`` and ``<PACKAGENAME>_ROOT``
  environment variables are distinct only on platforms that have
  case-sensitive environments.
