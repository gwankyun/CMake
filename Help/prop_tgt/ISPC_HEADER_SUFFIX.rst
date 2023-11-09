ISPC_HEADER_SUFFIX
------------------

.. versionadded:: 3.19.2

指定输出后缀，用于由目标提供的ISPC生成的头文件。

This property is initialized by the value of the :variable:`CMAKE_ISPC_HEADER_SUFFIX`
variable if it is set when a target  is created.

If the target contains ISPC source files, this specifies the header suffix to
be used for the generated headers.

The default value is ``_ispc.h``.
