CPACK_WARN_ON_ABSOLUTE_INSTALL_DESTINATION
------------------------------------------

要求CPack在每次遇到具有绝对\ ``INSTALL DESTINATION``\ 的文件时发出警告。

This variable triggers the definition of
:variable:`CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION` when CPack runs
``cmake_install.cmake`` scripts.
