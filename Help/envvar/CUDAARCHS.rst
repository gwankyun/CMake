CUDAARCHS
---------

.. versionadded:: 3.20

.. include:: include/ENV_VAR.rst

在第一次配置时初始化\ :variable:`CMAKE_CUDA_ARCHITECTURES`\ 的值。后续运行将使用存储在\
缓存中的值。

This is a semicolon-separated list of architectures as described in
:prop_tgt:`CUDA_ARCHITECTURES`.
