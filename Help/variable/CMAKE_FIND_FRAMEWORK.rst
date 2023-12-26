CMAKE_FIND_FRAMEWORK
--------------------

.. versionadded:: 3.4

这个变量影响\ ``find_*``\ 命令如何在macOS框架和unix风格的包组件之间进行选择。

On Darwin or systems supporting macOS Frameworks, the
``CMAKE_FIND_FRAMEWORK`` variable can be set to empty or
one of the following:

``FIRST``
  Try to find frameworks before standard libraries or headers.
  This is the default on Darwin.

``LAST``
  Try to find frameworks after standard libraries or headers.

``ONLY``
  Only try to find frameworks.

``NEVER``
  Never try to find frameworks.
