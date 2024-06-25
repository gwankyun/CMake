CMAKE_TLS_VERSION
-----------------

.. versionadded:: 3.30

指定\ :command:`file(DOWNLOAD)`\ 和\ :command:`file(UPLOAD)`\ 命令的\ ``TLS_VERSION``\
选项的默认值。如果没有设置该变量，命令会检查环境变量\ :envvar:`CMAKE_TLS_VERSION`。

The value may be one of:

.. include:: CMAKE_TLS_VERSION-VALUES.txt

This variable is also used by the :module:`ExternalProject` and
:module:`FetchContent` modules for internal calls to
:command:`file(DOWNLOAD)` and ``git clone``.
