CMAKE_<LANG>_SIMULATE_ID
------------------------

“模拟”编译器的标识字符串。

Some compilers simulate other compilers to serve as drop-in
replacements.  When CMake detects such a compiler it sets this
variable to what would have been the :variable:`CMAKE_<LANG>_COMPILER_ID` for
the simulated compiler.

.. note::
  In other words, this variable describes the ABI compatibility
  of the generated code.
