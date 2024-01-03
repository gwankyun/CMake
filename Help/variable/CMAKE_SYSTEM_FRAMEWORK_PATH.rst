CMAKE_SYSTEM_FRAMEWORK_PATH
---------------------------

.. versionadded:: 3.4

查找\ :command:`find_library`、\ :command:`find_package`、\ :command:`find_path`\
和\ :command:`find_file`\ 命令使用的macOS框架的路径。默认情况下，它包含当前系统的标准目\
录。若\ *不*\ 打算被项目修改，请使用\ :variable:`CMAKE_FRAMEWORK_PATH`。
