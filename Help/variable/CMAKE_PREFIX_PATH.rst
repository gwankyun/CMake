CMAKE_PREFIX_PATH
-----------------

由\ :command:`find_package`、\ :command:`find_program`、\ :command:`find_library`、\
:command:`find_file`\ 和\ :command:`find_path`\ 命令搜索的指定安装\ *前缀*\ 的目录\
:ref:`分号分隔列表 <CMake Language Lists>`。每个命令都将添加相应的子目录（如\ ``bin``、\
``lib``\ 或\ ``include``），这是在其自己的文档中指定的。

By default this is empty.  It is intended to be set by the project.

There is also an environment variable :envvar:`CMAKE_PREFIX_PATH`, which is used
as an additional list of search prefixes.

See also :variable:`CMAKE_SYSTEM_PREFIX_PATH`, :variable:`CMAKE_INCLUDE_PATH`,
:variable:`CMAKE_LIBRARY_PATH`, :variable:`CMAKE_PROGRAM_PATH`, and
:variable:`CMAKE_IGNORE_PATH`.
