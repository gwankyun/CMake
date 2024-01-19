CMAKE_<LANG>_CLANG_TIDY
-----------------------

.. versionadded:: 3.6

当\ ``<LANG>``\ 为\ ``C``、\ ``CXX``、\ ``OBJC``\ 或\ ``OBJCXX``\ 时，\
:prop_tgt:`<LANG>_CLANG_TIDY`\ 目标属性的默认值。

This variable is used to initialize the property on each target as it is
created.  For example:

.. code-block:: cmake

  set(CMAKE_CXX_CLANG_TIDY clang-tidy -checks=-*,readability-*)
  add_executable(foo foo.cxx)
