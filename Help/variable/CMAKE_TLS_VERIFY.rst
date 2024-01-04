CMAKE_TLS_VERIFY
----------------

指定\ :command:`file(DOWNLOAD)`\ 和\ :command:`file(UPLOAD)`\ 命令的\ ``TLS_VERIFY``\
选项的默认值。如果未设置，则默认为\ *off*。

This variable is also used by the :module:`ExternalProject` and
:module:`FetchContent` modules for internal calls to :command:`file(DOWNLOAD)`.

TLS verification can help provide confidence that one is connecting
to the desired server.  When downloading known content, one should
also use file hashes to verify it.

.. code-block:: cmake

  set(CMAKE_TLS_VERIFY TRUE)
