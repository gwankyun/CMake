CMAKE_TRY_COMPILE_TARGET_TYPE
-----------------------------

.. versionadded:: 3.6

使用源文件签名为\ :command:`try_compile`\ 调用生成的目标类型。有效值为：

``EXECUTABLE``
  Use :command:`add_executable` to name the source file in the
  generated project.  This is the default if no value is given.

``STATIC_LIBRARY``
  Use :command:`add_library` with the ``STATIC`` option to name the
  source file in the generated project.  This avoids running the
  linker and is intended for use with cross-compiling toolchains
  that cannot link without custom flags or linker scripts.
