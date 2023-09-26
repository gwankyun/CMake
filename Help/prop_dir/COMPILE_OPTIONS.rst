COMPILE_OPTIONS
---------------

要传递给编译器的选项列表。

This property holds a :ref:`semicolon-separated list <CMake Language Lists>` of options
given so far to the :command:`add_compile_options` command.

This property is used to initialize the :prop_tgt:`COMPILE_OPTIONS` target
property when a target is created, which is used by the generators to set
the options for the compiler.

Contents of ``COMPILE_OPTIONS`` may use "generator expressions" with the
syntax ``$<...>``.  See the :manual:`cmake-generator-expressions(7)` manual
for available expressions.  See the :manual:`cmake-buildsystem(7)` manual
for more on defining buildsystem properties.
