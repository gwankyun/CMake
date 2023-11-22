UNITY_BUILD_CODE_BEFORE_INCLUDE
-------------------------------

.. versionadded:: 3.16

在生成的unity源文件中，:prop_tgt:`UNITY_BUILD`\ 特性在每个\ ``#include``\ 语句之前逐\
字包含的代码片段。例如：

.. code-block:: cmake

  set(before [[
  #if !defined(NOMINMAX)
  #define NOMINMAX
  #endif
  ]])
  set_target_properties(myTarget PROPERTIES
    UNITY_BUILD_CODE_BEFORE_INCLUDE "${before}"
  )

See also :prop_tgt:`UNITY_BUILD_CODE_AFTER_INCLUDE`.
