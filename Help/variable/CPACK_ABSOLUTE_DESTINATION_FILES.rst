CPACK_ABSOLUTE_DESTINATION_FILES
--------------------------------

使用\ ``ABSOLUTE DESTINATION``\ 路径安装的文件列表。

This variable is a Read-Only variable which is set internally by CPack
during installation and before packaging using
:variable:`CMAKE_ABSOLUTE_DESTINATION_FILES` defined in ``cmake_install.cmake``
scripts.  The value can be used within CPack project configuration
file and/or ``CPack<GEN>.cmake`` file of ``<GEN>`` generator.
