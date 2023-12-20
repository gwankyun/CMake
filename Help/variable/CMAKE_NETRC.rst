CMAKE_NETRC
-----------

.. versionadded:: 3.11

该变量用于初始化\ :command:`file(DOWNLOAD)`\ 和\ :command:`file(UPLOAD)`\ 命令的\
``NETRC``\ 选项。有关其他信息，请参见这些命令。

This variable is also used by the :module:`ExternalProject` and
:module:`FetchContent` modules for internal calls to :command:`file(DOWNLOAD)`.

The local option takes precedence over this variable.
