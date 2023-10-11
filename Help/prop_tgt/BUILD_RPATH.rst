BUILD_RPATH
-----------

.. versionadded:: 3.8

一个\ :ref:`分号分隔的列表 <CMake Language Lists>`，指定要添加到构建树中链接的二进制文\
件中的运行时路径（\ ``RPATH``\ ）条目（对于支持它的平台）。默认情况下，CMake在构建树中设\
置二进制文件的运行时路径，以包含它知道需要查找它们链接的共享库的搜索路径。项目可以设置\
``BUILD_RPATH``\ 来指定额外的搜索路径。

The build-tree runtime path will *not* be used for binaries in the
install tree.  It will be replaced with the install-tree runtime path
during the installation step.  See also the :prop_tgt:`INSTALL_RPATH`
target property.

This property is initialized by the value of the variable
:variable:`CMAKE_BUILD_RPATH` if it is set when a target is created.

This property supports
:manual:`generator expressions <cmake-generator-expressions(7)>`.

Other settings that affect the build-tree runtime path include:

* The :variable:`CMAKE_SKIP_RPATH` variable completely disables runtime
  paths in both the build tree and install tree.

* The :prop_tgt:`SKIP_BUILD_RPATH` target property disables setting any
  runtime path in the build tree.

* The :prop_tgt:`BUILD_RPATH_USE_ORIGIN` target property causes the
  automatically-generated runtime path to use entries relative to ``$ORIGIN``.

* The :prop_tgt:`BUILD_WITH_INSTALL_RPATH` target property causes binaries
  in the build tree to be built with the install-tree runtime path.
