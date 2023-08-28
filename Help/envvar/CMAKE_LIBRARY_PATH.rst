CMAKE_LIBRARY_PATH
------------------

.. include:: ENV_VAR.txt

``CMAKE_LIBRARY_PATH``\ 环境变量可以设置为\ :command:`find_library`\ 命令要搜索的目\
录列表。

This variable may hold a single directory or a list of directories separated
by ``:`` on UNIX or ``;`` on Windows (the same as the ``PATH`` environment
variable convention on those platforms).

See also the :variable:`CMAKE_LIBRARY_PATH` CMake variable.
