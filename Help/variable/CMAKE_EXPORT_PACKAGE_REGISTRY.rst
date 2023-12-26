CMAKE_EXPORT_PACKAGE_REGISTRY
-----------------------------

.. versionadded:: 3.15

当\ :policy:`CMP0090`\ 设置为\ ``NEW``\ 时，启用\ :command:`export(PACKAGE)`\ 命令。

The :command:`export(PACKAGE)` command does nothing by default.  In some cases
it is desirable to write to the user package registry, so the
``CMAKE_EXPORT_PACKAGE_REGISTRY`` variable may be set to enable it.

If :policy:`CMP0090` is *not* set to ``NEW`` this variable does nothing, and
the :variable:`CMAKE_EXPORT_NO_PACKAGE_REGISTRY` variable controls the behavior
instead.

See also :ref:`Disabling the Package Registry`.
