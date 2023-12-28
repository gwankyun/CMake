CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE
----------------------------------------

是否强制添加项目包含目录。

This variable affects the order of include directories generated in compiler
command lines.  If set to ``ON``, it causes the :variable:`CMAKE_SOURCE_DIR`
and the :variable:`CMAKE_BINARY_DIR` to appear first.
