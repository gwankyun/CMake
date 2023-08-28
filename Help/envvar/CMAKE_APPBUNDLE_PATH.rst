CMAKE_APPBUNDLE_PATH
--------------------

.. include:: ENV_VAR.txt

``CMAKE_APPBUNDLE_PATH``\ 环境变量可以设置为一个目录列表，通过\ :command:`find_program`\
和\ :command:`find_package`\ 命令搜索macOS应用程序包。

This variable may hold a single directory or a list of directories separated
by ``:`` on UNIX or ``;`` on Windows (the same as the ``PATH`` environment
variable convention on those platforms).

See also the :variable:`CMAKE_APPBUNDLE_PATH` CMake variable.
