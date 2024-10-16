AUTOMOC_COMPILER_PREDEFINES
---------------------------

.. versionadded:: 3.10

:prop_tgt:`AUTOMOC`\ 使用布尔值来确定是否应该生成编译器预定义文件\ ``moc_predefs.h``。

CMake generates a ``moc_predefs.h`` file with compiler pre definitions
from the output of the command defined in
:variable:`CMAKE_CXX_COMPILER_PREDEFINES_COMMAND <CMAKE_<LANG>_COMPILER_PREDEFINES_COMMAND>`
when

- :prop_tgt:`AUTOMOC` is enabled,
- ``AUTOMOC_COMPILER_PREDEFINES`` is enabled,
- :variable:`CMAKE_CXX_COMPILER_PREDEFINES_COMMAND <CMAKE_<LANG>_COMPILER_PREDEFINES_COMMAND>` isn't empty and
- the Qt version is greater or equal 5.8.

The ``moc_predefs.h`` file, which is generated in :prop_tgt:`AUTOGEN_BUILD_DIR`,
is passed to ``moc`` as the argument to the ``--include`` option.

By default ``AUTOMOC_COMPILER_PREDEFINES`` is initialized from
:variable:`CMAKE_AUTOMOC_COMPILER_PREDEFINES`, which is ON by default.

See the :manual:`cmake-qt(7)` manual for more information on using CMake
with Qt.
