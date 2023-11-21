MACOSX_BUNDLE
-------------

在macOS或iOS上构建可执行文件作为应用程序包。

When this property is set to ``TRUE`` the executable when built on macOS
or iOS will be created as an application bundle.  This makes it
a GUI executable that can be launched from the Finder.  See the
:prop_tgt:`MACOSX_BUNDLE_INFO_PLIST` target property for information about
creation of the ``Info.plist`` file for the application bundle.
This property is initialized by the value of the variable
:variable:`CMAKE_MACOSX_BUNDLE` if it is set when a target is created.
