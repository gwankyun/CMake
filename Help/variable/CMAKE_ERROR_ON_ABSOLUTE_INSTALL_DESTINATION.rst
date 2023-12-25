CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION
-------------------------------------------

让\ ``cmake_install.cmake``\ 脚本一旦遇到具有绝对\ ``INSTALL DESTINATION``\ 的文件，\
就报错。

The fatal error is emitted before the installation of the offending
file takes place.  This variable is used by CMake-generated
``cmake_install.cmake`` scripts.  If one sets this variable to ``ON`` while
running the script, it may get fatal error messages from the script.
