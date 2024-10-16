CMAKE_TLS_VERIFY
----------------

指定\ :command:`file(DOWNLOAD)`\ 和\ :command:`file(UPLOAD)`\ 命令的\ ``TLS_VERIFY``\
选项的默认值。如果没有设置该变量，命令会检查环境变量\ :envvar:`CMAKE_TLS_VERIFY` 。如果\
两者都没有设置，则默认为\ *开启*。

.. versionchanged:: 3.31
  The default is on.  Previously, the default was off.
  Users may set the :envvar:`CMAKE_TLS_VERIFY` environment
  variable to ``0`` to restore the old default.

This variable is also used by the :module:`ExternalProject` and
:module:`FetchContent` modules for internal calls to :command:`file(DOWNLOAD)`.

TLS verification can help provide confidence that one is connecting
to the desired server.  When downloading known content, one should
also use file hashes to verify it.

.. code-block:: cmake

  set(CMAKE_TLS_VERIFY TRUE)
