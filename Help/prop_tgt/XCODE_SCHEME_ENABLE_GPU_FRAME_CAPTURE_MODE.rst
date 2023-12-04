XCODE_SCHEME_ENABLE_GPU_FRAME_CAPTURE_MODE
------------------------------------------

.. versionadded:: 3.23

在生成的Xcode方案的选项部分中设置\ ``GPU Frame Capture``\ 的属性值。例如\ `Metal`\ 和\
`Disabled`。

This property is initialized by the value of the variable
:variable:`CMAKE_XCODE_SCHEME_ENABLE_GPU_FRAME_CAPTURE_MODE`
if it is set when a target is created.

Please refer to the :prop_tgt:`XCODE_GENERATE_SCHEME` target property
documentation to see all Xcode schema related properties.
