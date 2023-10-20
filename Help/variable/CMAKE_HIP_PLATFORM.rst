CMAKE_HIP_PLATFORM
------------------

.. versionadded:: 3.28

要编译HIP语言源的GPU平台。

The value must be one of:

``amd``
  AMD GPUs

``nvidia``
  NVIDIA GPUs

If not specified, a default is computed via ``hipconfig --platform``.

:variable:`CMAKE_HIP_ARCHITECTURES` entries are interpreted with
as architectures of the GPU platform.

:variable:`CMAKE_HIP_COMPILER <CMAKE_<LANG>_COMPILER>` must target
the same GPU platform.
