CPACK_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION
-------------------------------------------

一旦遇到具有绝对\ ``INSTALL DESTINATION``\ 的文件，就要求CPack出错。

The fatal error is emitted before the installation of the offending
file takes place.  Some CPack generators, like ``NSIS``, enforce this
internally.  This variable triggers the definition
of :variable:`CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION` when CPack
runs.
