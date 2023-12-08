WORKING_DIRECTORY
-----------------

将从其中调用测试可执行文件的目录。

If this is not set, the test will be run with the working directory set to the
binary directory associated with where the test was created (i.e. the
:variable:`CMAKE_CURRENT_BINARY_DIR` for where :command:`add_test` was
called).
