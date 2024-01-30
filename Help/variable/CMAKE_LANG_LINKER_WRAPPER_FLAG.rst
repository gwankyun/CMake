CMAKE_<LANG>_LINKER_WRAPPER_FLAG
--------------------------------

.. versionadded:: 3.13

定义编译器驱动程序选项的语法，以便将选项传递给链接器工具。它将用于转换链接选项中的\ ``LINKER:``\
前缀（参见\ :command:`add_link_options`\ 和\ :command:`target_link_options`）。

This variable holds a :ref:`semicolon-separated list <CMake Language Lists>` of tokens.
If a space (i.e. " ") is specified as last token, flag and ``LINKER:``
arguments will be specified as separate arguments to the compiler driver.
The :variable:`CMAKE_<LANG>_LINKER_WRAPPER_FLAG_SEP` variable can be specified
to manage concatenation of arguments.

For example, for ``Clang`` we have:

.. code-block:: cmake

  set (CMAKE_C_LINKER_WRAPPER_FLAG "-Xlinker" " ")

Specifying ``"LINKER:-z,defs"`` will be transformed in
``-Xlinker -z -Xlinker defs``.

For ``GNU GCC``:

.. code-block:: cmake

  set (CMAKE_C_LINKER_WRAPPER_FLAG "-Wl,")
  set (CMAKE_C_LINKER_WRAPPER_FLAG_SEP ",")

Specifying ``"LINKER:-z,defs"`` will be transformed in ``-Wl,-z,defs``.

And for ``SunPro``:

.. code-block:: cmake

  set (CMAKE_C_LINKER_WRAPPER_FLAG "-Qoption" "ld" " ")
  set (CMAKE_C_LINKER_WRAPPER_FLAG_SEP ",")

Specifying ``"LINKER:-z,defs"`` will be transformed in ``-Qoption ld -z,defs``.
