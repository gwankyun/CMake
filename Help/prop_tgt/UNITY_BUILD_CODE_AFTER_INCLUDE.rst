UNITY_BUILD_CODE_AFTER_INCLUDE
------------------------------

.. versionadded:: 3.16

:prop_tgt:`UNITY_BUILD`\ 功能在生成的unity源文件中的每个\ ``#include``\ 语句之后逐字\
包含的代码片段。例如：

.. code-block:: cmake

  set(after [[
  #if defined(NOMINMAX)
  #undef NOMINMAX
  #endif
  ]])
  set_target_properties(myTarget PROPERTIES
    UNITY_BUILD_CODE_AFTER_INCLUDE "${after}"
  )

See also :prop_tgt:`UNITY_BUILD_CODE_BEFORE_INCLUDE`.
