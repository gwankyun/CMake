DEFINITIONS
-----------

仅为CMake 2.4兼容。使用\ :prop_dir:`COMPILE_DEFINITIONS`\ 代替。

This read-only property specifies the list of flags given so far to
the :command:`add_definitions` command.  It is intended for debugging
purposes.  Use the :prop_dir:`COMPILE_DEFINITIONS` directory property
instead.

This built-in read-only property does not exist if policy
:policy:`CMP0059` is set to ``NEW``.
