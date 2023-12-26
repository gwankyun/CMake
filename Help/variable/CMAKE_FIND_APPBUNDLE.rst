CMAKE_FIND_APPBUNDLE
--------------------

.. versionadded:: 3.4

这个变量影响\ ``find_*``\ 命令如何在macOS应用程序包和unix风格的包组件之间进行选择。

On Darwin or systems supporting macOS Application Bundles, the
``CMAKE_FIND_APPBUNDLE`` variable can be set to empty or
one of the following:

``FIRST``
  Try to find application bundles before standard programs.
  This is the default on Darwin.

``LAST``
  Try to find application bundles after standard programs.

``ONLY``
  Only try to find application bundles.

``NEVER``
  Never try to find application bundles.
