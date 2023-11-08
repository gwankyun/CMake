IMPORTED_NO_SONAME
------------------

指定\ ``IMPORTED``\ 共享库目标没有\ ``soname``.。

Set this property to true for an imported shared library file that has
no ``soname`` field.  CMake may adjust generated link commands for some
platforms to prevent the linker from using the path to the library in
place of its missing ``soname``.  Ignored for non-imported targets.
