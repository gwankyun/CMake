CMAKE_GLOBAL_AUTOGEN_TARGET_NAME
--------------------------------

.. versionadded:: 3.14

修改全局\ ``autogen``\ 目标的名称。

When :variable:`CMAKE_GLOBAL_AUTOGEN_TARGET` is enabled, a global custom target
named ``autogen`` is created.  ``CMAKE_GLOBAL_AUTOGEN_TARGET_NAME``
allows to set a different name for that target.

By default ``CMAKE_GLOBAL_AUTOGEN_TARGET_NAME`` is unset.

See the :manual:`cmake-qt(7)` manual for more information on using CMake
with Qt.
