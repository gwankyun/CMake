AUTOMOC_TARGETS_FOLDER
----------------------

CMake为启用\ :prop_tgt:`AUTOMOC`\ 的目标自动添加的\ ``*_autogen``\ 目标\
:prop_tgt:`FOLDER`\ 名称。

This property is obsolete.  Use :prop_gbl:`AUTOGEN_TARGETS_FOLDER` instead.

If not set, CMake uses the :prop_tgt:`FOLDER` property of the parent target as a
default value for this property.  See also the documentation for the
:prop_tgt:`FOLDER` target property and the :prop_tgt:`AUTOMOC` target property.
