CMAKE_SCRIPT_MODE_FILE
----------------------

当前正在处理的\ :option:`cmake -P`\ 脚本文件的完整路径。

When run in :option:`cmake -P` script mode, CMake sets this variable to
the full path of the script file.  When run to configure a ``CMakeLists.txt``
file, this variable is not set.
