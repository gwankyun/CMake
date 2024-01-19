CMAKE_GLOBAL_AUTORCC_TARGET_NAME
--------------------------------

.. versionadded:: 3.14

更改全局\ ``autorcc``\ 目标的名称。

When :variable:`CMAKE_GLOBAL_AUTORCC_TARGET` is enabled, a global custom target
named ``autorcc`` is created.  ``CMAKE_GLOBAL_AUTORCC_TARGET_NAME``
allows to set a different name for that target.

By default ``CMAKE_GLOBAL_AUTORCC_TARGET_NAME`` is unset.

See the :manual:`cmake-qt(7)` manual for more information on using CMake
with Qt.
