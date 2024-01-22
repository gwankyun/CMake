CMAKE_MACOSX_BUNDLE
-------------------

目标的\ :prop_tgt:`MACOSX_BUNDLE`\ 默认值。

This variable is used to initialize the :prop_tgt:`MACOSX_BUNDLE` property on
all the targets.  See that target property for additional information.

This variable is set to ``ON`` by default if :variable:`CMAKE_SYSTEM_NAME`
equals to :ref:`iOS, tvOS, visionOS or watchOS <Cross Compiling for iOS, tvOS, visionOS, or watchOS>`.
