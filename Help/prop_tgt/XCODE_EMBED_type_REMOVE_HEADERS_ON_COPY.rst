XCODE_EMBED_<type>_REMOVE_HEADERS_ON_COPY
-----------------------------------------

.. versionadded:: 3.20

布尔属性，仅由\ :generator:`Xcode`\ 生成器使用。它指定是否从使用\
:prop_tgt:`XCODE_EMBED_<type>`\ 属性嵌入的所有框架中删除头文件。

The supported values for ``<type>`` are:

``FRAMEWORKS``
  If the ``XCODE_EMBED_FRAMEWORKS_REMOVE_HEADERS_ON_COPY`` property is not
  defined, headers will not be removed on copy by default.

``APP_EXTENSIONS``
  .. versionadded:: 3.21

  If the ``XCODE_EMBED_APP_EXTENSIONS_REMOVE_HEADERS_ON_COPY`` property is not
  defined, headers WILL be removed on copy by default.

``EXTENSIONKIT_EXTENSIONS``
  .. versionadded:: 3.26

  If the ``XCODE_EMBED_APP_EXTENSIONS_REMOVE_HEADERS_ON_COPY`` property is not
  defined, headers WILL be removed on copy by default.

``PLUGINS``
  .. versionadded:: 3.23
