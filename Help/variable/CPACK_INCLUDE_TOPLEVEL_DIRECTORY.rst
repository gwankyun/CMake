CPACK_INCLUDE_TOPLEVEL_DIRECTORY
--------------------------------

布尔开关，包括/排除顶层目录。

When preparing a package CPack installs the item under the so-called
top level directory.  The purpose of is to include (set to ``1`` or ``ON`` or
``TRUE``) the top level directory in the package or not (set to ``0`` or
``OFF`` or ``FALSE``).

Each CPack generator has a built-in default value for this variable.
E.g.  Archive generators (ZIP, TGZ, ...) includes the top level
whereas RPM or DEB don't.  The user may override the default value by
setting this variable.

There is a similar variable
:variable:`CPACK_COMPONENT_INCLUDE_TOPLEVEL_DIRECTORY` which may be used
to override the behavior for the component packaging
case which may have different default value for historical (now
backward compatibility) reason.
