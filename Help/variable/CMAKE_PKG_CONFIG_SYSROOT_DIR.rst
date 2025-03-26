CMAKE_PKG_CONFIG_SYSROOT_DIR
----------------------------

.. versionadded:: 4.0

默认情况下，此路径会被预先添加到由\ :command:`cmake_pkg_config`\ 命令提取的\ ``-I``\
包含目录和\ ``-L``\ 库目录之前。该路径还用于推导\ ``pc_sysrootdir``\ 包变量。
