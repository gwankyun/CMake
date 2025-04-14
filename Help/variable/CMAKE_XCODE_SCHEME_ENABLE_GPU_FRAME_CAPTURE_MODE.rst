CMAKE_XCODE_SCHEME_ENABLE_GPU_FRAME_CAPTURE_MODE
------------------------------------------------

.. versionadded:: 3.23

在生成的Xcode方案的“选项”部分填充\ ``GPU Frame Capture``。示例值包括\ ``Metal``\ 和\
``Disabled``。

This variable initializes the
:prop_tgt:`XCODE_SCHEME_ENABLE_GPU_FRAME_CAPTURE_MODE`
property on all targets.

Please refer to the :prop_tgt:`XCODE_GENERATE_SCHEME` target property
documentation to see all Xcode schema related properties.
