CMAKE_FIND_ROOT_PATH
--------------------

要在文件系统上搜索的根路径\ :ref:`分号分隔列表 <CMake Language Lists>`。

This variable is most useful when cross-compiling. CMake uses the paths in
this list as alternative roots to find filesystem items with
:command:`find_package`, :command:`find_library` etc.
