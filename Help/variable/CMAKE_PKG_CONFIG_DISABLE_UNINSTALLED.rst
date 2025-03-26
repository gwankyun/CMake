CMAKE_PKG_CONFIG_DISABLE_UNINSTALLED
------------------------------------

.. versionadded:: 4.0

启用/禁用\ :command:`cmake_pkg_config`\ 命令默认的“未安装（uninstalled）”搜索行为。\
当此变量为false时，带有“-uninstalled”后缀的包文件比精确匹配包名的文件具有更高的优先级。
