CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION
------------------------------------------

请求\ ``cmake_install.cmake``\ 脚本在每次遇到具有绝对\ ``INSTALL DESTINATION``\
的文件时发出警告。

This variable is used by CMake-generated ``cmake_install.cmake`` scripts.
If one sets this variable to ``ON`` while running the script, it may get
warning messages from the script.
