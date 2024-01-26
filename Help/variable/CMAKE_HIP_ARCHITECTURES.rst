CMAKE_HIP_ARCHITECTURES
-----------------------

.. versionadded:: 3.21

生成设备代码的GPU架构列表。架构名称是基于\ :variable:`CMAKE_HIP_PLATFORM`\ 进行解释的。

This is initialized based on the value of :variable:`CMAKE_HIP_PLATFORM`:

``amd``
  Uses architectures reported by ``rocm_agent_enumerator``, if available,
  and otherwise to a default chosen by the compiler.

This variable is used to initialize the :prop_tgt:`HIP_ARCHITECTURES` property
on all targets. See the target property for additional information.
