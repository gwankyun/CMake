Fortran_FORMAT
--------------

设置为\ ``FIXED``\ 或\ ``FREE``\ 以指示Fortran源布局。

This property tells CMake whether a given Fortran source file uses
fixed-format or free-format.  CMake will pass the corresponding format flag
to the compiler.  Consider using the target-wide :prop_tgt:`Fortran_FORMAT`
property if all source files in a target share the same format.

.. note:: For some compilers, ``NAG``, ``PGI`` and ``Solaris Studio``,
          setting this to ``OFF`` will have no effect.
