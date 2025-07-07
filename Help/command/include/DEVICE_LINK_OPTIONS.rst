主机和设备特定的链接选项
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. versionadded:: 3.18
  当涉及到由\ :prop_tgt:`CUDA_SEPARABLE_COMPILATION`\ 和\
  :prop_tgt:`CUDA_RESOLVE_DEVICE_SYMBOLS`\ 属性和策略\ :policy:`CMP0105`\ 控制的\
  设备链接步骤时，raw选项将被交付给主机和设备链接步骤（包装在\ ``-Xcompiler``\ 中或设备\
  链接的等效版本中）。包含在\ :genex:`$<DEVICE_LINK:...>`\ 生成器表达式中的选项将仅用于\
  设备链接步骤。包含在\ :genex:`$<HOST_LINK:...>`\ 生成器表达式中的选项将仅用于主机链接步骤。
