CMAKE_PREFIX_PATH
-----------------

.. include:: ENV_VAR.txt

``CMAKE_PREFIX_PATH``\ 环境变量可以设置为指定安装\ *prefixes*\ 的目录列表，这些目录将由\
:command:`find_package`、\ :command:`find_program`、\ :command:`find_library`、\
:command:`find_file`\ 和\ :command:`find_path`\ 命令搜索。每个命令都将添加相应的子目录\
（如\ ``bin``、\ ``lib``\ 或\ ``include``），这是在其自己的文档中指定的。

This variable may hold a single prefix or a list of prefixes separated
by ``:`` on UNIX or ``;`` on Windows (the same as the ``PATH`` environment
variable convention on those platforms).

See also the :variable:`CMAKE_PREFIX_PATH` CMake variable.
