PRECOMPILE_HEADERS
------------------

.. versionadded:: 3.16

要预编译的头文件列表。

This property holds a :ref:`semicolon-separated list <CMake Language Lists>`
of header files to precompile specified so far for its target.
Use the :command:`target_precompile_headers` command to append more header
files.

This property supports
:manual:`generator expressions <cmake-generator-expressions(7)>`.
