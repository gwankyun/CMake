CMake变量\ :variable:`CMAKE_FIND_ROOT_PATH`\ 指定一个或多个目录，放在所有其他搜索目录\
的前面。这有效地“重新定位”了给定位置下的整个搜索。:variable:`CMAKE_STAGING_PREFIX`\ 的\
后代路径被排除在这种重定根目录之外，因为该变量始终是主机系统上的一个路径。默认情况下，\
:variable:`CMAKE_FIND_ROOT_PATH`\ 为空。

:variable:`CMAKE_SYSROOT`\ 变量也可以指定一个目录作为前缀。设置\ :variable:`CMAKE_SYSROOT`\
还有其他作用。有关该变量的更多信息，请参阅文档。

当交叉编译指向目标环境的根目录时，这些变量特别有用，CMake也会在那里搜索。默认情况下，首先搜索\
:variable:`CMAKE_FIND_ROOT_PATH`\ 中列出的目录，然后搜索\ :variable:`CMAKE_SYSROOT`\
目录，然后搜索非根目录。可以通过设置\ |CMAKE_FIND_ROOT_PATH_MODE_XXX|\ 来调整默认行为。\
这种行为可以使用选项手动覆盖每次调用的基础：

``CMAKE_FIND_ROOT_PATH_BOTH``
  按上述顺序搜索。

``NO_CMAKE_FIND_ROOT_PATH``
  不要使用\ :variable:`CMAKE_FIND_ROOT_PATH`\ 变量。

``ONLY_CMAKE_FIND_ROOT_PATH``
  只搜索重定根目录和\ :variable:`CMAKE_STAGING_PREFIX`\ 以下的目录。
