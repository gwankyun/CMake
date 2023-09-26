CMAKE_CONFIGURE_DEPENDS
-----------------------

告诉CMake关于配置过程的额外输入文件。如果任何命名文件被修改，构建系统将重新运行CMake来重新\
配置文件并再次生成构建系统。

Specify files as a semicolon-separated list of paths.  Relative paths
are interpreted as relative to the current source directory.
