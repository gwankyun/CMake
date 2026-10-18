CMAKE_<LANG>_HOST_COMPILER_ID
-----------------------------

.. versionadded:: 3.31

当\ ``<LANG>``\ 是\ ``CUDA``\ 或\ ``HIP``\ 且\ :variable:`CMAKE_<LANG>_COMPILER_ID`\
是\ ``NVIDIA``\ 时，此变量可用。它包含了\ ``nvcc``\ 调用的宿主编译器的身份，默认情况下或由\
:variable:`CMAKE_<LANG>_HOST_COMPILER`\ 指定，其中\
:variable:`CMAKE_<LANG>_COMPILER_ID`\ 记录了各种可能的编译器。

.. versionadded:: 4.5
  This variable is also available when ``<LANG>`` is ``SYCL`` and
  :variable:`CMAKE_<LANG>_COMPILER_ID` is ``AdaptiveCpp``.  It identifies the
  underlying host compiler used by the AdaptiveCpp driver.

  .. note::
    SYCL support is experimental and gated by ``CMAKE_EXPERIMENTAL_SYCL``.
