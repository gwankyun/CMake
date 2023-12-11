SKIP_PRECOMPILE_HEADERS
-----------------------

.. versionadded:: 3.16

这个源文件是否被\ :prop_tgt:`PRECOMPILE_HEADERS`\ 特性跳过？

This property helps with build problems that one would run into
when using the :prop_tgt:`PRECOMPILE_HEADERS` feature.

One example would be the usage of Objective-C (``*.m``) files, and
Objective-C++ (``*.mm``) files, which lead to compilation failure
because they are treated (in case of Ninja / Makefile generator)
as C, and CXX respectively. The precompile headers are not
compatible between languages.
