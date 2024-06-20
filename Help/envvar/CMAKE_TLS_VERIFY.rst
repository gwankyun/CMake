CMAKE_TLS_VERIFY
----------------

.. versionadded:: 3.30

.. include:: ENV_VAR.txt

指定\ :command:`file(DOWNLOAD)`\ 和\ :command:`file(UPLOAD)`\ 命令的\ ``TLS_VERIFY``\
选项的默认值。如果没有指定该选项，并且没有设置\ :variable:`CMAKE_TLS_VERIFY` cmake变量，\
则使用该环境变量。

This variable is also used by the :module:`ExternalProject` and
:module:`FetchContent` modules for internal calls to
:command:`file(DOWNLOAD)` and ``git clone``.
