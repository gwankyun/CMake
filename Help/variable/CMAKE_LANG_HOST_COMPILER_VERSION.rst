CMAKE_<LANG>_HOST_COMPILER_VERSION
----------------------------------

.. versionadded:: 3.31

当\ ``<LANG>``\ 是\ ``CUDA``\ 或\ ``HIP``\ 且\ :variable:`CMAKE_<LANG>_COMPILER_ID`\
是\ ``NVIDIA``\ 时，此变量可用。它包含了\ ``nvcc``\ 调用的宿主编译器的版本号，默认情况下\
或由\ :variable:`CMAKE_<LANG>_HOST_COMPILER`\ 指定，格式与\
:variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 相同。
