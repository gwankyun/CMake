CMAKE_AUTOGEN_ORIGIN_DEPENDS
----------------------------

.. versionadded:: 3.14

将原始目标依赖项转发到相应的\ :ref:`<ORIGIN>_autogen`\ 目标。

  .. note::

    If Qt 5.15 or later is used and the generator is either :generator:`Ninja`
    or :ref:`Makefile Generators`, additional target dependencies are added to
    the :ref:`<ORIGIN>_autogen_timestamp_deps` target instead of the
    :ref:`<ORIGIN>_autogen` target.

This variable is used to initialize the :prop_tgt:`AUTOGEN_ORIGIN_DEPENDS`
property on all the targets.  See that target property for additional
information.

By default ``CMAKE_AUTOGEN_ORIGIN_DEPENDS`` is ``ON``.
