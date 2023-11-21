MACOSX_RPATH
------------

此目标在macOS或iOS上是否在运行时使用rpath定位。

When this property is set to ``TRUE``, the directory portion of
the ``install_name`` field of this shared library will be ``@rpath``
unless overridden by :prop_tgt:`INSTALL_NAME_DIR`.  This indicates
the shared library is to be found at runtime using runtime
paths (rpaths).

This property is initialized by the value of the variable
:variable:`CMAKE_MACOSX_RPATH` if it is set when a target is
created.

Runtime paths will also be embedded in binaries using this target and
can be controlled by the :prop_tgt:`INSTALL_RPATH` target property on
the target linking to this target.

Policy :policy:`CMP0042` was introduced to change the default value of
``MACOSX_RPATH`` to ``TRUE``.  This is because use of ``@rpath`` is a
more flexible and powerful alternative to ``@executable_path`` and
``@loader_path``.
