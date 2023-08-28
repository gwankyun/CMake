CMAKE_PROGRAM_PATH
------------------

.. include:: ENV_VAR.txt

可以将\ ``CMAKE_PROGRAM_PATH``\ 环境变量设置为\ :command:`find_program`\ 命令要搜索\
的目录列表。

This variable may hold a single directory or a list of directories separated
by ``:`` on UNIX or ``;`` on Windows (the same as the ``PATH`` environment
variable convention on those platforms).

See also the :variable:`CMAKE_PROGRAM_PATH` CMake variable.
