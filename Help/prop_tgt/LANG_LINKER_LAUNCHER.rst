<LANG>_LINKER_LAUNCHER
----------------------

.. versionadded:: 3.21

仅当\ ``<LANG>``\ 为以下其中一种语言时，此属性才会生效：

* ``C``

* ``CXX``

* ``CUDA``

  .. versionadded:: 4.1

* ``OBJC``

* ``OBJCXX``

* ``Fortran``

  .. versionadded:: 4.1

* ``HIP``

  .. versionadded:: 4.1

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
