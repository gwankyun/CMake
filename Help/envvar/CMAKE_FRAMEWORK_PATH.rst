CMAKE_FRAMEWORK_PATH
--------------------

.. include:: ENV_VAR.txt

``CMAKE_FRAMEWORK_PATH``\ 环境变量可以设置为一个目录列表，通过\ :command:`find_library`、\
:command:`find_package`、\ :command:`find_path`\ 和\ :command:`find_file`\ 命令搜\
索macOS框架。


This variable may hold a single directory or a list of directories separated
by ``:`` on UNIX or ``;`` on Windows (the same as the ``PATH`` environment
variable convention on those platforms).

See also the :variable:`CMAKE_FRAMEWORK_PATH` CMake variable.
