CMAKE_INSTALL_MESSAGE
---------------------

.. versionadded:: 3.1

指定\ :command:`install`\ 命令生成的安装脚本代码的长度（使用\ :command:`file(INSTALL)`\
命令）。对于新安装或更新的路径，安装可能会打印如下行：\ ::

  -- Installing: /some/destination/path

For paths that are already up to date, installation may print
lines like::

  -- Up-to-date: /some/destination/path

The ``CMAKE_INSTALL_MESSAGE`` variable may be set to control
which messages are printed:

``ALWAYS``
  Print both ``Installing`` and ``Up-to-date`` messages.

``LAZY``
  Print ``Installing`` but not ``Up-to-date`` messages.

``NEVER``
  Print neither ``Installing`` nor ``Up-to-date`` messages.

Other values have undefined behavior and may not be diagnosed.

If this variable is not set, the default behavior is ``ALWAYS``.
