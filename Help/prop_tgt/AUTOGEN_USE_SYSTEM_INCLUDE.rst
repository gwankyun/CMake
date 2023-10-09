AUTOGEN_USE_SYSTEM_INCLUDE
--------------------------

.. versionadded:: 3.27

``AUTOGEN_USE_SYSTEM_INCLUDE``\ 是一个布尔属性，可以在目标上设置，以指示应该将autogen\
目标包含目录作为系统包含目录或普通包含目录添加到目标。

If this property is not set, the autogen target include directory is added
as a system include directory by default.  See policy :policy:`CMP0151`.

See the :manual:`cmake-qt(7)` manual for more information on using CMake
with Qt.

This property is initialized by the
:variable:`CMAKE_AUTOGEN_USE_SYSTEM_INCLUDE` variable if it is set when
a target is created.
