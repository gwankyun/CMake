<LANG>_LINKER_LAUNCHER
----------------------

.. versionadded:: 3.21

该属性仅在\ ``<LANG>``\ 为\ ``C``、\ ``CXX``、\ ``OBJC``\ 或\ ``OBJCXX``\ 时实现

Specify a :ref:`semicolon-separated list <CMake Language Lists>` containing a
command line for a linker launching tool. The :ref:`Makefile Generators` and the
:generator:`Ninja` generator will run this tool and pass the linker and its
arguments to the tool. This is useful for tools such as static analyzers.

This property is initialized by the value of the
:variable:`CMAKE_<LANG>_LINKER_LAUNCHER` variable if it is set when a target is
created.

.. versionadded:: 3.27

  The property value may use
  :manual:`generator expressions <cmake-generator-expressions(7)>`.
