CMAKE_POSITION_INDEPENDENT_CODE
-------------------------------

目标的\ :prop_tgt:`POSITION_INDEPENDENT_CODE`\ 默认值。

This variable is used to initialize the
:prop_tgt:`POSITION_INDEPENDENT_CODE` property on targets that
are not ``SHARED`` or ``MODULE`` library targets.
If set, its value is also used by the :command:`try_compile` command.
