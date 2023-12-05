XCODE_SCHEME_WORKING_DIRECTORY
------------------------------

.. versionadded:: 3.17

在生成的Xcode方案中指定\ *Run*\ 和\ *Profile*\ 操作的\ ``Working Directory``。如果值\
包含要计算的生成器表达式。

This property is initialized by the value of the variable
:variable:`CMAKE_XCODE_SCHEME_WORKING_DIRECTORY` if it is set
when a target is created.

Please refer to the :prop_tgt:`XCODE_GENERATE_SCHEME` target property
documentation to see all Xcode schema related properties.
