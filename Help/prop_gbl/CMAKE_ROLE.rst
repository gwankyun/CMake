CMAKE_ROLE
----------

.. versionadded:: 3.14

告诉当前运行的脚本处于什么模式。可以是以下值之一：

``PROJECT``
  Running in project mode (processing a ``CMakeLists.txt`` file).

``SCRIPT``
  Running in ``-P`` script mode.

``FIND_PACKAGE``
  Running in ``--find-package`` mode.

``CTEST``
  Running in CTest script mode.

``CPACK``
  Running in CPack.
