CMAKE_VS_GLOBALS
----------------

.. versionadded:: 3.13

每个目标要设置的\ ``Key=Value``\ 记录列表作为带有\ ``variable=Key``\ 及\ ``Value``\
值的目标属性\ :prop_tgt:`VS_GLOBAL_<variable>`。

For example:

.. code-block:: cmake

  set(CMAKE_VS_GLOBALS
    "DefaultLanguage=en-US"
    "MinimumVisualStudioVersion=14.0"
    )

will set properties ``VS_GLOBAL_DefaultLanguage`` to ``en-US`` and
``VS_GLOBAL_MinimumVisualStudioVersion`` to ``14.0`` for all targets
(except for ``INTERFACE`` libraries).

This variable is meant to be set by a
:variable:`toolchain file <CMAKE_TOOLCHAIN_FILE>`.
