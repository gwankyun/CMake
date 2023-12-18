CMAKE_CURRENT_LIST_LINE
-----------------------

正在处理的当前文件的行号。

This is the line number of the file currently being processed by
cmake.

If CMake is currently processing deferred calls scheduled by
the :command:`cmake_language(DEFER)` command, this variable
evaluates to ``DEFERRED`` instead of a specific line number.
