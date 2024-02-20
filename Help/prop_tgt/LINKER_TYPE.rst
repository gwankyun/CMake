LINKER_TYPE
-----------

.. versionadded:: 3.29

指定链接步骤将使用哪个链接器。属性值可以使用\
:manual:`生成器表达式 <cmake-generator-expressions(7)>`。

.. code-block:: cmake

  add_library(lib1 SHARED ...)
  set_property(TARGET lib1 PROPERTY LINKER_TYPE LLD)

This specifies that ``lib1`` should use linker type ``LLD`` for the link step.
The implementation details will be provided by the variable
:variable:`CMAKE_<LANG>_USING_LINKER_<TYPE>` with ``<TYPE>`` having the value
``LLD``.

This property is not supported on :generator:`Green Hills MULTI` and
:generator:`Visual Studio 9 2008` generators.

.. note::
  It is assumed that the linker specified is fully compatible with the standard
  one. CMake will not do any options translation.

.. include:: ../variable/LINKER_PREDEFINED_TYPES.txt
