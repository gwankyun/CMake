ISPC_HEADER_DIRECTORY
---------------------

.. versionadded:: 3.19

为目标提供的ISPC标头指定相对输出目录。

If the target contains ISPC source files, this specifies the directory in which
the generated headers will be placed. Relative paths are treated with respect to
the value of :variable:`CMAKE_CURRENT_BINARY_DIR`. When this property is not set, the
headers will be placed a generator defined build directory. If the variable
:variable:`CMAKE_ISPC_HEADER_DIRECTORY` is set when a target is created
its value is used to initialize this property.
